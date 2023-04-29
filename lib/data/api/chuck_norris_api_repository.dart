import 'dart:convert';

import 'package:cv/cv.dart';
import 'package:http/http.dart' as http;

class ChuckNorrisApiRepository {
  Future<ListApiResponse<String>> getJokeCategories() async {
    final Uri uri = ChuckNorrisApi.jokeCategories();

    final ListApiResponse<String> apiResponse =
        ListApiResponse(requestUrl: uri.toString());

    return await http.get(uri).then(
          (final response) => apiResponse..complete(response.body),
        );
  }

  Future<ObjectApiResponse<Joke>> getRandomJoke({
    final String? category,
  }) async {
    final Uri uri = ChuckNorrisApi.randomJoke(category);

    final ObjectApiResponse<Joke> apiResponse =
        ObjectApiResponse(requestUrl: uri.toString());

    return await http.get(uri).then(
          (final response) => apiResponse..complete(response.body),
        );
  }
}

class ChuckNorrisApi {
  static const String address = 'api.chucknorris.io';
  static const String logoPath = 'img/chucknorris_icon.png';
  static const String jokeCategoriesPath = 'jokes/categories';
  static const String randomJokePath = 'jokes/random';

  static Uri api() => Uri.https(address);
  static Uri logo() => Uri.https(address, logoPath);
  static Uri jokeCategories() => Uri.https(address, jokeCategoriesPath);
  static Uri randomJoke([final String? category]) => Uri.https(
        address,
        randomJokePath,
        category == null ? null : {'category': category},
      );
}

class ObjectApiResponse<T extends ApiResponseData> extends ApiResponse {
  late final T data;

  ObjectApiResponse({final String? requestUrl}) : super(requestUrl: requestUrl);

  @override
  void _setData(final String rawData) =>
      data = (jsonDecode(rawData) as Map).cv<T>()..response = this;
}

class MapApiResponse extends ApiResponse {
  late final Map<String, dynamic> data;

  MapApiResponse({final String? requestUrl}) : super(requestUrl: requestUrl);

  @override
  void _setData(final String rawData) =>
      data = Map<String, dynamic>.from(jsonDecode(rawData) as Map);
}

class ListApiResponse<T> extends ApiResponse {
  late final List<T> data;

  ListApiResponse({final String? requestUrl}) : super(requestUrl: requestUrl);

  @override
  void _setData(final String rawData) =>
      data = List<T>.from(jsonDecode(rawData) as List<dynamic>);
}

abstract class ApiResponse {
  final String? requestUrl;
  final DateTime startedAt = DateTime.now();
  late final Duration duration;
  late final String rawData;

  ApiResponse({this.requestUrl});

  void complete(final String responseBody) {
    rawData = responseBody;
    duration = DateTime.now().difference(startedAt);

    _setData(rawData);
  }

  void _setData(final String rawData);
}

class Joke extends ApiResponseData {
  final categories = CvListField<String>('categories');
  final createdAt = CvField<String>('created_at');
  final iconUrl = CvField<String>('icon_url');
  final id = CvField<String>('id');
  final updatedAt = CvField<String>('updated_at');
  final url = CvField<String>('url');
  final value = CvField<String>('value');

  @override
  List<CvField> get fields => [
        categories,
        createdAt,
        iconUrl,
        id,
        updatedAt,
        url,
        value,
      ];
}

abstract class ApiResponseData extends CvModelBase {
  late final ApiResponse response;
}
