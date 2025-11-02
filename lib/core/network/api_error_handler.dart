import 'dart:io';
import 'package:dio/dio.dart';

class ErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return "Connection timeout, please try again later.";
      }

      if (error.type == DioExceptionType.badResponse) {
        final response = error.response;

        if (response?.data is Map<String, dynamic>) {
          final message = response?.data['message'];
          if (message != null && message.toString().isNotEmpty) {
            return message.toString();
          }
        }

        switch (response?.statusCode) {
          case 400:
            return "Bad request. Please check your input.";
          case 401:
            return "Unauthorized. Please log in again.";
          case 403:
            return "Access denied.";
          case 404:
            return "Endpoint not found.";
          case 500:
            return "Internal server error.";
          default:
            return "Unexpected server error.";
        }
      }

      if (error.type == DioExceptionType.unknown) {
        if (error.error is SocketException) {
          return "No internet connection. Please check your network.";
        }
      }
      
      // Connection error (network unreachable)
      if (error.type == DioExceptionType.connectionError) {
        return "Connection error. Please check your internet connection.";
      }

      return "Something went wrong. Please try again.";
    } else {
      return "Unexpected error occurred.";
    }
  }
}