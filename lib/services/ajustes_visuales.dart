/// Todas las claves de SharedPreferences en un único sitio.
/// Así no hay cadenas sueltas repartidas por el código y evitamos erratas.
class ClavesPrefs {
  ClavesPrefs._(); // clase solo de constantes: no se instancia

  static const String nombreUsuario = 'pref_nombre_usuario'; // String
  static const String objetivoDiario = 'pref_objetivo_diario'; // int
  static const String modoOscuro = 'pref_modo_oscuro'; // bool
  static const String tamanoLetra = 'pref_tamano_letra'; // double
  static const String ocultarCompletados = 'pref_ocultar_completados'; // bool
  static const String habitos = 'pref_habitos_list'; // List<String> (JSON)
  static const String contadorAperturas = 'pref_contador_aperturas'; // int
  static const String ultimaApertura = 'pref_ultima_apertura'; // String ISO-8601
  static const String primeraVez = 'pref_primera_vez'; // bool
}