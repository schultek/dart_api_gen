library dart_api_gen;

import 'package:dart_api_gen/client.dart';

import 'core.dart';

export 'core.dart';
export 'src/exception/api_exception.dart';

/// Used to annotate a class
/// in order to generate api code
class ApiDefinition {
  final ApiCodec? codec;
  const ApiDefinition({this.codec});
}

class ApiRequest {
  final String method;
  final Map<String, dynamic> parameters;

  Map<String, dynamic> data;
  ApiCodec? codec;

  ApiRequest(this.method, this.parameters, {this.data = const {}, this.codec});

  void set(String key, dynamic value) {
    data = {...data, key: value};
  }

  dynamic encode(dynamic value) => codec != null ? codec!.encode(value) : value;
  T decode<T>(dynamic value) =>
      codec != null ? codec!.decode(value) : value as T;

  T get<T>(String key) {
    if (parameters[key] == null) {
      throw ApiException.invalidParams("Missing parameter '$key' of type $T.");
    }
    return decode(parameters[key]);
  }

  T? getOpt<T>(String key) => parameters[key] != null ? get<T>(key) : null;

  T getData<T>(String key) {
    if (data[key] == null) {
      throw ApiException.invalidParams("Missing data '$key' of type $T.");
    }
    return decode(data[key]);
  }

  T? getDataOpt<T>(String key) => data[key] != null ? getData<T>(key) : null;
}