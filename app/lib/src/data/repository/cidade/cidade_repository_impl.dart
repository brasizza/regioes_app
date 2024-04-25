import 'package:app/src/core/database/consts/const.dart';
import 'package:app/src/core/database/database.dart';
import 'package:dio/dio.dart';

import '../../models/cidade_model.dart';
import './cidade_repository.dart';

class CidadeRepositoryImpl implements CidadeRepository {
  final Dio _dio;
  final Database _database;

  CidadeRepositoryImpl({required Dio dio, required Database database})
      : _dio = dio,
        _database = database;

  @override
  Future<List<CidadeModel>?> getCidades({required String uf}) async {
    final urlCidades = '${Const.baseUrl}/cidades/${uf.toUpperCase()}';
    final cidadesDatabase = await _database.getData<CidadeModel>(uf);
    if (cidadesDatabase?.isNotEmpty ?? false) {
      return cidadesDatabase;
    }

    final response = await _dio.get(urlCidades);
    if (response.statusCode != 200) {
      return [];
    } else {
      final cidades = (response.data as List).map((estado) => CidadeModel.fromMap(estado)).toList();

      await _database.insertAll<CidadeModel>(value: cidades);
      return cidades;
    }
  }
}
