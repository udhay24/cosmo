import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlitePersistence {
  static const DatabaseName = 'cosmo.db';
  static const EventNotificationTableName = 'event';
  Database db;

  SqlitePersistence._(this.db);

  static Future<SqlitePersistence> create() async =>
      SqlitePersistence._(await database());

  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), DatabaseName),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $EventNotificationTableName(event_id INTEGER PRIMARY KEY, room_id TEXT, room_password TEXT)",
        );
      },
      version: 3,
    );
  }
}

