import 'package:flutter/material.dart';
import 'screens/formulario_visitante_screen.dart'; 
import 'services/sync_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SyncService().iniciarMonitoramento();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pesquisa App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const FormularioVisitanteScreen(), 
    );
  }
}