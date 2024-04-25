import 'package:app/src/core/database/database.dart';
import 'package:app/src/core/database/database_isar_impl.dart';
import 'package:app/src/data/models/cidade_model.dart';
import 'package:app/src/data/models/estado_model.dart';
import 'package:app/src/data/repository/cidade/cidade_repository.dart';
import 'package:app/src/data/repository/cidade/cidade_repository_impl.dart';
import 'package:app/src/data/repository/estado/estado_repository.dart';
import 'package:app/src/data/repository/estado/estado_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerLazySingleton(() => Dio());
  final Database database = DatabaseIsarImpl.i;
  await database.openDatabase({});
  GetIt.I.registerLazySingleton<Database>(() => database);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CidadeRepository _cidadeRepository = CidadeRepositoryImpl(dio: GetIt.I.get(), database: GetIt.I.get());
  final EstadoRepository _estadoRepository = EstadoRepositoryImpl(dio: GetIt.I.get(), database: GetIt.I.get());

  EstadoModel? estadoSelecionado;
  CidadeModel? cidadeSelecionada;

  List<EstadoModel> estados = [];
  List<CidadeModel> cidades = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pegarEstados();
  }

  void _pegarCidades({required String uf}) {
    _cidadeRepository.getCidades(uf: uf).then((cidadesResponse) {
      cidades.clear();
      setState(() {
        if (cidadesResponse != null) {
          cidades.addAll(cidadesResponse);
        }
      });
    });
  }

  void _pegarEstados() {
    _estadoRepository.getEstados().then((estadosResponse) {
      estados.clear();
      setState(() {
        if (estadosResponse != null) {
          estados.addAll(estadosResponse);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: const Color(0xFFE2E6E8).withOpacity(0.9),
              child: DropdownButton<EstadoModel?>(
                isExpanded: true,
                elevation: 2,
                underline: const SizedBox(),
                value: estadoSelecionado,
                hint: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Selecione o estado"),
                ),
                onChanged: (motivo) {
                  setState(() {
                    estadoSelecionado = motivo;
                    setState(() {
                      cidades.clear();
                      cidadeSelecionada = null;
                    });
                    _pegarCidades(uf: estadoSelecionado?.sigla ?? '');
                  });
                },
                items: estados
                    .map((estado) => DropdownMenuItem(
                          value: estado,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              estado.nome,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: const Color(0xFFE2E6E8).withOpacity(0.9),
              child: DropdownButton<CidadeModel?>(
                isExpanded: true,
                elevation: 2,
                underline: const SizedBox(),
                value: cidadeSelecionada,
                hint: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Selecione a cidade"),
                ),
                onChanged: (motivo) {
                  setState(() {
                    cidadeSelecionada = motivo;
                  });
                },
                items: cidades
                    .map((cidade) => DropdownMenuItem(
                          value: cidade,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              cidade.nome,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
