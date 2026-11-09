import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/visitante_model.dart';
import '../models/empreendedor_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
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
        sugestoes TEXT,
        dataHora TEXT,
        sincronizado INTEGER DEFAULT 0
      )
    ''');

    // Tabela 2: Empreendedores
    await db.execute('''
      CREATE TABLE empreendedores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dataHora TEXT,
        email TEXT,
        nomeNegocio TEXT,
        genero TEXT,
        categoria TEXT,
        investimento TEXT,
        faturamento TEXT,
        equipeTotal TEXT,
        equipeMulheres TEXT,
        equipeHomens TEXT,
        gastosEquipe TEXT,
        familiasBeneficiadas TEXT,
        localInsumos TEXT,
        unidAgua TEXT,
        unidRefrigerante TEXT,
        unidCerveja TEXT,
        unidSuco TEXT,
        unidEnergetico TEXT,
        unidDrinks TEXT,
        avaliacaoOrganizacao TEXT,
        apoioPrefeitura TEXT,
        dificuldades TEXT,
        quaisDificuldades TEXT,
        divulgouNegocio TEXT,
        parcerias TEXT,
        salaEmpreendedor TEXT,
        proximasEdicoes TEXT,
        outrosEventos TEXT,
        sugestoes TEXT,
        sincronizado INTEGER DEFAULT 0
      )
    ''');
  }

  Future<int> inserirVisitante(VisitanteModel visitante) async {
    Database db = await database;
    return await db.insert('visitantes', visitante.toMap());
  }

  Future<List<Map<String, dynamic>>> obterVisitantes() async {
    Database db = await database;
    return await db.query('visitantes');
  }

  Future<List<Map<String, dynamic>>> obterEmpreendedores() async {
  Database db = await database;
  return await db.query('empreendedores');
  }

  Future<List<VisitanteModel>> buscarPendentesSincronizacao() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'visitantes',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => VisitanteModel.fromMap(maps[i]));
  }

  Future<void> marcarComoSincronizado(int id) async {
    final db = await database;
    await db.update(
      'visitantes',
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================================
  // FUNÇÕES DO EMPREENDEDOR
  // ==========================================

  Future<int> inserirEmpreendedor(EmpreendedorModel empreendedor) async {
    Database db = await database;
    return await db.insert('empreendedores', empreendedor.toMap());
  }

  Future<List<EmpreendedorModel>> getEmpreendedoresNaoSincronizados() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'empreendedores',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => EmpreendedorModel.fromMap(maps[i]));
  }

  Future<void> marcarEmpreendedorComoSincronizado(int id) async {
    Database db = await database;
    await db.update(
      'empreendedores',
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
 
}