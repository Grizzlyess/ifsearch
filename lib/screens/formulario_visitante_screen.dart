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
  
  // Controladores para campos de texto
  final _emailController = TextEditingController();
  final _cidadeController = TextEditingController();

  // Variáveis para armazenar o estado das opções de seleção
  String? _generoSelecionado;
  String? _faixaEtariaSelecionada;
  
  // Variáveis para Múltipla Escolha (Checkbox)
  List<String> _comoConheceu = [];

  // Função para salvar no banco de dados
  Future<void> _salvarFormulario() async {
    if (_formKey.currentState!.validate()) {
      // Cria o modelo com os dados preenchidos
      final visitante = VisitanteModel(
        email: _emailController.text,
        genero: _generoSelecionado ?? 'Não informado',
        estadoCivil: '', // Adicione as outras variáveis aqui
        faixaEtaria: _faixaEtariaSelecionada ?? 'Não informado',
        escolaridade: '',
        renda: '',
        cidade: _cidadeController.text,
        hospedado: '',
        diasVisita: '',
        gastoPorDia: '',
        comoConheceu: _comoConheceu.join(', '), // Junta as opções com vírgula
        aspectosGostou: '',
        pretendeRetornar: '',
        recomendaria: '',
        iniciativaGarrafas: '',
        sugestoes: '',
      );

      // Instancia o banco e insere os dados
      final db = DatabaseHelper();
      // await db.inserirVisitante(visitante); // Você precisará adicionar este método no db_helper

      // Feedback para o usuário e reset da tela
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resposta salva offline com sucesso!')),
      );
      
      _formKey.currentState!.reset();
      _emailController.clear();
      _cidadeController.clear();
      setState(() {
        _generoSelecionado = null;
        _faixaEtariaSelecionada = null;
        _comoConheceu.clear();
      });
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
            // 1. Campo de Texto (E-mail)
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '1. E-mail', border: OutlineInputBorder()),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 20),

            // 2. Seleção Única (Radio) - Gênero
            const Text('2. Com qual gênero você se identifica?', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text('Feminino'),
              value: 'Feminino',
              groupValue: _generoSelecionado,
              onChanged: (value) => setState(() => _generoSelecionado = value),
            ),
            RadioListTile<String>(
              title: const Text('Masculino'),
              value: 'Masculino',
              groupValue: _generoSelecionado,
              onChanged: (value) => setState(() => _generoSelecionado = value),
            ),
            const SizedBox(height: 20),

            // 15. Múltipla Escolha (Checkbox) - Como conheceu
            const Text('15. Como conheceu o festival?', style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text('Redes sociais (Facebook, Instagram, etc.)'),
              value: _comoConheceu.contains('Redes sociais'),
              onChanged: (bool? checked) {
                setState(() {
                  checked! ? _comoConheceu.add('Redes sociais') : _comoConheceu.remove('Redes sociais');
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Amigos ou familiares'),
              value: _comoConheceu.contains('Amigos ou familiares'),
              onChanged: (bool? checked) {
                setState(() {
                  checked! ? _comoConheceu.add('Amigos ou familiares') : _comoConheceu.remove('Amigos ou familiares');
                });
              },
            ),
            const SizedBox(height: 30),

            // Botão de Salvar
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: _salvarFormulario,
              child: const Text('SALVAR RESPOSTA', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}