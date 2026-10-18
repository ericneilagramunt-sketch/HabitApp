import 'dart:convert';

class Habito {
  final String id;
  String nombre;
  int colorHex;
  List<String> fechasCompletadas;

  Habito({
    required this.id,
    required this.nombre,
    required this.colorHex,
    List<String>? fechasCompletadas,
  }) : fechasCompletadas = fechasCompletadas ?? [];

  bool estaCompletadoHoy([DateTime? fecha]) {
    final f = fecha ?? DateTime.now();
    return fechasCompletadas.contains(_formatearFecha(f));
  }

  void alternarCompletadoHoy() {
    final hoyStr = _formatearFecha(DateTime.now());
    if (fechasCompletadas.contains(hoyStr)) {
      fechasCompletadas.remove(hoyStr);
    } else {
      fechasCompletadas.add(hoyStr);
    }
  }

  static String _formatearFecha(DateTime fecha) {
    return "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'colorHex': colorHex,
    'fechasCompletadas': fechasCompletadas,
  };

  factory Habito.fromJson(Map<String, dynamic> json) => Habito(
    id: json['id'] as String,
    nombre: json['nombre'] as String,
    colorHex: json['colorHex'] as int,
    fechasCompletadas: List<String>.from(json['fechasCompletadas'] ?? []),
  );

  String toRawJson() => jsonEncode(toJson());
  factory Habito.fromRawJson(String str) => Habito.fromJson(jsonDecode(str));
}