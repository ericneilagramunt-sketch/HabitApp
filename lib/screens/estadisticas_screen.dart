import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  final _prefsService = PreferenciasService();
  bool _cargando = true;
  int _aperturas = 0;
  String _ultimaAperturaTexto = 'N/A';
  List<Habito> _habitos = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final aperturas = await _prefsService.getContadorAperturas();
    final fechaIso = await _prefsService.getUltimaApertura();
    final habitos = await _prefsService.getHabitos();

    String fechaFormatted = 'Sin registro';
    if (fechaIso != null) {
      fechaFormatted = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(fechaIso));
    }

    setState(() {
      _aperturas = aperturas;
      _ultimaAperturaTexto = fechaFormatted;
      _habitos = habitos;
      _cargando = false;
    });
  }

  int _racha(Habito h) {
    int r = 0;
    DateTime hoy = DateTime.now();
    while (true) {
      String f = "${hoy.year.toString().padLeft(4, '0')}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}";
      if (h.fechasCompletadas.contains(f)) {
        r++;
        hoy = hoy.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: ListTile(title: const Text('Total aperturas app:'), trailing: Text('$_aperturas', style: const TextStyle(fontWeight: FontWeight.bold)))),
          Card(child: ListTile(title: const Text('Última apertura:'), subtitle: Text(_ultimaAperturaTexto))),
          const SizedBox(height: 20),
          const Text('Racha por hábito:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ..._habitos.map((h) => ListTile(
            leading: CircleAvatar(backgroundColor: Color(h.colorHex)),
            title: Text(h.nombre),
            subtitle: Text('Total completado: ${h.fechasCompletadas.length} días'),
            trailing: Text('🔥 ${_racha(h)} días', style: const TextStyle(fontWeight: FontWeight.bold)),
          )),
        ],
      ),
    );
  }
}