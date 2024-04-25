import 'package:dio/dio.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_mysql_impl.dart';
import '../../models/estado_model.dart';
import 'estado_repository.dart';

class EstadoRepositoryImpl implements EstadoRepository {
  final Dio _dio;
  final Database _database;

  EstadoRepositoryImpl({required Dio dio, required Database database})
      : _dio = dio,
        _database = database;

  @override
  Future<List<EstadoModel>> getEstados() async {
    final urlEstados = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados';
    final estadosDatabase = await _database.getData("estados");
    if (estadosDatabase?.isNotEmpty ?? false) {
      return (estadosDatabase)!.map((estado) => EstadoModel.fromMap(estado)).toList();
    }

    final response = await _dio.get(urlEstados);

    if (response.statusCode != 200) {
      return [];
    } else {
      final estados = (response.data as List).map((estado) => EstadoModel.fromMap(estado)).toList();
      await _salvarEstados(estados);
      return estados;
    }
  }

  Future<void> _salvarEstados(List<EstadoModel> estados) async {
    final dadosInsert = estados.map((e) => e.toMap()).toList();
    await _database.insertAll(tableName: 'estados', value: dadosInsert);
  }
}
