import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../data/repository/cidade/cidade_repository.dart';
import '../data/repository/estado/estado_repository.dart';

class IbgeController {
  final EstadoRepository _estadoRepository;
  final CidadeRepository _cidadeRepository;

  IbgeController({required EstadoRepository estadoRepository, required CidadeRepository cidadeRepository})
      : _estadoRepository = estadoRepository,
        _cidadeRepository = cidadeRepository;

  Future<Response> getEstados(Request request) async {
    final estados = await _estadoRepository.getEstados();
    return Response.ok(json.encode(estados), headers: {'Content-Type': 'text/json'});
  }

  Future<Response> getCidades(Request request, String uf) async {
    final estados = await _cidadeRepository.getCidades(uf: uf);
    return Response.ok(json.encode(estados), headers: {'Content-Type': 'text/json'});
  }
}
