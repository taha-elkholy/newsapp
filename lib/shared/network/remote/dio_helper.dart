import 'package:dio/dio.dart';
import 'package:my_news_app/shared/components/constants.dart';

// don't forget to init this class in your runApp method
class DioHelper {
  // get a static object of the Dio
  static late Dio dio;

  // static method for init the dio
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  //get headline news for egypt
  static Future<Response> getNews({
    required String category,
  }) async {
    return await dio.get(
      headlinesPath,
      queryParameters: {
        'category': category,
        'country': egypt,
        'apikey': apiKey,
      },
    );
  }

  // get data
  static Future<Response> searchNews({required String searchValue}) async {
    return await dio.get(
      everythingPath,
      queryParameters: {
        'q': searchValue,
        'sortBy': 'publishedAt',
        'apikey': apiKey,
      },
    );
  }
}
