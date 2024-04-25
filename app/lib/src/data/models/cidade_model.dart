// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:isar/isar.dart';

part 'cidade_model.g.dart';

@Collection()
class CidadeModel {
  final Id id;
  final String uf;
  final String nome;
  CidadeModel({
    required this.id,
    required this.uf,
    required this.nome,
  });

  CidadeModel copyWith({
    int? id,
    String? uf,
    String? nome,
  }) {
    return CidadeModel(
      id: id ?? this.id,
      uf: uf ?? this.uf,
      nome: nome ?? this.nome,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uf': uf,
      'nome': nome,
    };
  }

  factory CidadeModel.fromMap(Map<String, dynamic> map) {
    return CidadeModel(
      id: int.parse(map['id'].toString()),
      uf: map['uf'],
      nome: map['nome'],
    );
  }

  Map toJson() => (toMap());

  factory CidadeModel.fromJson(String source) => CidadeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CidadeModel(id: $id, uf: $uf, nome: $nome)';

  @override
  bool operator ==(covariant CidadeModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.uf == uf && other.nome == nome;
  }

  @override
  int get hashCode => id.hashCode ^ uf.hashCode ^ nome.hashCode;
}
