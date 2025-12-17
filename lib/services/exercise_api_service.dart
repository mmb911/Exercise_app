import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/network/dio_client.dart';
import '../models/exercise_model.dart';

class ExerciseApiService {
  final Dio _dio = DioClient().dio;
  final _logger = Logger();

  // RapidAPI configuration from environment variables
  static String get _rapidApiKey => dotenv.env['RAPID_API_KEY'] ?? '';
  static String get _rapidApiHost =>
      dotenv.env['RAPID_API_HOST'] ?? 'exercisedb.p.rapidapi.com';

  // Get all exercises with pagination
  Future<List<ExerciseModel>> getAllExercises({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/exercises',
        queryParameters: {'limit': limit, 'offset': offset},
        options: Options(
          headers: {
            'X-RapidAPI-Key': _rapidApiKey,
            'X-RapidAPI-Host': _rapidApiHost,
          },
        ),
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => ExerciseModel.fromJson(json))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Error fetching exercises: ${e.message}');
      throw _handleDioError(e);
    }
  }

  // Search exercises by name
  Future<List<ExerciseModel>> searchExercises(String query) async {
    try {
      final response = await _dio.get(
        '/exercises/name/$query',
        options: Options(
          headers: {
            'X-RapidAPI-Key': _rapidApiKey,
            'X-RapidAPI-Host': _rapidApiHost,
          },
        ),
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => ExerciseModel.fromJson(json))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Error searching exercises: ${e.message}');
      throw _handleDioError(e);
    }
  }

  // Get exercises by body part
  Future<List<ExerciseModel>> getExercisesByBodyPart(String bodyPart) async {
    try {
      final response = await _dio.get(
        '/exercises/bodyPart/$bodyPart',
        options: Options(
          headers: {
            'X-RapidAPI-Key': _rapidApiKey,
            'X-RapidAPI-Host': _rapidApiHost,
          },
        ),
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => ExerciseModel.fromJson(json))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Error fetching exercises by body part: ${e.message}');
      throw _handleDioError(e);
    }
  }

  // Get exercises by equipment
  Future<List<ExerciseModel>> getExercisesByEquipment(String equipment) async {
    try {
      final response = await _dio.get(
        '/exercises/equipment/$equipment',
        options: Options(
          headers: {
            'X-RapidAPI-Key': _rapidApiKey,
            'X-RapidAPI-Host': _rapidApiHost,
          },
        ),
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => ExerciseModel.fromJson(json))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Error fetching exercises by equipment: ${e.message}');
      throw _handleDioError(e);
    }
  }

  // Get exercises by target muscle
  Future<List<ExerciseModel>> getExercisesByTarget(String target) async {
    try {
      final response = await _dio.get(
        '/exercises/target/$target',
        options: Options(
          headers: {
            'X-RapidAPI-Key': _rapidApiKey,
            'X-RapidAPI-Host': _rapidApiHost,
          },
        ),
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => ExerciseModel.fromJson(json))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      _logger.e('Error fetching exercises by target: ${e.message}');
      throw _handleDioError(e);
    }
  }

  // Get exercise by ID
  Future<ExerciseModel?> getExerciseById(String id) async {
    try {
      final response = await _dio.get(
        '/exercises/exercise/$id',
        options: Options(
          headers: {
            'X-RapidAPI-Key': _rapidApiKey,
            'X-RapidAPI-Host': _rapidApiHost,
          },
        ),
      );

      if (response.data != null) {
        return ExerciseModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      _logger.e('Error fetching exercise by ID: ${e.message}');
      throw _handleDioError(e);
    }
  }

  // Handle Dio errors
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timeout. Please check your internet connection';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error. Please try again';
    }
  }
}
