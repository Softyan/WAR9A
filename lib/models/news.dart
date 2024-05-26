import 'package:dart_mappable/dart_mappable.dart';

part 'news.mapper.dart';

@MappableClass(ignoreNull: true, caseStyle: CaseStyle.snakeCase)
class News with NewsMappable {
  final int id;
  final String title;
  final List<String>? contents;
  final String createdBy;
  final DateTime? createdAt;

  const News({
    this.id = 0,
    this.title = '',
    this.contents,
    this.createdBy = '',
    this.createdAt,
  });
  factory News.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return NewsMapper.fromMap(json);
    if (json is String) return NewsMapper.fromJson(json);
    return throw Exception(
        'The argument type \'${json.runtimeType}\' can\'t be assigned');
  }
}
