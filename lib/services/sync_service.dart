import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/db_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 

class SyncService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String apiUrl = dotenv.env['GOOGLE_SHEETS_API_URL'] ?? '';
  

  final supabase = Supabase.instance.client; 

  bool _isSyncing = false;

  // VISITANTES

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

      final pendentes = await _dbHelper.buscarPendentesSincronizacao();
      print("Encontrados ${pendentes.length} visitantes pendentes para enviar.");
      
      if (pendentes.isEmpty) return;

      for (var visitante in pendentes) {
        bool sucessoPlanilha = false;
        bool sucessoSupabase = false;

        try {
          if (apiUrl.isNotEmpty) {
            print("A tentar enviar o visitante ID: ${visitante.id} para o Sheets...");
            final response = await http.post(
              Uri.parse(apiUrl),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(visitante.toMap()),
            );

            if (response.statusCode == 200 || response.statusCode == 302) {
              sucessoPlanilha = true;
              print("Sucesso no Google Sheets (Visitante)!");
            }
          }
        } catch (e) {
          print("ERRO DE HTTP/REDE ao enviar visitante para o Sheets: $e");
        }


        try {
          final supabase = Supabase.instance.client;

          final dadosSupabase = visitante.toMap(); 
          dadosSupabase.remove('sincronizado');
          dadosSupabase.remove('id'); 

          await supabase.from('visitantes').insert(dadosSupabase);
          sucessoSupabase = true;
          print("Sucesso no Supabase!");
        } catch (e) {
          print("Erro ao enviar para o Supabase: $e");
        }

        if (sucessoPlanilha || sucessoSupabase) {
          if (visitante.id != null) {
            await _dbHelper.marcarComoSincronizado(visitante.id!);
            print("Visitante ID: ${visitante.id} seguro na nuvem e baixado do SQLite!");
          }
        } else {
          print("Falha total: Visitante ID ${visitante.id} não conseguiu chegar nem ao Sheets nem ao Supabase.");
        }
      }
    } catch (e) {
       print("ERRO GERAL no SQLite ou no processo de sincronização de visitantes: $e");
    } finally {
      _isSyncing = false; 
    }
  }


  void iniciarMonitoramento() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        sincronizarDados();
        sincronizarEmpreendedores(); 
      }
    });
  }

  // EMPREENDEDORES
  Future<void> sincronizarEmpreendedores() async {
    final empreendedoresNaoSincronizados = await _dbHelper.getEmpreendedoresNaoSincronizados();

    if (empreendedoresNaoSincronizados.isEmpty) return;

    final String apiUrlEmpreendedores = dotenv.env['GOOGLE_SHEETS_API_EMPREENDEDORES'] ?? '';

    for (var empreendedor in empreendedoresNaoSincronizados) {
      bool sucessoPlanilha = false;
      bool sucessoSupabase = false;

      // Google Sheets

      try {
        if (apiUrlEmpreendedores.isNotEmpty) {
          final response = await http.post(
            Uri.parse(apiUrlEmpreendedores),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(empreendedor.toMap()),
          );

          if (response.statusCode == 200 || response.statusCode == 302) {
            sucessoPlanilha = true;
          }
        }
      } catch (e) {
        print('Erro no Sheets (Empreendedor): $e');
      }

      //SUPABASE
      try {
        final supabase = Supabase.instance.client; 

        final dadosSupabase = empreendedor.toMap(); 
        dadosSupabase.remove('sincronizado');
        dadosSupabase.remove('id'); 

        await supabase.from('empreendedores').insert(dadosSupabase);
        sucessoSupabase = true;
        print("Sucesso no Supabase!");
      } catch (e) {
        print("Erro ao enviar para o Supabase: $e");
      }


      if (sucessoPlanilha || sucessoSupabase) {
        await _dbHelper.marcarEmpreendedorComoSincronizado(empreendedor.id!);
        print('Empreendedor seguro na nuvem: ${empreendedor.nomeNegocio}');
      }
    }
  }
}