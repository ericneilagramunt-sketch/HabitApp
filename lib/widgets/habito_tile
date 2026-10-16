import 'package:flutter/material.dart';
import '../models/habito.dart';

class HabitoTile extends StatelessWidget {
  final Habito habito;
  final double tamanoLetra;
  final Function(bool?) onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const HabitoTile({
    super.key,
    required this.habito,
    required this.tamanoLetra,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final estaHecho = habito.estaCompletadoHoy();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(habito.colorHex),
          child: Icon(
            estaHecho ? Icons.check : Icons.check_box_outline_blank,
            color: Colors.white,
          ),
        ),
        title: Text(
          habito.nombre,
          style: TextStyle(
            fontSize: tamanoLetra,
            decoration: estaHecho ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(value: estaHecho, onChanged: onToggle),
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}