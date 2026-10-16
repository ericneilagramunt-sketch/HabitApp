import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';
import 'principal_screen.dart';

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  final _nombreController = TextEditingController();
  final _objetivoController = TextEditingController(text: "3");
  final _prefsService = PreferenciasService();

  void _guardarYContinuar() async {
    final nombre = _nombreController.text.trim();
    final objetivo = int.tryParse(_objetivoController.text.trim()) ?? 3;

    if (nombre.isEmpty) return;

    await _prefsService.setNombreUsuario(nombre);
    await _prefsService.setObjetivoDiario(objetivo);
    await _prefsService.setPrimeraVezCompletada();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PrincipalScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.auto_awesome, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              '¡Bienvenido a HábitosApp!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: '¿Cómo te llamas?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _objetivoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Objetivo diario de hábitos (número)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _guardarYContinuar,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              child: const Text('Comenzar', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}