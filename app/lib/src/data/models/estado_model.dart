// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:isar/isar.dart';
part 'estado_model.g.dart';

@Collection()
class EstadoModel {
  final Id id;
  final String sigla;
  final String nome;
  EstadoModel({
    required this.id,
    required this.sigla,
    required this.nome,
  });

  EstadoModel copyWith({
    int? id,
    String? sigla,
    String? nome,
  }) {
    return EstadoModel(
      id: id ?? this.id,
      sigla: sigla ?? this.sigla,
      nome: nome ?? this.nome,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sigla': sigla,
      'nome': nome,
    };
  }

  factory EstadoModel.fromMap(Map<String, dynamic> map) {
    return EstadoModel(
      id: (map['id']),
      sigla: map['sigla'] as String,
      nome: map['nome'] as String,
    );
  }

  toJson() => (toMap());
  factory EstadoModel.fromJson(String source) => EstadoModel.fromMap(json.decode(source) as Map<String, dynamic>);
  @override
  String toString() => 'EstadoModel(id: $id, sigla: $sigla, nome: $nome)';

  @override
  bool operator ==(covariant EstadoModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.sigla == sigla && other.nome == nome;
  }

  @override
  int get hashCode => id.hashCode ^ sigla.hashCode ^ nome.hashCode;
}
