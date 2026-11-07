import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> _onCreate(Database db, int version) async {
    // Tabela 1: Visitantes
    await db.execute('''
      CREATE TABLE visitantes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT, genero TEXT, estadoCivil TEXT, faixaEtaria TEXT, 
        escolaridade TEXT, renda TEXT, cidade TEXT, hospedado TEXT, 
        tipoHospedagem TEXT, localHospedagem TEXT, qtdPessoasHospedadas TEXT, 
        nomeHotel TEXT, diasVisita TEXT, gastoPorDia TEXT, comoConheceu TEXT, 
        aspectosGostou TEXT, pretendeRetornar TEXT, recomendaria TEXT, 
        iniciativaGarrafas TEXT, sugestoes TEXT
      )
    ''');

    // Tabela 2: Empreendedores
    await db.execute('''
      CREATE TABLE empreendedores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeNegocio TEXT, generoRepresentante TEXT, ramo TEXT, investimento TEXT, 
        faturamento TEXT, qtdEquipe INTEGER, qtdMulheres INTEGER, qtdHomens INTEGER, 
        gastosEquipe TEXT, familiasBeneficiadas INTEGER, localInsumos TEXT, 
        unidAgua INTEGER, unidRefrigerante INTEGER, unidCerveja INTEGER, 
        unidSuco INTEGER, unidEnergetico INTEGER, unidDrinks INTEGER, 
        avaliacaoOrganizacao TEXT, apoioPrefeitura TEXT, enfrentouDificuldade TEXT, 
        quaisDificuldades TEXT, divulgouNegocio TEXT, parcerias TEXT, 
        salaEmpreendedor TEXT, proximasEdicoes TEXT, outrosEventos TEXT, sugestoes TEXT
      )
    ''');
  }