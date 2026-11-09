import 'package:flutter/material.dart';
import 'formulario_visitante_screen.dart';
import 'formulario_empreendedor_screen.dart';
import '../services/export_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisas do Festival'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.assignment, 
              size: 80, 
              color: Colors.blue
            ),
            const SizedBox(height: 40),
            
            // Botão para Visitantes
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormularioVisitanteScreen(),
                  ),
                );
              },
              child: const Text(
                'Pesquisa de Visitantes', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),
            
            const SizedBox(height: 20),

            // Botão para Empreendedores
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormularioEmpreendedorScreen(),
                  ),
                );
              },
              child: const Text(
                'Pesquisa de Empreendedores', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              ),
            ),

            const SizedBox(height: 40),
            const Divider(),
            const Text(
              'Exportação Manual (Offline)', 
              textAlign: TextAlign.center, 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await ExportService().exportarParaCSV(true); 
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('CSV Visitantes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200], 
                    foregroundColor: Colors.black
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await ExportService().exportarParaCSV(false); 
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('CSV Empreend.'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200], 
                    foregroundColor: Colors.black
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}