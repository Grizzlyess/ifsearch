import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../database/db_helper.dart';

class ExportService {
  
  Future<void> exportarParaCSV(bool isVisitante) async {
    try {
      final dbHelper = DatabaseHelper();
      String csvData = '';
      String nomeArquivo = '';

      if (isVisitante) {
        final visitantes = await dbHelper.buscarTodosVisitantes();
        if (visitantes.isEmpty) {
          print('Nenhum visitante para exportar.');
          return;
        }

        nomeArquivo = 'backup_visitantes.csv';
        csvData = 'ID;Data e Hora;Email;Genero;Estado Civil;Faixa Etaria;Escolaridade;Renda;Cidade;Hospedado;Tipo Hospedagem;Local Hospedagem;Qtd Pessoas;Nome Hotel;Dias Visita;Gasto Dia;Como Conheceu;Gostou;Retornar;Recomendaria;Garrafas;Sugestoes\n';
        
        for (var v in visitantes) {
          final sugestoesLimpo = v.sugestoes.replaceAll('\n', ' ').replaceAll(';', ',');
          csvData += '${v.id};${v.dataHora};${v.email};${v.genero};${v.estadoCivil};${v.faixaEtaria};${v.escolaridade};${v.renda};${v.cidade};${v.hospedado};${v.tipoHospedagem};${v.localHospedagem};${v.qtdPessoasHospedadas};${v.nomeHotel};${v.diasVisita};${v.gastoPorDia};${v.comoConheceu};${v.aspectosGostou};${v.pretendeRetornar};${v.recomendaria};${v.iniciativaGarrafas};$sugestoesLimpo\n';
        }
      } else {
        final empreendedores = await dbHelper.buscarTodosEmpreendedores();
        if (empreendedores.isEmpty) {
          print('Nenhum empreendedor para exportar.');
          return;
        }

        nomeArquivo = 'backup_empreendedores.csv';
        csvData = 'ID;Data e Hora;Email;Nome do Negocio;Genero;Categoria;Investimento;Faturamento;Equipe Total;Mulheres;Homens;Gastos Equipe;Familias Beneficiadas;Insumos;Agua;Refri;Cerveja;Suco;Energetico;Drinks;Avaliacao;Apoio;Dificuldades;Quais Dificuldades;Divulgou;Parcerias;Sala Empreendedor;Proximas Edicoes;Outros Eventos;Sugestoes\n';
        
        for (var e in empreendedores) {
          final sugestoesLimpo = e.sugestoes.replaceAll('\n', ' ').replaceAll(';', ',');
          final dificuldadesLimpo = e.quaisDificuldades.replaceAll('\n', ' ').replaceAll(';', ',');
          csvData += '${e.id};${e.dataHora};${e.email};${e.nomeNegocio};${e.genero};${e.categoria};${e.investimento};${e.faturamento};${e.equipeTotal};${e.equipeMulheres};${e.equipeHomens};${e.gastosEquipe};${e.familiasBeneficiadas};${e.localInsumos};${e.unidAgua};${e.unidRefrigerante};${e.unidCerveja};${e.unidSuco};${e.unidEnergetico};${e.unidDrinks};${e.avaliacaoOrganizacao};${e.apoioPrefeitura};${e.dificuldades};$dificuldadesLimpo;${e.divulgouNegocio};${e.parcerias};${e.salaEmpreendedor};${e.proximasEdicoes};${e.outrosEventos};$sugestoesLimpo\n';
        }
      }

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$nomeArquivo';
      final file = File(path);

      await file.writeAsString(csvData);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(path)],
          text: 'Aqui está o backup do formulário em Excel!',
        )
      );
      
    } catch (e) {
      print('Erro ao exportar CSV: $e');
    }
  }
}