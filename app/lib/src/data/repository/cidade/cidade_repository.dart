import '../../models/cidade_model.dart';

abstract interface class CidadeRepository {
  Future<List<CidadeModel>?> getCidades({required String uf});
}
