import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/visitante_model.dart';
import '../models/empreendedor_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  //static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pesquisa_festival.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela 1: Visitantes
    await db.execute('''
      CREATE TABLE visitantes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        genero TEXT,
        estadoCivil TEXT,
        faixaEtaria TEXT,
        escolaridade TEXT,
        renda TEXT,
        cidade TEXT,
        hospedado TEXT,
        tipoHospedagem TEXT,
        localHospedagem TEXT,
        qtdPessoasHospedadas TEXT,
        nomeHotel TEXT,
        diasVisita TEXT,
        gastoPorDia TEXT,
        comoConheceu TEXT,
        aspectosGostou TEXT,
        pretendeRetornar TEXT,
        recomendaria TEXT,
        iniciativaGarrafas TEXT,
        sugestoes TEXT
      )
    ''');

    // Tabela 2: Empreendedores
    await db.execute('''
      CREATE TABLE empreendedores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nomeNegocio TEXT,
        generoRepresentante TEXT,
        ramo TEXT,
        investimento TEXT,
        faturamento TEXT,
        qtdEquipe INTEGER,
        qtdMulheres INTEGER,
        qtdHomens INTEGER,
        gastosEquipe TEXT,
        familiasBeneficiadas INTEGER,
        localInsumos TEXT,
        unidAgua INTEGER,
        unidRefrigerante INTEGER,
        unidCerveja INTEGER,
        unidSuco INTEGER,
        unidEnergetico INTEGER,
        unidDrinks INTEGER,
        avaliacaoOrganizacao TEXT,
        apoioPrefeitura TEXT,
        enfrentouDificuldade TEXT,
        quaisDificuldades TEXT,
        divulgouNegocio TEXT,
        parcerias TEXT,
        salaEmpreendedor TEXT,
        proximasEdicoes TEXT,
        outrosEventos TEXT,
        sugestoes TEXT
      )
    ''');
  }

  Future<int> inserirVisitante(VisitanteModel visitante) async {
    Database db = await database;
    return await db.insert('visitantes', visitante.toMap());
  }

  Future<int> inserirEmpreendedor(EmpreendedorModel empreendedor) async {
    Database db = await database;
    return await db.insert('empreendedores', empreendedor.toMap());
  }

  Future<List<Map<String, dynamic>>> obterVisitantes() async {
    Database db = await database;
    return await db.query('visitantes');
  }

  Future<List<Map<String, dynamic>>> obterEmpreendedores() async {
  Database db = await database;
  return await db.query('empreendedores');
  }
 
}