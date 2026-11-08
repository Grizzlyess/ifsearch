import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/db_helper.dart';

class SyncService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Substitua pela URL da sua API backend
  final String apiUrl = 'https://script.google.com/macros/s/AKfycbxc6zCK0ZsCYFr479xzvodFaDzMYChqVI-0vKogVaPJlDZngzWFOnwoPqmLUe91PJ6l/exec';

  Future<void> sincronizarDados() async {
    // 1. Checa se o dispositivo possui conexão ativa
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return; // Offline: encerra sem tentar envio
    }

    // 2. Obtém os registros pendentes no banco local
    final pendentes = await _dbHelper.buscarPendentesSincronizacao();
    if (pendentes.isEmpty) return;

    // 3. Itera e envia cada registro pendente
    for (var visitante in pendentes) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(visitante.toMap()),
        );

        // Se o servidor aceitou o registro (200 ou 201), marca como sincronizado localmente
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (visitante.id != null) {
            await _dbHelper.marcarComoSincronizado(visitante.id!);
          }
        }
      } catch (e) {
        break;
      }
    }
  }

  // Monitora alterações na rede em tempo real
  void iniciarMonitoramento() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        sincronizarDados();
      }
    });
  }
}