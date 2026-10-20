import 'dart:convert';

// Clase que representa un hábito de la aplicación.
class Habito {
// Identificador único del hábito.
final String id;

// Nombre del hábito.
String nombre;

// Color del hábito guardado como un número hexadecimal.
int colorHex;

// Lista de fechas en las que se ha completado el hábito.
List<String> fechasCompletadas;

// Constructor que recibe los datos necesarios para crear un hábito.
// Si no se pasan fechas, se crea una lista vacía.
Habito({
required this.id,
required this.nombre,
required this.colorHex,
List<String>? fechasCompletadas,
}) : fechasCompletadas = fechasCompletadas ?? [];

// Comprueba si el hábito se ha completado en una fecha concreta.
// Si no se indica una fecha, utiliza la fecha actual.
bool estaCompletadoHoy([DateTime? fecha]) {
final f = fecha ?? DateTime.now();
return fechasCompletadas.contains(_formatearFecha(f));
}