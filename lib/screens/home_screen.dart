import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'formulario_visitante_screen.dart';
import 'formulario_empreendedor_screen.dart';
import '../services/export_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _abrirGitHub(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Não foi possível abrir: $url');
    }
  }

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                

                const SizedBox(height: 360), 
                
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

                const SizedBox(height: 30),
                
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
                
                const Spacer(), // Empurra o Card lá para o fundo
                
                // =========================================================
                // CARD BRANCO PARA OS CRÉDITOS
                // =========================================================
                Card(
                  elevation: 4,
                  color: Colors.white.withValues(alpha: 0.95), // Fundo branco quase sólido
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Desenvolvido por:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1A2980),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Removi o espaçamento extra para caber melhor na tela
                        Wrap( // Wrap ajusta os textos para não quebrarem em telas pequenas
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => _abrirGitHub('https://github.com/Grizzlyess'),
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Maria Clara Batista', 
                                style: TextStyle(
                                  color: Colors.deepOrange, 
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                )
                              ),
                            ),
                            
                            const Text(' & ', style: TextStyle(color: Color(0xFF1A2980), fontWeight: FontWeight.bold)),
                            
                            TextButton(
                              // Substitua pelo link real do GitHub do Kaique
                              onPressed: () => _abrirGitHub('https://github.com/Fkaique'),
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Francisco Kaique', 
                                style: TextStyle(
                                  color: Colors.deepOrange, 
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                )
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}