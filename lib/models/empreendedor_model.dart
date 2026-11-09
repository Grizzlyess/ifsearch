class EmpreendedorModel {
  final int? id;
  final String? dataHora;
  final String email;
  final String nomeNegocio;
  final String genero;
  final String categoria;
  final String investimento;
  final String faturamento;
  final String equipeTotal;
  final String equipeMulheres;
  final String equipeHomens;
  final String gastosEquipe;
  final String familiasBeneficiadas;
  final String localInsumos;
  final String unidAgua;
  final String unidRefrigerante;
  final String unidCerveja;
  final String unidSuco;
  final String unidEnergetico;
  final String unidDrinks;
  final String avaliacaoOrganizacao;
  final String apoioPrefeitura;
  final String dificuldades;
  final String quaisDificuldades;
  final String divulgouNegocio;
  final String parcerias;
  final String salaEmpreendedor;
  final String proximasEdicoes;
  final String outrosEventos;
  final String sugestoes;
  final int sincronizado;

  EmpreendedorModel({
    this.id, this.dataHora, required this.email, required this.nomeNegocio,
    required this.genero, required this.categoria, required this.investimento,
    required this.faturamento, required this.equipeTotal, required this.equipeMulheres,
    required this.equipeHomens, required this.gastosEquipe, required this.familiasBeneficiadas,
    required this.localInsumos, required this.unidAgua, required this.unidRefrigerante,
    required this.unidCerveja, required this.unidSuco, required this.unidEnergetico,
    required this.unidDrinks, required this.avaliacaoOrganizacao, required this.apoioPrefeitura,
    required this.dificuldades, required this.quaisDificuldades, required this.divulgouNegocio,
    required this.parcerias, required this.salaEmpreendedor, required this.proximasEdicoes,
    required this.outrosEventos, required this.sugestoes, this.sincronizado = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataHora': dataHora, 'email': email, 'nomeNegocio': nomeNegocio, 'genero': genero,
      'categoria': categoria, 'investimento': investimento, 'faturamento': faturamento,
      'equipeTotal': equipeTotal, 'equipeMulheres': equipeMulheres, 'equipeHomens': equipeHomens,
      'gastosEquipe': gastosEquipe, 'familiasBeneficiadas': familiasBeneficiadas,
      'localInsumos': localInsumos, 'unidAgua': unidAgua, 'unidRefrigerante': unidRefrigerante,
      'unidCerveja': unidCerveja, 'unidSuco': unidSuco, 'unidEnergetico': unidEnergetico,
      'unidDrinks': unidDrinks, 'avaliacaoOrganizacao': avaliacaoOrganizacao,
      'apoioPrefeitura': apoioPrefeitura, 'dificuldades': dificuldades,
      'quaisDificuldades': quaisDificuldades, 'divulgouNegocio': divulgouNegocio,
      'parcerias': parcerias, 'salaEmpreendedor': salaEmpreendedor,
      'proximasEdicoes': proximasEdicoes, 'outrosEventos': outrosEventos,
      'sugestoes': sugestoes, 'sincronizado': sincronizado,
    };
  }

  factory EmpreendedorModel.fromMap(Map<String, dynamic> map) {
    return EmpreendedorModel(
      id: map['id'], dataHora: map['dataHora'], email: map['email'] ?? '',
      nomeNegocio: map['nomeNegocio'] ?? '', genero: map['genero'] ?? '',
      categoria: map['categoria'] ?? '', investimento: map['investimento'] ?? '',
      faturamento: map['faturamento'] ?? '', equipeTotal: map['equipeTotal'] ?? '',
      equipeMulheres: map['equipeMulheres'] ?? '', equipeHomens: map['equipeHomens'] ?? '',
      gastosEquipe: map['gastosEquipe'] ?? '', familiasBeneficiadas: map['familiasBeneficiadas'] ?? '',
      localInsumos: map['localInsumos'] ?? '', unidAgua: map['unidAgua'] ?? '',
      unidRefrigerante: map['unidRefrigerante'] ?? '', unidCerveja: map['unidCerveja'] ?? '',
      unidSuco: map['unidSuco'] ?? '', unidEnergetico: map['unidEnergetico'] ?? '',
      unidDrinks: map['unidDrinks'] ?? '', avaliacaoOrganizacao: map['avaliacaoOrganizacao'] ?? '',
      apoioPrefeitura: map['apoioPrefeitura'] ?? '', dificuldades: map['dificuldades'] ?? '',
      quaisDificuldades: map['quaisDificuldades'] ?? '', divulgouNegocio: map['divulgouNegocio'] ?? '',
      parcerias: map['parcerias'] ?? '', salaEmpreendedor: map['salaEmpreendedor'] ?? '',
      proximasEdicoes: map['proximasEdicoes'] ?? '', outrosEventos: map['outrosEventos'] ?? '',
      sugestoes: map['sugestoes'] ?? '', sincronizado: map['sincronizado'] ?? 0,
    );
  }
}