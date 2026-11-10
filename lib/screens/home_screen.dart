import 'package:flutter/material.dart';
import 'formulario_visitante_screen.dart';
import 'formulario_empreendedor_screen.dart';
import '../services/export_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/fundo.png'),
            fit: BoxFit.cover, 
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              // Volta a centralizar os itens na tela
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                const SizedBox(height: 240), 
                
                // Botão para Visitantes
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1A2980),
                    elevation: 5,
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
                    backgroundColor: Colors.deepOrangeAccent,
                    foregroundColor: Colors.white,
                    elevation: 5,
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
                
                const Divider(color: Color(0xFF1A2980)),
                const Text(
                  'Exportação Manual (Offline)', 
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF1A2980), 
                    fontSize: 14,
                  )
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
                        backgroundColor: Colors.white.withValues(alpha: 0.9), 
                        foregroundColor: const Color(0xFF1A2980),
                        elevation: 3,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await ExportService().exportarParaCSV(false);
                      },
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('CSV Empreend.'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.9), 
                        foregroundColor: const Color(0xFF1A2980),
                        elevation: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}