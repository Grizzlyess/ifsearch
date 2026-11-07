import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/visitante_model.dart';

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

  // Função para guardar na base de dados
  Future<void> _salvarFormulario() async {
    if (_formKey.currentState!.validate()) {
      final visitante = VisitanteModel(
        email: _emailController.text,
        genero: _generoSelecionado ?? 'Não informado',
        estadoCivil: _estadoCivilSelecionado ?? 'Não informado',
        faixaEtaria: _faixaEtariaSelecionada ?? 'Não informado',
        escolaridade: _escolaridadeSelecionada ?? 'Não informado',
        renda: _rendaSelecionada ?? 'Não informado',
        cidade: _cidadeController.text,
        hospedado: _hospedadoSelecionado ?? 'Não informado',
        diasVisita: _diasVisitaSelecionado ?? 'Não informado',
        gastoPorDia: _gastoPorDiaSelecionado ?? 'Não informado',
        //comoConheceu: _comoConheceu.join(', '),
        comoConheceu: [..._comoConheceu, if (_isOutroComoConheceuSelected && _outroComoConheceuController.text.isNotEmpty) _outroComoConheceuController.text].join(', '), 
        //aspectosGostou: _aspectosGostouController.text,
        aspectosGostou: [..._aspectosGostou, if (_isOutroAspectoSelected && _outroAspectoController.text.isNotEmpty) _outroAspectoController.text].join(', '),
        pretendeRetornar: _pretendeRetornarSelecionado ?? 'Não informado',
        recomendaria: _recomendariaSelecionado ?? 'Não informado',
        iniciativaGarrafas: _iniciativaGarrafasSelecionada ?? 'Não informado',
        sugestoes: _sugestoesController.text,
      );

      final db = DatabaseHelper();
      await db.inserirVisitante(visitante);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resposta salva offline com sucesso!')),
        );
        
        // Limpar o formulário após guardar
        _formKey.currentState!.reset();
        _emailController.clear();
        _cidadeController.clear();
        _aspectosGostouController.clear();
        _sugestoesController.clear();
        setState(() {
          _generoSelecionado = null;
          _estadoCivilSelecionado = null;
          _faixaEtariaSelecionada = null;
          _escolaridadeSelecionada = null;
          _rendaSelecionada = null;
          _hospedadoSelecionado = null;
          _diasVisitaSelecionado = null;
          _gastoPorDiaSelecionado = null;
          _pretendeRetornarSelecionado = null;
          _recomendariaSelecionado = null;
          _iniciativaGarrafasSelecionada = null;
          _comoConheceu.clear();
          _aspectosGostou.clear();
          _isOutroAspectoSelected = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisa de Visitantes')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [

            // 1. EMAIL:
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '1. E-mail do Pesquisador', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),


            // 2. GENERO:
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '2. Gênero', border: OutlineInputBorder()),
              initialValue: _generoSelecionado,
              items: ['Feminino', 'Masculino', 'Prefiro não responder', 'Outro']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _generoSelecionado = val),
            ),

            if (_generoSelecionado == 'Outro') ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _cidadeController,
              decoration: const InputDecoration(labelText: 'Por favor, especifique', border: OutlineInputBorder()),
            ),
            ],
            const SizedBox(height: 16),


            // 3. Estado Civil:
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '3. Estado Civil', border: OutlineInputBorder()),
              initialValue: _estadoCivilSelecionado,
              items: ['Solteiro(a)', 'Casado(a)', 'Divorciado(a)', 'Viúvo(a)', 'União estável']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _estadoCivilSelecionado = val),
            ),
            const SizedBox(height: 16),


            // 4. Faixa Etária:
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '4. Faixa Etária', border: OutlineInputBorder()),
              initialValue: _faixaEtariaSelecionada,
              items: ['Menos de 18 anos','18 a 24', '25 a 34', '35 a 44', '45 a 54', '55 a 64 anos', '65 anos ou mais']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _faixaEtariaSelecionada = val),
            ),
            const SizedBox(height: 16),


            //5.Escolaridade:
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '5. Escolaridade', border: OutlineInputBorder()),
              initialValue: _escolaridadeSelecionada,
              items: ['Ensino Fundamental Incompleto', 'Ensino Fundamental Completo', 'Ensino Fundamental Completo', 'Ensino Médio Completo',
              'Ensino Superior Incompleto', 'Ensino Superior Completo', 'Pós-graduação (Especialização, Mestrado, Doutorado, etc.)', 'Sem instrução']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _escolaridadeSelecionada = val),
            ),
            const SizedBox(height: 16),


            //6.Renda:
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '6. Renda', border: OutlineInputBorder()),
              initialValue: _rendaSelecionada,
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


            //7. Você é de qual cidade?
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '7. Você é de qual cidade?', border: OutlineInputBorder()),
              initialValue: _cidadeSelecionada,
              items: ['Aracati', 'Fortim', 'Icapuí', 'Fortaleza', 'Itaiçaba', 'Outro']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _cidadeSelecionada = val),
            ),
            
            if (_cidadeSelecionada == 'Outro') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(labelText: 'Qual? (Escreva a cidade)', border: OutlineInputBorder()),
              ),
            ],
            const SizedBox(height: 16),


          // 8. Está hospedado?
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '8. Você está hospedado em algum lugar durante o festival?', border: OutlineInputBorder()),
              initialValue: _hospedadoSelecionado,
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
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            // O bloco abaixo SÓ APARECE se a resposta à Q8 for 'Sim'
            if (_hospedadoSelecionado == 'Sim') ...[
              const Divider(thickness: 2), // Uma linha para separar visualmente
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Sobre a Hospedagem', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              
              // 9. Tipo de Hospedagem
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '9. Qual tipo de hospedagem você está utilizando?', border: OutlineInputBorder()),
                initialValue: _tipoHospedagemSelecionado,
                items: ['Hotel', 'Pousada', 'Airbnb / Aluguel de temporada', 'Casa de familiares/amigos', 'Outro']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (val) => setState(() => _tipoHospedagemSelecionado = val),
              ),
              if (_tipoHospedagemSelecionado == 'Outro') ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _outroTipoHospedagemController,
                  decoration: const InputDecoration(labelText: 'Qual? (Escreva o tipo)', border: OutlineInputBorder()),
                ),
              ],
              const SizedBox(height: 16),

              // 10. Localização da Hospedagem
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '10. Onde está localizada a sua hospedagem?', border: OutlineInputBorder()),
                initialValue: _localHospedagemSelecionado,
                items: ['Aracati', 'Canoa Quebrada', 'Majorlândia', 'Quixaba', 'Outro']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (val) => setState(() => _localHospedagemSelecionado = val),
              ),
              if (_localHospedagemSelecionado == 'Outro') ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _outroLocalHospedagemController,
                  decoration: const InputDecoration(labelText: 'Qual? (Escreva o local)', border: OutlineInputBorder()),
                ),
              ],
              const SizedBox(height: 16),

              // 11. Quantas pessoas
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '11. Quantas pessoas estão hospedadas com você?', border: OutlineInputBorder()),
                initialValue: _qtdPessoasHospedadas,
                items: ['1', '2', '3', '4', '5 ou mais']
                    .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                    .toList(),
                onChanged: (val) => setState(() => _qtdPessoasHospedadas = val),
              ),
              const SizedBox(height: 16),

              // 12. Nome do Hotel/Pousada (Só aparece se a Q9 for Hotel ou Pousada)
              if (_tipoHospedagemSelecionado == 'Hotel' || _tipoHospedagemSelecionado == 'Pousada') ...[
                TextFormField(
                  controller: _nomeHotelController,
                  decoration: const InputDecoration(labelText: '12. Qual o nome do Hotel/Pousada que você está hospedado?', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
              ],
              const Divider(thickness: 2),
            ],


            //Sobre o Festival
            //13.Quantos dias visitará o festival?
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: '13. Quantos dias visitará o festival?', 
                border: OutlineInputBorder()
              ),
              initialValue: _diasVisitaSelecionado,
              items: ['1', '2', '3']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _diasVisitaSelecionado = val),
            ),
            const SizedBox(height: 16),


            // 14. Quanto pretende gastar por dia no festival?
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: '14. Quanto pretende gastar por dia no festival?', 
                border: OutlineInputBorder()
              ),
              initialValue: _gastoPorDiaSelecionado,
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
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '17. Você pretende retornar ao Festival Gastronômico e Cultural de Aracati em edições futuras?', border: OutlineInputBorder()),
              initialValue: _pretendeRetornarSelecionado,
              items: ['Sim, com certeza', 'Talvez, dependendo da programação', 'Não tenho certeza', 'Não, não pretendo']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _pretendeRetornarSelecionado = val),
            ),
            const SizedBox(height: 16),


            //18. Você recomendaria o Festival Gastronômico e Cultural de Aracati para outras pessoas?
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '18. Você recomendaria o Festival Gastronômico e Cultural de Aracati para outras pessoas?', border: OutlineInputBorder()),
              initialValue: _pretendeRetornarSelecionado,
              items: ['Sim, com certeza', 'Talvez, dependendo da pessoa', 'Não, não recomendaria']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _pretendeRetornarSelecionado = val),
            ),
            const SizedBox(height: 16),


            //19. Como você considera a iniciativa da organização em evitar a comercialização de garrafas de vidro no evento pensando na segurança e no meio ambiente?
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '19. Como você considera a iniciativa da organização em evitar a comercialização de garrafas de vidro no evento pensando na segurança e no meio ambiente?', border: OutlineInputBorder()),
              initialValue: _pretendeRetornarSelecionado,
              items: ['Sim, com certeza', 'Talvez, dependendo da pessoa', 'Não, não recomendaria']
                  .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                  .toList(),
              onChanged: (val) => setState(() => _pretendeRetornarSelecionado = val),
            ),
            const SizedBox(height: 16),

            //20. Que sugestões você gostaria de deixar para melhorar o Festival Gastronômico e Cultural de Aracati nas próximas edições?
            TextFormField(
              controller: _sugestoesController,
              decoration: const InputDecoration(labelText: '20. Que sugestões você gostaria de deixar para melhorar o Festival Gastronômico e Cultural de Aracati nas próximas edições?', border: OutlineInputBorder()),
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
    );
  }
}