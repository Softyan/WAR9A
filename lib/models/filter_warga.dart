import 'package:dart_mappable/dart_mappable.dart';

part 'filter_warga.mapper.dart';

@MappableClass()
class FilterWarga with FilterWargaMappable {
  final int? rt;
  final bool? isStay;

  const FilterWarga({this.rt, this.isStay});

  factory FilterWarga.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return FilterWargaMapper.fromMap(json);
    if (json is String) return FilterWargaMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }
}
