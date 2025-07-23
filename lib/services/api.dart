import 'dart:convert';
import 'package:neru/model/variable.dart';
import 'package:neru/model/actividad.dart';
import 'package:http/http.dart' as http;
import 'package:neru/services/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Fijas
Future<List<Variable>> fVariable() async {
  final response = await http.get(
    Uri.parse(
      'https://gcconsultoresmexico.com/api/api.php?action=get_variables',
    ),
  );
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => Variable.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar productos');
  }
}

Future<List<Actividad>> fActividades() async {
  final response = await http.get(
    Uri.parse(
      'https://gcconsultoresmexico.com/api/api.php?action=get_actividades',
    ),
  );
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((json) => Actividad.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar productos');
  }
}

//LOCALES
void mVariablesLocales() async {
  final usuarios = await DBHelper.getVariablesDB();
  if (usuarios.isEmpty) {
    //print('❌ No hay variables guardadas');
  } else {
    for (var user in usuarios) {
      print(
        '📦 Variable: ${user['id']} | ${user['nombre']} | ${user['estatus']}',
      );
    }
  }
}

void mUsuarioAct() async {
  final prefs = await SharedPreferences.getInstance();
  final user = prefs.getString('auth_nombre');

  final usuarioAct = await DBHelper.getUserActDB(user!);
  if (usuarioAct.isEmpty) {
    print('❌ No hay Actividades guardadas');
  } else {
    for (var user in usuarioAct) {
      print(
        '📦 Variable: ${user['id']} | ${user['idusuario']} | ${user['idactividad']} | ${user['estatus']} | ${user['fca_creacion']}',
      );
    }
  }
}
