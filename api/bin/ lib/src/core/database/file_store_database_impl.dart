import 'dart:convert';
import 'dart:io';

import '../developer/developer.dart';
import './database.dart';

class FileStoreDatabase implements Database {
  final basePath = 'cache';
  FileStoreDatabase._();

  static FileStoreDatabase? _instance;

  static FileStoreDatabase get i {
    _instance ??= FileStoreDatabase._();
    return _instance!;
  }

  @override
  Future<bool> delete<T>({required String tableName, required T value}) async {
    File("$basePath/$tableName.json").delete();
    return true;
  }

  @override
  Future<List<T>?> getData<T>(String query) async {
    final file = File("$basePath/$query.json");

    if (file.existsSync()) {
      var list = <T>[];
      final data = await file.readAsString();
      final jsonData = json.decode(data) as List;
      list = jsonData.map((e) => e as T).toList();
      return list;
    }
    return [];
  }

  @override
  Future<T?> getUnique<T>(String query) async {
    return null;
  }

  @override
  Future<int> insert<T>({required String tableName, required T value}) async {
    try {
      return 0;
    } catch (e, s) {
      Developer.logError(errorText: 'Fail to save', error: e, stackTrace: s, errorName: runtimeType.toString());
      return 0;
    }
  }

  @override
  Future<T> openDatabase<T>(Map<String, dynamic> path) async {
    return this as T;
  }

  @override
  Future<void> closeDatabase() async {}

  @override
  Future<bool> update<T>({required String tableName, required T value}) async {
    return false;
  }

  @override
  Future<int> insertAll<T>({required String tableName, required List<T> value, bool clear = false}) async {
    await File("$basePath/$tableName.json").writeAsString(json.encode(value));
    return 1;
  }
}
