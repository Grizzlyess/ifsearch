import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/db_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SyncService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String apiUrl = dotenv.env['GOOGLE_SHEETS_API_URL'] ?? '';

  // A NOSSA TRAVA DE SEGURANÇA
  bool _isSyncing = false;

  Future<void> sincronizarDados() async {
    if (_isSyncing) {
      print("Sincronização já está em andamento. Abortando duplicada.");
      return; 
    }
    
    _isSyncing = true; 

    try {
      final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        print("Sincronização cancelada: Sem ligação à internet.");
        return;
      }

      print("URL da API carregada do .env: '$apiUrl'");
      if (apiUrl.isEmpty) {
        print("ERRO CRÍTICO: A URL da API está vazia! O ficheiro .env não foi lido corretamente.");
        return;
      }

      final pendentes = await _dbHelper.buscarPendentesSincronizacao();
      print("Encontrados ${pendentes.length} registos pendentes para enviar.");
      
      if (pendentes.isEmpty) return;

      for (var visitante in pendentes) {
        try {
          print("A tentar enviar o visitante ID: ${visitante.id}...");
          final response = await http.post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(visitante.toMap()),
          );

          print("Resposta do Servidor -> Status: ${response.statusCode} | Body: ${response.body}");

          if (response.statusCode == 200 || response.statusCode == 302) {
            if (visitante.id != null) {
              await _dbHelper.marcarComoSincronizado(visitante.id!);
              print("Visitante ID: ${visitante.id} marcado como sincronizado com sucesso no SQLite!");
            }
          } else {
             print("Falha ao enviar. O servidor rejeitou o envio.");
          }
        } catch (e) {
          print("ERRO DE HTTP/REDE ao enviar visitante: $e");
          break; 
        }
      }
    } catch (e) {
       print("ERRO GERAL no SQLite ou no processo de sincronização: $e");
    } finally {
      _isSyncing = false; 
    }
  }

  void iniciarMonitoramento() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        sincronizarDados();
      }
    });
  }
}