import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static Dio callDio() {
    //
    // TODO configurar dio para que apunte al flavor actual
    String baseUrl = dotenv.env['BASE_URL']!;
    String apiKey = dotenv.env['API_KEY']!;

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 2500),
        receiveTimeout: const Duration(milliseconds: 3000),
        queryParameters: {
          'api_key': apiKey,
          'language': 'es-MX',
        },
      ),
    );
    return dio;
  }
}

abstract class MoviesDatasource {
  Future<String> getMoviesList({required int page, required String moviesList});
}

class MoviesDatasourceImpl extends MoviesDatasource {
  final dio = DioClient.callDio();

  Future<String> getMoviesList({required int page, required String moviesList}) async {
    try {
      final dioResponse = await dio.get(
        '/movie/$moviesList',
        queryParameters: {
          'page': page,
        },
      );
      final result = dioResponse.data;
      return result;
    } on DioException catch (error) {
      print('err $error');
      throw Exception();
    }
  }
}
