import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/visitante_model.dart';
import '../services/sync_service.dart';

class FormularioVisitanteScreen extends StatefulWidget {
  const FormularioVisitanteScreen({Key? key}) : super(key: key);

  @override
  State<FormularioVisitanteScreen> createState() => _FormularioVisitanteScreenState();
}

class _FormularioVisitanteScreenState extends State<FormularioVisitanteScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // 1. Controladores para campos de texto
  final _emailController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _aspectosGostouController = TextEditingController();
  final _sugestoesController = TextEditingController();

  // 2. Variáveis para seleções únicas (Dropdowns e Radios)
  String? _generoSelecionado;
  String? _estadoCivilSelecionado;
  String? _faixaEtariaSelecionada;
  String? _escolaridadeSelecionada;
  String? _rendaSelecionada;
  String? _hospedadoSelecionado;
  String? _diasVisitaSelecionado;
  String? _gastoPorDiaSelecionado;
  String? _pretendeRetornarSelecionado;
  String? _recomendariaSelecionado;
  String? _iniciativaGarrafasSelecionada;
  String? _cidadeSelecionada;
  // Variáveis para a secção de Hospedagem (Perguntas 8 a 12)
  String? _tipoHospedagemSelecionado;
  String? _localHospedagemSelecionado;
  String? _qtdPessoasHospedadas;
  final _nomeHotelController = TextEditingController();
  final _outroTipoHospedagemController = TextEditingController();
  final _outroLocalHospedagemController = TextEditingController();

  // Variáveis para a Pergunta 15 (Múltipla Escolha)
  final List<String> _comoConheceu = [];
  bool _isOutroComoConheceuSelected = false; // Controla se a caixa "Outro" está marcada
  final _outroComoConheceuController = TextEditingController();

  // Variáveis para a Pergunta 16 (Múltipla Escolha)
  final List<String> _aspectosGostou = [];
  bool _isOutroAspectoSelected = false;
  final _outroAspectoController = TextEditingController();

  final _outroGeneroController = TextEditingController();

  // Função para guardar na base de dados
  Future<void> _salvarFormulario() async {
    // 1. Fecha o teclado
    FocusScope.of(context).unfocus();

    // 2. TRAVA DE FERRO: Perguntas 1 a 8
    if (_emailController.text.trim().isEmpty ||
        _generoSelecionado == null ||
        (_generoSelecionado == 'Outro' && _outroGeneroController.text.trim().isEmpty) ||
        _estadoCivilSelecionado == null ||
        _faixaEtariaSelecionada == null ||
        _escolaridadeSelecionada == null ||
        _rendaSelecionada == null ||
        _cidadeSelecionada == null ||
        (_cidadeSelecionada == 'Outro' && _cidadeController.text.trim().isEmpty) ||
        _hospedadoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ERRO: Preencha todas as perguntas de 1 a 8.'), backgroundColor: Colors.red));
      return; 
    }

    // 3. TRAVA DE FERRO: Hospedagem
    if (_hospedadoSelecionado == 'Sim') {
      if (_tipoHospedagemSelecionado == null || _localHospedagemSelecionado == null || _qtdPessoasHospedadas == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ERRO: Preencha os dados da hospedagem.'), backgroundColor: Colors.red));
        return;
      }
    }

    // 4. TRAVA DE FERRO: Perguntas 13 e 14
    if (_diasVisitaSelecionado == null || _gastoPorDiaSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ERRO: Responda às perguntas 13 e 14.'), backgroundColor: Colors.red));
      return;
    }

    // 5. TRAVA DE FERRO: Perguntas 15 e 16
    bool p15Respondida = _comoConheceu.isNotEmpty || (_isOutroComoConheceuSelected && _outroComoConheceuController.text.trim().isNotEmpty);
    bool p16Respondida = _aspectosGostou.isNotEmpty || (_isOutroAspectoSelected && _outroAspectoController.text.trim().isNotEmpty);

    if (!p15Respondida) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ERRO: Responda à pergunta 15.'), backgroundColor: Colors.red));
      return; 
    }
    if (!p16Respondida) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ERRO: Responda à pergunta 16.'), backgroundColor: Colors.red));
      return; 
    }

    // 6. TRAVA DE FERRO: Perguntas 17 a 19
    if (_pretendeRetornarSelecionado == null || _recomendariaSelecionado == null || _iniciativaGarrafasSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ERRO: Responda às perguntas 17 a 19.'), backgroundColor: Colors.red));
      return;
    }

    // 7. Validação visual final (Textos curtos, e-mails inválidos, etc.)
    if (!_formKey.currentState!.validate()) {
      return;
    }


    String cidadeFinal = _cidadeSelecionada == 'Outro' ? _cidadeController.text.trim() : (_cidadeSelecionada ?? '');
    String generoFinal = _generoSelecionado == 'Outro' ? _outroGeneroController.text.trim() : (_generoSelecionado ?? '');
    String momentoDaColeta = DateTime.now().toString().split('.')[0];

    final visitante = VisitanteModel(
      email: _emailController.text.trim(),
      genero: generoFinal,
      estadoCivil: _estadoCivilSelecionado!,
      faixaEtaria: _faixaEtariaSelecionada!,
      escolaridade: _escolaridadeSelecionada!,
      renda: _rendaSelecionada!,
      cidade: cidadeFinal,
      hospedado: _hospedadoSelecionado!,
      tipoHospedagem: _tipoHospedagemSelecionado,
      localHospedagem: _localHospedagemSelecionado,
      qtdPessoasHospedadas: _qtdPessoasHospedadas,
      nomeHotel: _nomeHotelController.text.trim(),
      diasVisita: _diasVisitaSelecionado!,
      gastoPorDia: _gastoPorDiaSelecionado!,
      comoConheceu: [..._comoConheceu, if (_isOutroComoConheceuSelected && _outroComoConheceuController.text.isNotEmpty) _outroComoConheceuController.text.trim()].join(', '), 
      aspectosGostou: [..._aspectosGostou, if (_isOutroAspectoSelected && _outroAspectoController.text.isNotEmpty) _outroAspectoController.text.trim()].join(', '),
      pretendeRetornar: _pretendeRetornarSelecionado!,
      recomendaria: _recomendariaSelecionado!,
      iniciativaGarrafas: _iniciativaGarrafasSelecionada!,
      sugestoes: _sugestoesController.text.trim(),
      dataHora: momentoDaColeta,
    );

    final db = DatabaseHelper();
    await db.inserirVisitante(visitante);
    SyncService().sincronizarDados();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resposta salva offline com sucesso!'), backgroundColor: Colors.green),
      );
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _formKey.currentState!.reset();
          _emailController.clear();
          _cidadeController.clear();
          _aspectosGostouController.clear();
          _sugestoesController.clear();
          _outroGeneroController.clear();
          _nomeHotelController.clear();
          _outroTipoHospedagemController.clear();
          _outroLocalHospedagemController.clear();
          _outroComoConheceuController.clear();
          _outroAspectoController.clear();

          setState(() {
            _generoSelecionado = null; _estadoCivilSelecionado = null; _faixaEtariaSelecionada = null;
            _escolaridadeSelecionada = null; _rendaSelecionada = null; _hospedadoSelecionado = null;
            _tipoHospedagemSelecionado = null; _localHospedagemSelecionado = null; _qtdPessoasHospedadas = null;
            _diasVisitaSelecionado = null; _gastoPorDiaSelecionado = null; _pretendeRetornarSelecionado = null;
            _recomendariaSelecionado = null; _iniciativaGarrafasSelecionada = null;
            _comoConheceu.clear(); _aspectosGostou.clear(); _isOutroComoConheceuSelected = false;
            _isOutroAspectoSelected = false; _cidadeSelecionada = null;     
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisa de Visitantes')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView( // <-- MUDANÇA AQUI
          padding: const EdgeInsets.all(16.0),
          child: Column( // <-- MUDANÇA AQUI
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

            // 1. EMAIL:
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '1. E-mail do Pesquisador', border: OutlineInputBorder()),
              validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, especifique';
                  }
                  return null;
                },
            ),
            const SizedBox(height: 16),


            // 2. GÊNERO:
            const Text('2. Com qual gênero você se identifica?', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
               // Garante a sincronização do estado interno
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _generoSelecionado,
              validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
              items: ['Feminino', 'Masculino', 'Prefiro não responder', 'Outro']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _generoSelecionado = val),
            ),
            if (_generoSelecionado == 'Outro') ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _outroGeneroController,
                decoration: const InputDecoration(labelText: 'Por favor, especifique', border: OutlineInputBorder()),
                validator: (value) {
                  if (_generoSelecionado == 'Outro' && (value == null || value.trim().isEmpty)) {
                    return 'Por favor, especifique o gênero';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),


            // 3. ESTADO CIVIL:
            const Text('3. Estado Civil:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _estadoCivilSelecionado,
              validator: (value) => value == null ? 'Campo obrigatório' : null,
              items: ['Solteiro(a)', 'Casado(a)', 'Divorciado(a)', 'Viúvo(a)', 'União estável']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _estadoCivilSelecionado = val),
            ),
            const SizedBox(height: 16),


            // 4. FAIXA ETÁRIA:
            const Text('4. Faixa Etária:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _faixaEtariaSelecionada,
              validator: (value) => value == null ? 'Campo obrigatório' : null,
              items: [
                'Menos de 18 anos', 
                '18 a 24 anos', 
                '25 a 34 anos', 
                '35 a 44 anos', 
                '45 a 54 anos', 
                '55 a 64 anos', 
                '65 anos ou mais' // Corrigido com "anos" para ficar igual ao PDF
              ]
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _faixaEtariaSelecionada = val),
            ),
            const SizedBox(height: 16),


            // 5. ESCOLARIDADE:
            const Text('5. Escolaridade:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _escolaridadeSelecionada,
              validator: (value) => value == null ? 'Campo obrigatório' : null,
              items: [
                'Ensino Fundamental Incompleto', 
                'Ensino Fundamental Completo', 
                'Ensino Médio Incompleto', 
                'Ensino Médio Completo',
                'Ensino Superior Incompleto', 
                'Ensino Superior Completo', 
                'Pós-graduação (Especialização, Mestrado, Doutorado, etc.)', 
                'Sem instrução'
              ]
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _escolaridadeSelecionada = val),
            ),
            const SizedBox(height: 16),


            // 6. RENDA:
            const Text('6. Renda:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()), 
              initialValue: _rendaSelecionada,
              validator: (value) => value == null ? 'Campo obrigatório' : null,
              items: [
                'Até 1 salário mínimo', 
                'De 1 a 2 salários mínimos', 
                'De 2 a 4 salários mínimos', 
                'De 4 a 6 salários mínimos', 
                'De 6 a 10 salários mínimos',
                'Mais de 10 salários mínimos',
                'Prefiro não informar'
              ]
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _rendaSelecionada = val),
            ),
            const SizedBox(height: 16),


            // 7. CIDADE DE ORIGEM:
            const Text('7. Você é de qual cidade?', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _cidadeSelecionada,
              validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
              items: ['Aracati', 'Fortim', 'Icapuí', 'Fortaleza', 'Itaiçaba', 'Outro']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _cidadeSelecionada = val;
                  if (val != 'Outro') {
                    _cidadeController.clear();
                  }
                });
              },
            ),
            if (_cidadeSelecionada == 'Outro') ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(labelText: 'Qual? (Escreva a cidade)', border: OutlineInputBorder()),
                validator: (value) {
                  if (_cidadeSelecionada == 'Outro' && (value == null || value.trim().isEmpty)) {
                    return 'Por favor, digite o nome da sua cidade';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),


            // 8. ESTÁ HOSPEDADO?
            const Text(
              '8. Você está hospedado em algum lugar durante o festival?', 
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _hospedadoSelecionado,
              validator: (value) => value == null ? 'Campo obrigatório' : null,
              items: ['Sim', 'Não']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _hospedadoSelecionado = val;
                  if (val == 'Não') {
                    _tipoHospedagemSelecionado = null;
                    _localHospedagemSelecionado = null;
                    _qtdPessoasHospedadas = null;
                    _nomeHotelController.clear();
                    _outroTipoHospedagemController.clear();
                    _outroLocalHospedagemController.clear();
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            // Bloco condicional da Hospedagem (Perguntas 9 a 12)
            if (_hospedadoSelecionado == 'Sim') ...[
              const Divider(thickness: 1.5),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Sobre a Hospedagem', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              
              // 9. TIPO DE HOSPEDAGEM
              const Text(
                '9. Qual tipo de hospedagem você está utilizando?', 
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                initialValue: _tipoHospedagemSelecionado,
                items: ['Hotel', 'Pousada', 'Airbnb / Aluguel de temporada', 'Casa de familiares/amigos', 'Outro']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _tipoHospedagemSelecionado = val;
                    if (val != 'Hotel' && val != 'Pousada') {
                      _nomeHotelController.clear();
                    }
                    if (val != 'Outro') {
                      _outroTipoHospedagemController.clear();
                    }
                  });
                },
              ),
              if (_tipoHospedagemSelecionado == 'Outro') ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _outroTipoHospedagemController,
                  decoration: const InputDecoration(labelText: 'Qual? (Escreva o tipo)', border: OutlineInputBorder()),
                ),
              ],
              const SizedBox(height: 16),

              // 10. LOCALIZAÇÃO DA HOSPEDAGEM
              const Text(
                '10. Onde está localizada a sua hospedagem?', 
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                initialValue: _localHospedagemSelecionado,
                items: ['Aracati', 'Canoa Quebrada', 'Majorlândia', 'Quixaba', 'Outro']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _localHospedagemSelecionado = val;
                    if (val != 'Outro') {
                      _outroLocalHospedagemController.clear();
                    }
                  });
                },
              ),
              if (_localHospedagemSelecionado == 'Outro') ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _outroLocalHospedagemController,
                  decoration: const InputDecoration(labelText: 'Qual? (Escreva o local)', border: OutlineInputBorder()),
                ),
              ],
              const SizedBox(height: 16),

              // 11. QUANTIDADE DE PESSOAS HOSPEDADAS
              const Text(
                '11. Quantas pessoas estão hospedadas com você?', 
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                initialValue: _qtdPessoasHospedadas,
                items: ['1', '2', '3', '4', '5 ou mais']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (val) => setState(() => _qtdPessoasHospedadas = val),
              ),
              const SizedBox(height: 16),

              // 12. NOME DO HOTEL/POUSADA (condicional a Hotel ou Pousada)
              if (_tipoHospedagemSelecionado == 'Hotel' || _tipoHospedagemSelecionado == 'Pousada') ...[
                const Text(
                  '12. Qual o nome do Hotel/Pousada que você está hospedado?', 
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nomeHotelController,
                  decoration: const InputDecoration(hintText: 'Digite o nome do estabelecimento', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
              ],
              const Divider(thickness: 1.5),
              const SizedBox(height: 8),
            ],

            //Sobre o Festival
            // 13. Quantos dias visitará o festival?
            const Text(
              '13. Quantos dias visitará o festival?', 
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _diasVisitaSelecionado,
              validator: (value) => value == null ? 'Campo obrigatório' : null,
              items: ['1', '2', '3']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _diasVisitaSelecionado = val),
            ),
            const SizedBox(height: 16),

            // 14. Quanto pretende gastar por dia no festival?
            const Text(
              '14. Quanto pretende gastar por dia no festival?', 
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _gastoPorDiaSelecionado,
              validator: (value) => value == null ? 'Campo obrigatório' : null,
              items: [
                'Até R\$ 50,00',
                'De R\$ 51,00 a R\$ 100,00',
                'De R\$ 101,00 a R\$ 200,00',
                'De R\$ 201,00 a R\$ 500,00',
                'Mais de R\$ 500,00'
              ]
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _gastoPorDiaSelecionado = val),
            ),
            const SizedBox(height: 16),


            // 15. Como conheceu o festival?
            const Text('15. Como conheceu o festival?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Marque todas que se aplicam.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            
            ...[
              'Redes sociais (Facebook, Instagram, etc.)',
              'Anúncios na TV',
              'Rádio',
              'Panfletos ou materiais impressos',
              'Amigos ou familiares',
              'Sites ou blogs de turismo',
              'Em outros eventos',
              'Através de hotéis/pousadas',
              'Pesquisando na internet'
            ].map((opcao) {
              return CheckboxListTile(
                title: Text(opcao),
                value: _comoConheceu.contains(opcao),
                controlAffinity: ListTileControlAffinity.leading, 
                onChanged: (bool? checked) {
                  setState(() {
                    if (checked == true) {
                      _comoConheceu.add(opcao); // Adiciona à lista se marcar
                    } else {
                      _comoConheceu.remove(opcao); // Remove da lista se desmarcar
                    }
                  });
                },
              );
            }).toList(),
            
            CheckboxListTile(
              title: const Text('Outro:'),
              value: _isOutroComoConheceuSelected,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? checked) {
                setState(() {
                  _isOutroComoConheceuSelected = checked ?? false;
                  if (!_isOutroComoConheceuSelected) {
                    _outroComoConheceuController.clear();
                  }
                });
              },
            ),

            if (_isOutroComoConheceuSelected) ...[
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 16.0, bottom: 16.0),
                child: TextFormField(
                  controller: _outroComoConheceuController,
                  decoration: const InputDecoration(labelText: 'Especifique como conheceu', border: OutlineInputBorder()),
                ),
              ),
            ],
            const SizedBox(height: 16),


            // 16. Quais aspectos do Festival Gastronômico e Cultural de Aracati você mais gostou?
            const Text('16. Quais aspectos do Festival Gastronômico e Cultural de Aracati você mais gostou?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Marque todas que se aplicam.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            
            ...[
              'Infraestrutura',
              'Programação/Atrações',
              'Valores',
              'Segurança',
              'Limpeza',
              'Hospitalidade',
              'Localização',
              'Qualidade dos produtos e serviços'
            ].map((opcao) {
              return CheckboxListTile(
                title: Text(opcao),
                value: _aspectosGostou.contains(opcao),
                controlAffinity: ListTileControlAffinity.leading, // Quadrado à esquerda
                onChanged: (bool? checked) {
                  setState(() {
                    if (checked == true) {
                      _aspectosGostou.add(opcao);
                    } else {
                      _aspectosGostou.remove(opcao);
                    }
                  });
                },
              );
            }).toList(),
            
            // Opção "Outro:" especial
            CheckboxListTile(
              title: const Text('Outro:'),
              value: _isOutroAspectoSelected,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? checked) {
                setState(() {
                  _isOutroAspectoSelected = checked ?? false;
                  if (!_isOutroAspectoSelected) {
                    _outroAspectoController.clear();
                  }
                });
              },
            ),
            
            // Campo de texto que só aparece se marcar "Outro"
            if (_isOutroAspectoSelected) ...[
              Padding(
                padding: const EdgeInsets.only(left: 48.0, right: 16.0, bottom: 16.0),
                child: TextFormField(
                  controller: _outroAspectoController,
                  decoration: const InputDecoration(labelText: 'Especifique o aspecto', border: OutlineInputBorder()),
                ),
              ),
            ],
            const SizedBox(height: 16),


            //17. Você pretende retornar ao Festival Gastronômico e Cultural de Aracati em edições futuras?
            const Text(
              '17. Você pretende retornar ao Festival Gastronômico e Cultural de Aracati em edições futuras?', 
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()), 
              initialValue: _pretendeRetornarSelecionado,
              validator: (value) => value == null ? 'Campo obrigatório' : null,
              items: ['Sim, com certeza', 'Talvez, dependendo da programação', 'Não tenho certeza', 'Não, não pretendo']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _pretendeRetornarSelecionado = val),
            ),
            const SizedBox(height: 16),


            //18. Você recomendaria o Festival Gastronômico e Cultural de Aracati para outras pessoas?
            const Text(
              '18. Você recomendaria o Festival Gastronômico e Cultural de Aracati para outras pessoas?', 
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _recomendariaSelecionado,
              validator: (value) => value == null ? 'Campo obrigatório' : null,
              items: ['Sim, com certeza', 'Talvez, dependendo da pessoa', 'Não, não recomendaria']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _recomendariaSelecionado = val),
            ),
            const SizedBox(height: 16),


            //19. Como você considera a iniciativa da organização em evitar a comercialização de garrafas de vidro no evento pensando na segurança e no meio ambiente?
            const Text(
              '19. Como você considera a iniciativa da organização em evitar a comercialização de garrafas de vidro no evento pensando na segurança e no meio ambiente?', 
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              initialValue: _iniciativaGarrafasSelecionada,
              validator: (value) => value == null ? 'Campo obrigatório' : null,
              items: ['Concordo totalmente', 'Concordo parcialmente', 'Não concordo, mas entendo o motivo', 'Não concordo', 'Não tenho opinião formada']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _iniciativaGarrafasSelecionada = val),
            ),
            const SizedBox(height: 16),

            //20. Que sugestões você gostaria de deixar para melhorar o Festival Gastronômico e Cultural de Aracati nas próximas edições?
            const Text(
              '20. Que sugestões você gostaria de deixar para melhorar o Festival Gastronômico e Cultural de Aracati nas próximas edições?', 
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _sugestoesController,
              decoration: const InputDecoration(border: OutlineInputBorder()), // Sem labelText aqui também
              maxLines: 3,
            ),
            const SizedBox(height: 30),


            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: _salvarFormulario,
              child: const Text('SALVAR RESPOSTA', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      )
    );
  }
}