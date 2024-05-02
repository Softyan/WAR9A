import 'package:dart_mappable/dart_mappable.dart';

part 'data_result.mapper.dart';

sealed class BaseResult<T> {
  TResult when<TResult extends Object?>({
    required TResult Function(T data) result,
    required TResult Function(String message) error,
  }) =>
      switch (this) {
        DataResult(:final data) => result(data),
        ErrorResult(:final message) => error(message)
      };
}

@MappableClass()
class DataResult<T> extends BaseResult<T> with DataResultMappable<T> {
  final T data;
  DataResult(this.data);
}

@MappableClass()
class ErrorResult<T> extends BaseResult<T> with ErrorResultMappable<T> {
  final String message;
  ErrorResult(this.message);
}