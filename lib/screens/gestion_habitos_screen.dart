import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';

class GestionHabitosScreen extends StatefulWidget {
  final Habito? habitoAEditar;
  const GestionHabitosScreen({super.key, this.habitoAEditar});

  @override
  State<GestionHabitosScreen> createState() => _GestionHabitosScreenState();
}

class _GestionHabitosScreenState extends State<GestionHabitosScreen> {
  final _nombreController = TextEditingController();
  final _prefsService = PreferenciasService();
  int _colorSeleccionado = Colors.blue.value;

  final List<Color> _colores = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.teal];

  @override
  void initState() {
    super.initState();
    if (widget.habitoAEditar != null) {
      _nombreController.text = widget.habitoAEditar!.nombre;
      _colorSeleccionado = widget.habitoAEditar!.colorHex;
    }
  }

  void _guardar() async {
    final nombre = _nombreController.text.trim();
    if (nombre.isEmpty) return;

    List<Habito> habitos = await _prefsService.getHabitos();

    if (widget.habitoAEditar == null) {
      habitos.add(Habito(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        colorHex: _colorSeleccionado,
      ));
    } else {
      final index = habitos.indexWhere((h) => h.id == widget.habitoAEditar!.id);
      if (index != -1) {
        habitos[index].nombre = nombre;
        habitos[index].colorHex = _colorSeleccionado;
      }
    }

    await _prefsService.saveHabitos(habitos);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.habitoAEditar != null ? 'Editar Hábito' : 'Nuevo Hábito')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del hábito', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const Text('Selecciona un color:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _colores.map((c) => GestureDetector(
                onTap: () => setState(() => _colorSeleccionado = c.value),
                child: CircleAvatar(
                  backgroundColor: c,
                  child: _colorSeleccionado == c.value ? const Icon(Icons.check, color: Colors.white) : null,
                ),
              )).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}