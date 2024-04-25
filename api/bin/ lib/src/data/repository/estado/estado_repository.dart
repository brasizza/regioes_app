import '../../models/estado_model.dart';

abstract interface class EstadoRepository {
  Future<List<EstadoModel>> getEstados();
}
