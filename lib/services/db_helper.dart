import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    String path = join(await getDatabasesPath(), 'app.db');
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);

    return _database!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE variables (
        id INTEGER PRIMARY KEY,
        nombre TEXT,
        estatus TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE actividades (
        id INTEGER PRIMARY KEY,
        idvariable INTEGER,
        nombre TEXT,
        ruta TEXT,
        estatus TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE usuario_actividad (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idusuario TEXT,
        idactividad INTEGER,
        idejercicio INTEGER,
        estatus TEXT,
        fca_creacion DATETIME
      )
    ''');
  }

  //CREATE
  static Future<void> clearAndInsertVar(List<dynamic> varia) async {
    final db = await database;

    // Borrar los datos actuales
    await db.delete('variables');

    // Insertar nuevos datos
    for (var user in varia) {
      await db.insert('variables', {
        'id': user['id'],
        'nombre': user['nombre'],
        'estatus': user['estatus'],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<void> clearAndInsertAct(List<dynamic> activ) async {
    final db = await database;
    // Borrar los datos actuales
    await db.delete('actividades');

    // Insertar nuevos datos
    for (var ac in activ) {
      await db.insert('actividades', {
        'id': ac['id'],
        'idvariable': ac['idvariable'],
        'nombre': ac['nombre'],
        'ruta': ac['ruta'],
        'estatus': ac['estatus'],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<int> clearAndInsertUserAct(List<dynamic> usract) async {
    final db = await database;
    int count = 0;
    // Insertar nuevos datos
    for (var ua in usract) {
      final id = await db.insert('usuario_actividad', {
        'idusuario': ua['idusuario'],
        'idactividad': ua['idactividad'],
        'idejercicio': ua['idejercicio'],
        'estatus': ua['estatus'],
        'fca_creacion': ua['fca_creacion'],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      if (id > 0) count++;
    }
    return count;
  }

  //READ
  static Future<List<Map<String, dynamic>>> getVariablesDB() async {
    final db = await database;
    return await db.query('variables');
  }

  static Future<List<Map<String, dynamic>>> getActividadesDB() async {
    final db = await database;
    return await db.query('actividades');
  }

  static Future<List<Map<String, dynamic>>> getActividadesByVariableId(
    int variableId,
  ) async {
    final db = await database;
    return await db.query(
      'actividades',
      where: 'idvariable = ?',
      whereArgs: [variableId],
    );
  }

  static Future<List<Map<String, dynamic>>> getUserActDB(
    String idusuario,
  ) async {
    final db = await database;
    return await db.query(
      'usuario_actividad',
      //where: 'idusuario = ?',
      //whereArgs: [idusuario],
    );
  }

  static Future<List<Map<String, dynamic>>> getActUsrDB(int id) async {
    final db = await database;
    return await db.query(
      'usuario_actividad',
      where: 'idejercicio = ?',
      whereArgs: [id],
    );
  }

  static Future<void> borrarTablasLocales() async {
    // Abre la base de datos
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'app.db'); // Usa el mismo nombre de tu DB
    final db = await openDatabase(path);

    // Borra todas las tablas
    await db.execute('DROP TABLE IF EXISTS variables');
    await db.execute('DROP TABLE IF EXISTS actividades');

    // Si quieres volver a crearlas vacías, vuelve a crearlas aquí:
    await db.execute('''
    CREATE TABLE variables (
      id INTEGER PRIMARY KEY,
      nombre TEXT,
      estatus TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE actividades (
      id INTEGER PRIMARY KEY,
      idvariable INTEGER,
      nombre TEXT,
      ruta TEXT,
      estatus TEXT
    )
  ''');

    await db.close(); // Cierra la DB
  }
}
