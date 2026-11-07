import 'package:flutter/material.dart';
// Importe suas telas de formulário e exportação aqui

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisas do Evento'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              onPressed: () {
                // Navegar para a tela do Formulário 1
              },
              child: const Text('Preencher Formulário 1', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              onPressed: () {
                // Navegar para a tela do Formulário 2
              },
              child: const Text('Preencher Formulário 2', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Exportar Planilhas (CSV)'),
              onPressed: () {
                // Navegar para a tela de geração e compartilhamento das planilhas
              },
            )
          ],
        ),
      ),
    );
  }
}