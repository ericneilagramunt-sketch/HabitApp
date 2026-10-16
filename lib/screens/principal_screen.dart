import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import '../widgets/habito_tile.dart';
import 'gestion_habitos_screen.dart';
import 'estadisticas_screen.dart';
import 'ajustes_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  final _prefsService = PreferenciasService();
  bool _cargando = true;
  String _nombreUsuario = '';
  int _objetivoDiario = 0;
  double _tamanoLetra = 16.0;
  bool _ocultarCompletados = false;
  List<Habito> _habitos = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);
    await _prefsService.registrarApertura();

    final nombre = await _prefsService.getNombreUsuario() ?? 'Usuario';
    final objetivo = await _prefsService.getObjetivoDiario();
    final tamano = await _prefsService.getTamanoLetra();
    final ocultar = await _prefsService.getOcultarCompletados();
    final habitos = await _prefsService.getHabitos();

    setState(() {
      _nombreUsuario = nombre;
      _objetivoDiario = objetivo;
      _tamanoLetra = tamano;
      _ocultarCompletados = ocultar;
      _habitos = habitos;
      _cargando = false;
    });
  }

  void _toggleHabito(Habito habito) async {
    setState(() => habito.alternarCompletadoHoy());
    await _prefsService.saveHabitos(_habitos);
  }

  void _borrarHabito(Habito habito) async {
    setState(() => _habitos.removeWhere((h) => h.id == habito.id));
    await _prefsService.saveHabitos(_habitos);
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final completados = _habitos.where((h) => h.estaCompletadoHoy()).length;
    final visibles = _ocultarCompletados
        ? _habitos.where((h) => !h.estaCompletadoHoy()).toList()
        : _habitos;

    return Scaffold(
      appBar: AppBar(
        title: Text('¡Hola, $_nombreUsuario!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EstadisticasScreen()),
            ).then((_) => _cargarDatos()),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AjustesScreen()),
            ).then((_) => _cargarDatos()),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progreso diario:', style: TextStyle(fontSize: _tamanoLetra, fontWeight: FontWeight.bold)),
                Text(
                  '$completados de $_objetivoDiario hábitos',
                  style: TextStyle(
                    fontSize: _tamanoLetra,
                    color: completados >= _objetivoDiario ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: visibles.isEmpty
                ? Center(child: Text('No hay hábitos.', style: TextStyle(fontSize: _tamanoLetra)))
                : ListView.builder(
              itemCount: visibles.length,
              itemBuilder: (context, index) {
                final habito = visibles[index];
                return HabitoTile(
                  habito: habito,
                  tamanoLetra: _tamanoLetra,
                  onToggle: (_) => _toggleHabito(habito),
                  onDelete: () => _borrarHabito(habito),
                  onEdit: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GestionHabitosScreen(habitoAEditar: habito)),
                    );
                    _cargarDatos();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GestionHabitosScreen()),
          );
          _cargarDatos();
        },
      ),
    );
  }
}