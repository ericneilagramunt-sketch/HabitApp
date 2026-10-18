import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habito.dart';

class PreferenciasService {
  static const String _keyNombreUsuario = 'pref_nombre_usuario';
  static const String _keyObjetivoDiario = 'pref_objetivo_diario';
  static const String _keyModoOscuro = 'pref_modo_oscuro';
  static const String _keyTamanoLetra = 'pref_tamano_letra';
  static const String _keyOcultarCompletados = 'pref_ocultar_completados';
  static const String _keyHabitosList = 'pref_habitos_list';
  static const String _keyContadorAperturas = 'pref_contador_aperturas';
  static const String _keyUltimaApertura = 'pref_ultima_apertura';
  static const String _keyPrimeraVez = 'pref_primera_vez';

  static SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<String?> getNombreUsuario() async => (await _instance).getString(_keyNombreUsuario);
  Future<void> setNombreUsuario(String nombre) async => (await _instance).setString(_keyNombreUsuario, nombre);

  Future<int> getObjetivoDiario() async => (await _instance).getInt(_keyObjetivoDiario) ?? 3;
  Future<void> setObjetivoDiario(int objetivo) async => (await _instance).setInt(_keyObjetivoDiario, objetivo);

  Future<bool> getModoOscuro() async => (await _instance).getBool(_keyModoOscuro) ?? false;
  Future<void> setModoOscuro(bool valor) async => (await _instance).setBool(_keyModoOscuro, valor);

  Future<bool> getOcultarCompletados() async => (await _instance).getBool(_keyOcultarCompletados) ?? false;
  Future<void> setOcultarCompletados(bool ocultar) async => (await _instance).setBool(_keyOcultarCompletados, ocultar);

  Future<double> getTamanoLetra() async => (await _instance).getDouble(_keyTamanoLetra) ?? 16.0;
  Future<void> setTamanoLetra(double tamano) async => (await _instance).setDouble(_keyTamanoLetra, tamano);

  Future<List<Habito>> getHabitos() async {
    final List<String>? jsonList = (await _instance).getStringList(_keyHabitosList);
    if (jsonList == null) return [];
    return jsonList.map((str) => Habito.fromRawJson(str)).toList();
  }

  Future<void> saveHabitos(List<Habito> habitos) async {
    final List<String> jsonList = habitos.map((h) => h.toRawJson()).toList();
    await (await _instance).setStringList(_keyHabitosList, jsonList);
  }

  Future<int> registrarApertura() async {
    final p = await _instance;
    int aperturas = (p.getInt(_keyContadorAperturas) ?? 0) + 1;
    await p.setInt(_keyContadorAperturas, aperturas);
    await p.setString(_keyUltimaApertura, DateTime.now().toIso8601String());
    return aperturas;
  }

  Future<int> getContadorAperturas() async => (await _instance).getInt(_keyContadorAperturas) ?? 0;
  Future<String?> getUltimaApertura() async => (await _instance).getString(_keyUltimaApertura);

  Future<bool> esPrimeraVez() async => (await _instance).getBool(_keyPrimeraVez) ?? true;
  Future<void> setPrimeraVezCompletada() async => (await _instance).setBool(_keyPrimeraVez, false);
  Future<void> borrarTodo() async => (await _instance).clear();
}