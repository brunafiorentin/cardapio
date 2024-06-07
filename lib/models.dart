import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class Comida {
  final String title;
  final String description;
  final String price;
  final String image;

  Comida({required this.title, required this.description, required this.price, required this.image});

  factory Comida.fromJson(Map<String, dynamic> json) => _$ComidaFromJson(json);
  Map<String, dynamic> toJson() => _$ComidaToJson(this);
}
