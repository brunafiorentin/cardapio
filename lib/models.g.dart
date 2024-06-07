// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comida _$ComidaFromJson(Map<String, dynamic> json) => Comida(
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$ComidaToJson(Comida instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'image': instance.image,
    };
