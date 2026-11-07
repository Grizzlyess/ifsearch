class VisitanteModel {
  final int? id;
  final String email;
  final String genero;
  final String estadoCivil;
  final String faixaEtaria;
  final String escolaridade;
  final String renda;
  final String cidade;
  final String hospedado; 
  final String? tipoHospedagem; 
  final String? localHospedagem;
  final String? qtdPessoasHospedadas;
  final String? nomeHotel;
  final String diasVisita;
  final String gastoPorDia;
  final String comoConheceu; 
  final String aspectosGostou; 
  final String pretendeRetornar;
  final String recomendaria;
  final String iniciativaGarrafas;
  final String sugestoes;

  VisitanteModel({
    this.id, required this.email, required this.genero, required this.estadoCivil,
    required this.faixaEtaria, required this.escolaridade, required this.renda,
    required this.cidade, required this.hospedado, this.tipoHospedagem,
    this.localHospedagem, this.qtdPessoasHospedadas, this.nomeHotel,
    required this.diasVisita, required this.gastoPorDia, required this.comoConheceu,
    required this.aspectosGostou, required this.pretendeRetornar, 
    required this.recomendaria, required this.iniciativaGarrafas, required this.sugestoes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, 'email': email, 'genero': genero, 'estadoCivil': estadoCivil,
      'faixaEtaria': faixaEtaria, 'escolaridade': escolaridade, 'renda': renda,
      'cidade': cidade, 'hospedado': hospedado, 'tipoHospedagem': tipoHospedagem,
      'localHospedagem': localHospedagem, 'qtdPessoasHospedadas': qtdPessoasHospedadas,
      'nomeHotel': nomeHotel, 'diasVisita': diasVisita, 'gastoPorDia': gastoPorDia,
      'comoConheceu': comoConheceu, 'aspectosGostou': aspectosGostou,
      'pretendeRetornar': pretendeRetornar, 'recomendaria': recomendaria,
      'iniciativaGarrafas': iniciativaGarrafas, 'sugestoes': sugestoes,
    };
  }
}