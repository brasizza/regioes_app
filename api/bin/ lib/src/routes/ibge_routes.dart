import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

import '../controllers/ibge_controller.dart';
import '../data/repository/cidade/cidade_repository.dart';
import '../data/repository/cidade/cidade_repository_impl.dart';
import '../data/repository/estado/estado_repository.dart';
import '../data/repository/estado/estado_repository_impl.dart';

class IbgeRoutes {
  IbgeRoutes._();

  static Router routes(Router router) {
    GetIt.I.registerSingleton<EstadoRepository>(EstadoRepositoryImpl(dio: GetIt.I.get(), database: GetIt.I.get()));
    GetIt.I.registerSingleton<CidadeRepository>(CidadeRepositoryImpl(dio: GetIt.I.get(), database: GetIt.I.get()));

    final ibgeController = IbgeController(estadoRepository: GetIt.I.get(), cidadeRepository: GetIt.I.get());

    router.add('get', '/estados', ibgeController.getEstados);
    router.add('get', '/cidades/<UF>', ibgeController.getCidades);
    return router;
  }
}
