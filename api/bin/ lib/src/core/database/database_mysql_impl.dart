import 'package:mysql_client/mysql_client.dart';

import '../developer/developer.dart';
import './database.dart';

class MysqlDatabase implements Database {
  MySQLConnection? conn;

  MysqlDatabase._();

  static MysqlDatabase? _instance;

  static MysqlDatabase get i {
    _instance ??= MysqlDatabase._();
    return _instance!;
  }

  @override
  delete<T>({required String tableName, required T value}) async {
    final key = (value as Map).keys.first;
    final val = (value.values.first);

    final result = await conn?.execute('Delete from $tableName  where $key = $val');
    if (result != null) {
      if (result.affectedRows.toInt() > 0) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  @override
  Future<List<T>?> getData<T>(String query) async {
    final listResult = <T>[];
    final result = await conn?.execute(query);
    if (result != null) {
      for (final row in result.rows) {
        listResult.add(row.assoc() as T);
      }
      return listResult;
    }
    return null;
  }

  @override
  Future<T?> getUnique<T>(String query) async {
    final result = await conn?.execute(query);
    if (result == null) {
      return null;
    }
    if (result.rows.isEmpty) {
      return null;
    }
    return (result.rows.first.assoc()) as T;
  }

  @override
  Future<int> insert<T>({required String tableName, required T value}) async {
    try {
      final tableFields = ((value as Map).keys).join(',');
      final tableWillCards = (value).keys.map((e) => ":$e").join(',');
      final res = await conn?.execute(
        "INSERT INTO $tableName ($tableFields) VALUES ($tableWillCards)",
        value as Map<String, dynamic>?,
      );
      if (res == null) {
        return 0;
      }
      if (res.affectedRows.toInt() == 1) {
        return res.lastInsertID.toInt();
      }
      return 0;
    } catch (e, s) {
      Developer.logError(errorText: 'Fail to save', error: e, stackTrace: s, errorName: runtimeType.toString());
      return 0;
    }
  }

  @override
  Future<MysqlDatabase?> openDatabase<MysqlDatabase>(Map<String, dynamic> path) async {
    conn = await MySQLConnection.createConnection(host: path['host'], port: int.parse(path['port']), userName: path['userName'], password: path['password'], databaseName: path['databaseName'], secure: path['secure']);
    conn?.connect();
    Developer.logInstance(this);
    return this as MysqlDatabase;
  }

  @override
  Future<void> closeDatabase() async {
    await conn?.close();
  }

  @override
  Future<bool> update<T>({required String tableName, required T value}) async {
    try {
      final tableFields = ((value as Map).keys).toList();
      final tableWillCards = (value).keys.map((e) => ":$e").toList();
      final List<String> queryFields = [];
      for (var i = 0; i < tableFields.length; i++) {
        queryFields.add("${tableFields[i]} = ${tableWillCards[i]}");
      }
      final String fields = (queryFields.join(','));
      final res = await conn?.execute(
        "UPDATE $tableName SET $fields  where id = ${value['id']}",
        value as Map<String, dynamic>?,
      );
      if (res == null) {
        return false;
      }
      if (res.affectedRows.toInt() == 1) {
        return true;
      }
      return false;
    } catch (e, s) {
      Developer.logError(errorText: 'Fail to save', error: e, stackTrace: s, errorName: runtimeType.toString());
      return false;
    }
  }

  @override
  Future<int> insertAll<T>({required String tableName, required List<T> value, bool clear = false}) async {
    if (value.isNotEmpty) {
      for (var valueInsert in value) {
        await insert<T>(tableName: tableName, value: (valueInsert));
      }
    }

    return 1;
  }
}
