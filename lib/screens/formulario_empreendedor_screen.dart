import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/empreendedor_model.dart';
import '../services/sync_service.dart';

class FormularioEmpreendedorScreen extends StatefulWidget {
  const FormularioEmpreendedorScreen({Key? key}) : super(key: key);

  @override
  State<FormularioEmpreendedorScreen> createState() => _FormularioEmpreendedorScreenState();
}

class _FormularioEmpreendedorScreenState extends State<FormularioEmpreendedorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de Texto
  final _emailController = TextEditingController();
  final _nomeNegocioController = TextEditingController();
  final _outroGeneroController = TextEditingController();
  final _outraCategoriaController = TextEditingController();
  final _equipeTotalController = TextEditingController();
  final _equipeMulheresController = TextEditingController();
  final _equipeHomensController = TextEditingController();
  final _familiasController = TextEditingController();
  final _outroLocalInsumosController = TextEditingController();
  final _unidAguaController = TextEditingController();
  final _unidRefriController = TextEditingController();
  final _unidCervejaController = TextEditingController();
  final _unidSucoController = TextEditingController();
  final _unidEnergeticoController = TextEditingController();
  final _unidDrinksController = TextEditingController();
  final _quaisDificuldadesController = TextEditingController();
  final _sugestoesController = TextEditingController();

  // Variáveis Dropdown
  String? _generoSelecionado;
  String? _categoriaSelecionada;
  String? _investimentoSelecionado;
  String? _faturamentoSelecionado;
  String? _gastosEquipeSelecionado;
  String? _localInsumosSelecionado;
  String? _avaliacaoOrganizacaoSelecionada;
  String? _apoioPrefeituraSelecionado;
  String? _dificuldadesSelecionado;
  String? _divulgouNegocioSelecionado;
  String? _parceriasSelecionadas;
  String? _salaEmpreendedorSelecionada;
  String? _proximasEdicoesSelecionada;
  String? _outrosEventosSelecionados;

  Future<void> _salvarFormulario() async {
    FocusScope.of(context).unfocus();

    // Identificação (1 a 6)
    if (_emailController.text.trim().isEmpty || _nomeNegocioController.text.trim().isEmpty ||
        _generoSelecionado == null || (_generoSelecionado == 'Outro' && _outroGeneroController.text.trim().isEmpty) ||
        _categoriaSelecionada == null || (_categoriaSelecionada == 'Outro' && _outraCategoriaController.text.trim().isEmpty) ||
        _investimentoSelecionado == null || _faturamentoSelecionado == null) {
      _mostrarErro('Preencha todas as perguntas de 1 a 6.'); return;
    }

    // Equipe e Gastos (7 a 11)
    if (_equipeTotalController.text.trim().isEmpty || _equipeMulheresController.text.trim().isEmpty ||
        _equipeHomensController.text.trim().isEmpty || _gastosEquipeSelecionado == null ||
        _familiasController.text.trim().isEmpty) {
      _mostrarErro('Preencha as informações sobre a equipa (Perguntas 7 a 11).'); return;
    }

    //  Insumos (Apenas a 12 é obrigatória, 13 a 18 são opcionais)
    if (_localInsumosSelecionado == null || (_localInsumosSelecionado == 'Outro' && _outroLocalInsumosController.text.trim().isEmpty)) {
      _mostrarErro('Preencha a origem dos insumos (Pergunta 12).'); return;
    }

    // Avaliação e Apoio (19 a 27)
    if (_avaliacaoOrganizacaoSelecionada == null || _apoioPrefeituraSelecionado == null || _dificuldadesSelecionado == null ||
        (_dificuldadesSelecionado == 'Sim' && _quaisDificuldadesController.text.trim().isEmpty) ||
        _divulgouNegocioSelecionado == null || _parceriasSelecionadas == null || _salaEmpreendedorSelecionada == null ||
        _proximasEdicoesSelecionada == null || _outrosEventosSelecionados == null) {
      _mostrarErro('Preencha a avaliação geral do evento (Perguntas 19 a 27).'); return;
    }

    if (!_formKey.currentState!.validate()) return;

  
    String momentoDaColeta = DateTime.now().toString().split('.')[0];
    
    final empreendedor = EmpreendedorModel(
      dataHora: momentoDaColeta,
      email: _emailController.text.trim(),
      nomeNegocio: _nomeNegocioController.text.trim(),
      genero: _generoSelecionado == 'Outro' ? _outroGeneroController.text.trim() : _generoSelecionado!,
      categoria: _categoriaSelecionada == 'Outro' ? _outraCategoriaController.text.trim() : _categoriaSelecionada!,
      investimento: _investimentoSelecionado!,
      faturamento: _faturamentoSelecionado!,
      equipeTotal: _equipeTotalController.text.trim(),
      equipeMulheres: _equipeMulheresController.text.trim(),
      equipeHomens: _equipeHomensController.text.trim(),
      gastosEquipe: _gastosEquipeSelecionado!,
      familiasBeneficiadas: _familiasController.text.trim(),
      localInsumos: _localInsumosSelecionado == 'Outro' ? _outroLocalInsumosController.text.trim() : _localInsumosSelecionado!,
      unidAgua: _unidAguaController.text.trim(),
      unidRefrigerante: _unidRefriController.text.trim(),
      unidCerveja: _unidCervejaController.text.trim(),
      unidSuco: _unidSucoController.text.trim(),
      unidEnergetico: _unidEnergeticoController.text.trim(),
      unidDrinks: _unidDrinksController.text.trim(),
      avaliacaoOrganizacao: _avaliacaoOrganizacaoSelecionada!,
      apoioPrefeitura: _apoioPrefeituraSelecionado!,
      dificuldades: _dificuldadesSelecionado!,
      quaisDificuldades: _dificuldadesSelecionado == 'Sim' ? _quaisDificuldadesController.text.trim() : '',
      divulgouNegocio: _divulgouNegocioSelecionado!,
      parcerias: _parceriasSelecionadas!,
      salaEmpreendedor: _salaEmpreendedorSelecionada!,
      proximasEdicoes: _proximasEdicoesSelecionada!,
      outrosEventos: _outrosEventosSelecionados!,
      sugestoes: _sugestoesController.text.trim(),
    );

    final db = DatabaseHelper();
    await db.inserirEmpreendedor(empreendedor);
    SyncService().sincronizarEmpreendedores();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salvo com sucesso!'), backgroundColor: Colors.green));
      WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _limparCampos(); });
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _limparCampos() {
    _formKey.currentState?.reset();
    _emailController.clear(); _nomeNegocioController.clear(); _outroGeneroController.clear();
    _outraCategoriaController.clear(); _equipeTotalController.clear(); _equipeMulheresController.clear();
    _equipeHomensController.clear(); _familiasController.clear(); _outroLocalInsumosController.clear();
    _unidAguaController.clear(); _unidRefriController.clear(); _unidCervejaController.clear();
    _unidSucoController.clear(); _unidEnergeticoController.clear(); _unidDrinksController.clear();
    _quaisDificuldadesController.clear(); _sugestoesController.clear();
    
    setState(() {
      _generoSelecionado = null; _categoriaSelecionada = null; _investimentoSelecionado = null;
      _faturamentoSelecionado = null; _gastosEquipeSelecionado = null; _localInsumosSelecionado = null;
      _avaliacaoOrganizacaoSelecionada = null; _apoioPrefeituraSelecionado = null; _dificuldadesSelecionado = null;
      _divulgouNegocioSelecionado = null; _parceriasSelecionadas = null; _salaEmpreendedorSelecionada = null;
      _proximasEdicoesSelecionada = null; _outrosEventosSelecionados = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisa Empreendedores')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '1. E-mail *', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nomeNegocioController,
                decoration: const InputDecoration(labelText: '2. Nome do negócio *', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              const Text('3. Gênero do representante *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _generoSelecionado,
                items: ['Homem empreendedor', 'Mulher empreendedora', 'Outro'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _generoSelecionado = val),
              ),
              if (_generoSelecionado == 'Outro') ...[
                const SizedBox(height: 8),
                TextFormField(controller: _outroGeneroController, decoration: const InputDecoration(labelText: 'Especifique', border: OutlineInputBorder())),
              ],
              const SizedBox(height: 16),

              const Text('4. Ramo/categoria *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _categoriaSelecionada,
                items: ['Alimentos/Bebidas', 'Vendas de Artesanato/Vestuário', 'Ambulante', 'Outro'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _categoriaSelecionada = val),
              ),
              if (_categoriaSelecionada == 'Outro') ...[
                const SizedBox(height: 8),
                TextFormField(controller: _outraCategoriaController, decoration: const InputDecoration(labelText: 'Especifique', border: OutlineInputBorder())),
              ],
              const SizedBox(height: 16),

              const Text('5. Valor do investimento *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _investimentoSelecionado,
                items: ['Até R\$ 500', 'De R\$ 501 a R\$ 1.500', 'De R\$ 1.501 a R\$ 3.000', 'De R\$ 3.001 a R\$ 5.000', 'De R\$ 5.001 a R\$ 10.000', 'Acima de R\$ 10.000'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _investimentoSelecionado = val),
              ),
              const SizedBox(height: 16),

              const Text('6. Faturamento médio estimado *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _faturamentoSelecionado,
                items: ['até R\$ 1.000', 'de R\$ 1.001 a R\$ 3.000', 'de R\$ 3.001 a R\$ 5.000', 'de R\$ 5.001 a R\$ 10.000', 'acima de R\$ 10.000'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _faturamentoSelecionado = val),
              ),
              const Divider(thickness: 2, height: 32),

              TextFormField(controller: _equipeTotalController, decoration: const InputDecoration(labelText: '7. Pessoas na equipe (Ambulante s/ajuda = 1) *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextFormField(controller: _equipeMulheresController, decoration: const InputDecoration(labelText: '8. Quantas mulheres (0 se nenhuma) *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextFormField(controller: _equipeHomensController, decoration: const InputDecoration(labelText: '9. Quantos homens (0 se nenhum) *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 16),

              const Text('10. Gastos com equipe *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _gastosEquipeSelecionado,
                items: ['Até R\$ 500', 'De R\$ 501 a R\$ 1.000', 'De R\$ 1.001 a R\$ 2.000', 'De R\$ 2.001 a R\$ 5.000', 'Acima de R\$ 5.000', 'Não se aplica'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _gastosEquipeSelecionado = val),
              ),
              const SizedBox(height: 16),

              TextFormField(controller: _familiasController, decoration: const InputDecoration(labelText: '11. Famílias beneficiadas *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 16),

              const Text('12. Insumos adquiridos em *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _localInsumosSelecionado,
                items: ['Aracati', 'Outro'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _localInsumosSelecionado = val),
              ),
              if (_localInsumosSelecionado == 'Outro') ...[
                const SizedBox(height: 8),
                TextFormField(controller: _outroLocalInsumosController, decoration: const InputDecoration(labelText: 'Especifique', border: OutlineInputBorder())),
              ],
              const Divider(thickness: 2, height: 32),

              const Text('Estimativas de Vendas (Opcional):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(controller: _unidAguaController, decoration: const InputDecoration(labelText: '13. Água *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextFormField(controller: _unidRefriController, decoration: const InputDecoration(labelText: '14. Refrigerante *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextFormField(controller: _unidCervejaController, decoration: const InputDecoration(labelText: '15. Cerveja *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextFormField(controller: _unidSucoController, decoration: const InputDecoration(labelText: '16. Suco *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextFormField(controller: _unidEnergeticoController, decoration: const InputDecoration(labelText: '17. Energético *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextFormField(controller: _unidDrinksController, decoration: const InputDecoration(labelText: '18. Drinks *', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const Divider(thickness: 2, height: 32),

              const Text('19. Avaliação da organização *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _avaliacaoOrganizacaoSelecionada,
                items: ['Excelente', 'Boa', 'Regular', 'Ruim', 'Péssima'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _avaliacaoOrganizacaoSelecionada = val),
              ),
              const SizedBox(height: 16),

              const Text('20. Apoio da Prefeitura? *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _apoioPrefeituraSelecionado,
                items: ['Sim', 'Não'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _apoioPrefeituraSelecionado = val),
              ),
              const SizedBox(height: 16),

              const Text('21. Enfrentou dificuldade? *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _dificuldadesSelecionado,
                items: ['Sim', 'Não'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) {
                  setState(() {
                    _dificuldadesSelecionado = val;
                    if (val == 'Não') _quaisDificuldadesController.clear();
                  });
                },
              ),
              
              if (_dificuldadesSelecionado == 'Sim') ...[
                const SizedBox(height: 8),
                TextFormField(controller: _quaisDificuldadesController, decoration: const InputDecoration(labelText: '22. Quais dificuldades? *', border: OutlineInputBorder())),
              ],
              const SizedBox(height: 16),

              const Text('23. Contribuiu para divulgar? *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _divulgouNegocioSelecionado,
                items: ['Sim', 'Não'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _divulgouNegocioSelecionado = val),
              ),
              const SizedBox(height: 16),

              const Text('24. Estabeleceu parcerias? *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _parceriasSelecionadas,
                items: ['Sim', 'Não'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _parceriasSelecionadas = val),
              ),
              const SizedBox(height: 16),

              const Text('25. Utiliza Sala do Empreendedor? *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _salaEmpreendedorSelecionada,
                items: ['Sim', 'Não'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _salaEmpreendedorSelecionada = val),
              ),
              const SizedBox(height: 16),

              const Text('26. Próximas edições? *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _proximasEdicoesSelecionada,
                items: ['Sim, com certeza.', 'Talvez, dependendo das condições.', 'Não, não tenho interesse.', 'Ainda estou indeciso(a), preciso avaliar.'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _proximasEdicoesSelecionada = val),
              ),
              const SizedBox(height: 16),

              const Text('27. Outros eventos da Prefeitura? *', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                isExpanded: true, decoration: const InputDecoration(border: OutlineInputBorder()), initialValue: _outrosEventosSelecionados,
                items: ['Sim', 'Talvez', 'Não'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _outrosEventosSelecionados = val),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _sugestoesController,
                decoration: const InputDecoration(labelText: '28. Sugestões (Opcional)', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                onPressed: _salvarFormulario,
                child: const Text('SALVAR RESPOSTA', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}