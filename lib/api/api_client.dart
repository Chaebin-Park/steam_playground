import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
                connectTimeout: Duration(milliseconds: 5000),
                receiveTimeout: Duration(milliseconds: 5000)));

  Future<T> get<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return parser(response.data);
      } else {
        throw Exception('Failed with status code: ${response.statusCode}');
      }
    } on DioException catch(e) {
      throw Exception('DioError: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
