import 'package:dio/dio.dart';

import '../../../core/database/database.dart';
import '../../../core/database/database_mysql_impl.dart';
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
    final urlCidades = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados/${uf.toUpperCase()}/municipios';
    final cidadesDatabase = await _database.getData(uf.toUpperCase());
    if (cidadesDatabase?.isNotEmpty ?? false) {
      return (cidadesDatabase)!.map((estado) => CidadeModel.fromMap(estado)).toList();
    }

    final response = await _dio.get(urlCidades);

    if (response.statusCode != 200) {
      return [];
    } else {
      final cidades = (response.data as List).map((estado) => CidadeModel.fromMap(estado)).toList();
      await _salvarCidades(cidades, uf);
      return cidades;
    }
  }

  Future<void> _salvarCidades(List<CidadeModel> cidades, uf) async {
    final dadosInsert = cidades.map((e) => e.toMap()).toList();
    await _database.insertAll(tableName: uf, value: dadosInsert);
  }
}
