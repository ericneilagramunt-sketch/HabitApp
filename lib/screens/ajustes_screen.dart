import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import 'bienvenida_screen.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  final _prefsService = PreferenciasService();
  bool _modoOscuro = false;
  double _tamanoLetra = 16.0;
  bool _ocultarCompletados = false;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final m = await _prefsService.getModoOscuro();
    final t = await _prefsService.getTamanoLetra();
    final o = await _prefsService.getOcultarCompletados();
    setState(() {
      _modoOscuro = m;
      _tamanoLetra = t;
      _ocultarCompletados = o;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo Oscuro'),
            value: _modoOscuro,
            onChanged: (v) async {
              setState(() => _modoOscuro = v);
              await _prefsService.setModoOscuro(v);
            },
          ),
          ListTile(
            title: const Text('Tamaño de letra'),
            subtitle: Slider(
              min: 12, max: 24, divisions: 6,
              value: _tamanoLetra,
              label: _tamanoLetra.round().toString(),
              onChanged: (v) async {
                setState(() => _tamanoLetra = v);
                await _prefsService.setTamanoLetra(v);
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Ocultar hábitos completados hoy'),
            value: _ocultarCompletados,
            onChanged: (v) async {
              setState(() => _ocultarCompletados = v);
              await _prefsService.setOcultarCompletados(v);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.pink),
            title: const Text('Borrar datos', style: TextStyle(color: Colors.pink)),
            subtitle: const Text('Deja la app como recién instalada'),
            onTap: () async {
              await _prefsService.borrarTodo();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const BienvenidaScreen()),
                    (r) => false,
              );
            },
          )
        ],
      ),
    );
  }
}