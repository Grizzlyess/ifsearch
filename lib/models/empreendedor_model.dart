class EmpreendedorModel {
  final int? id;
  final String nomeNegocio;
  final String generoRepresentante;
  final String ramo;
  final String investimento;
  final String faturamento;
  final int qtdEquipe;
  final int qtdMulheres;
  final int qtdHomens;
  final String gastosEquipe;
  final int familiasBeneficiadas;
  final String localInsumos;
  final int unidAgua;
  final int unidRefrigerante;
  final int unidCerveja;
  final int unidSuco;
  final int unidEnergetico;
  final int unidDrinks;
  final String avaliacaoOrganizacao;
  final String apoioPrefeitura;
  final String enfrentouDificuldade;
  final String? quaisDificuldades;
  final String divulgouNegocio;
  final String parcerias;
  final String salaEmpreendedor;
  final String proximasEdicoes;
  final String outrosEventos;
  final String sugestoes;

  EmpreendedorModel({
    this.id, required this.nomeNegocio, required this.generoRepresentante, 
    required this.ramo, required this.investimento, required this.faturamento, 
    required this.qtdEquipe, required this.qtdMulheres, required this.qtdHomens, 
    required this.gastosEquipe, required this.familiasBeneficiadas, 
    required this.localInsumos, required this.unidAgua, required this.unidRefrigerante, 
    required this.unidCerveja, required this.unidSuco, required this.unidEnergetico, 
    required this.unidDrinks, required this.avaliacaoOrganizacao, 
    required this.apoioPrefeitura, required this.enfrentouDificuldade, 
    this.quaisDificuldades, required this.divulgouNegocio, required this.parcerias, 
    required this.salaEmpreendedor, required this.proximasEdicoes, 
    required this.outrosEventos, required this.sugestoes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, 'nomeNegocio': nomeNegocio, 'generoRepresentante': generoRepresentante,
      'ramo': ramo, 'investimento': investimento, 'faturamento': faturamento,
      'qtdEquipe': qtdEquipe, 'qtdMulheres': qtdMulheres, 'qtdHomens': qtdHomens,
      'gastosEquipe': gastosEquipe, 'familiasBeneficiadas': familiasBeneficiadas,
      'localInsumos': localInsumos, 'unidAgua': unidAgua, 'unidRefrigerante': unidRefrigerante,
      'unidCerveja': unidCerveja, 'unidSuco': unidSuco, 'unidEnergetico': unidEnergetico,
      'unidDrinks': unidDrinks, 'avaliacaoOrganizacao': avaliacaoOrganizacao,
      'apoioPrefeitura': apoioPrefeitura, 'enfrentouDificuldade': enfrentouDificuldade,
      'quaisDificuldades': quaisDificuldades, 'divulgouNegocio': divulgouNegocio,
      'parcerias': parcerias, 'salaEmpreendedor': salaEmpreendedor,
      'proximasEdicoes': proximasEdicoes, 'outrosEventos': outrosEventos, 'sugestoes': sugestoes,
    };
  }
}