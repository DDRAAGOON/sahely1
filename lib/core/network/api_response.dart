import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;
  final List<String>? errors;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: (json['errors'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      statusCode: json['statusCode'] as int?,
    );
  }

  @override
  List<Object?> get props => [success, message, data, errors, statusCode];
}
