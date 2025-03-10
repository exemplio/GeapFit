// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Filter _$$_FilterFromJson(Map<String, dynamic> json) => _$_Filter(
      idDocs:
          (json['id_docs'] as List<dynamic>).map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$$_FilterToJson(_$_Filter instance) => <String, dynamic>{
      'id_docs': instance.idDocs.toList(),
    };
