import 'package:flutter/material.dart';
import 'services/preferencias_service.dart';
import 'screens/bienvenida_screen.dart';
import 'screens/principal_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HabitosApp());
}

class HabitosApp extends StatefulWidget {
  const HabitosApp({super.key});

  @override
  State<HabitosApp> createState() => _HabitosAppState();
}

class _HabitosAppState extends State<HabitosApp> {
  final _prefsService = PreferenciasService();
  bool _cargando = true;
  bool _esPrimeraVez = true;
  bool _modoOscuro = false;

  @override
  void initState() {
    super.initState();
    _comprobarInicial();
  }

  Future<void> _comprobarInicial() async {
    final esPrimera = await _prefsService.esPrimeraVez();
    final modoOscuro = await _prefsService.getModoOscuro();

    setState(() {
      _esPrimeraVez = esPrimera;
      _modoOscuro = modoOscuro;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }

    return MaterialApp(
      title: 'HábitosApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _modoOscuro ? ThemeMode.dark : ThemeMode.light,
      home: _esPrimeraVez ? const BienvenidaScreen() : const PrincipalScreen(),
    );
  }
}