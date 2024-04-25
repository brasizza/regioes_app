import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import ' lib/src/core/consts/consts.dart';
import ' lib/src/core/database/database.dart';
import ' lib/src/core/database/database_mysql_impl.dart';
import ' lib/src/core/database/file_store_database_impl.dart';
import ' lib/src/routes/ibge_routes.dart';

void main(List<String> args) async {
  // final MysqlDatabase database = await MysqlDatabase.i.openDatabase({"host": Consts.host, "port": Consts.port, "userName": Consts.userName, "password": Consts.password, "databaseName": Consts.database, "secure": Consts.secure});
  final Database database = FileStoreDatabase.i;
  GetIt.I.registerLazySingleton(() => Dio());
  GetIt.I.registerLazySingleton<Database>(() => database);
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final Router router = Router();
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(IbgeRoutes.routes(
        router,
      ).call);
  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
