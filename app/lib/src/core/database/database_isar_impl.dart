import 'package:app/src/data/models/cidade_model.dart';
import 'package:app/src/data/models/estado_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import './database.dart';

class DatabaseIsarImpl implements Database {
  Isar? conn;
  DatabaseIsarImpl._();
  static DatabaseIsarImpl? _instance;
  static DatabaseIsarImpl get i {
    _instance ??= DatabaseIsarImpl._();
    return _instance!;
  }

  @override
  Future<void> clear() async {
    await conn?.clear();
  }

  @override
  Future<void> closeDatabase() async {
    await conn?.close();
  }

  @override
  Future<List<T>?> getData<T>(String? query) async {
    if (T == CidadeModel) {
      final cidades = await conn?.cidadeModels.filter().ufEqualTo(query ?? '').findAll() as List<T>?;
      return cidades;
    } else {
      return conn?.collection<T>().where().findAllSync();
    }
  }

  @override
  Future<T?> openDatabase<T>(Map<String, dynamic> path) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      conn = await Isar.open(
        [CidadeModelSchema, EstadoModelSchema],
        directory: dir.path,
      );
      return true as T;
    } catch (e) {
      return false as T;
    }
  }

  @override
  Future<int> insert<T>({required T value}) async {
    try {
      conn?.writeTxnSync(() => conn?.collection<T>().putSync(value));
      return 1;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<int> insertAll<T>({required List<T> value}) async {
    try {
      conn?.writeTxnSync(() => conn?.collection<T>().putAllSync(value));
      return 1;
    } catch (e) {
      return 0;
    }
  }
}
