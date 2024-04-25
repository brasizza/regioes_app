import 'package:app/src/core/database/consts/const.dart';
import 'package:app/src/core/database/database.dart';
import 'package:dio/dio.dart';

import '../../models/estado_model.dart';
import 'estado_repository.dart';

class EstadoRepositoryImpl implements EstadoRepository {
  final Dio _dio;
  final Database _database;

  EstadoRepositoryImpl({required Dio dio, required Database database})
      : _dio = dio,
        _database = database;

  @override
  Future<List<EstadoModel>?> getEstados() async {
    final urlEstados = '${Const.baseUrl}/estados';
    final estadosDatabase = await _database.getData<EstadoModel>("Select * From estados");
    if (estadosDatabase?.isNotEmpty ?? false) {
      return estadosDatabase;
    }
    final response = await _dio.get(urlEstados);
    if (response.statusCode != 200) {
      return [];
    } else {
      final estados = (response.data as List).map((estado) => EstadoModel.fromMap(estado)).toList();
      await _database.insertAll<EstadoModel>(value: estados);
      return estados;
    }
  }
}
