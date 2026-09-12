import 'dart:io';

import 'package:dio/dio.dart';

import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';

/// `uploadType` values accepted by `POST /files/upload/request-url`.
class UploadTypes {
  UploadTypes._();

  static const String avatar = 'avatar';
  static const String propertyImage = 'property_image';
  static const String idFront = 'id_front';
  static const String idBack = 'id_back';
  static const String selfie = 'selfie';
  static const String checklistPhoto = 'checklist_photo';
  static const String violationEvidence = 'violation_evidence';
  static const String chatAttachment = 'chat_attachment';
}

/// A pre-signed upload slot returned by the backend.
class UploadTicket {
  /// Correlation id echoed back to `/files/upload/confirm`.
  final String uploadId;

  /// The S3 key the object will live at.
  final String objectKey;

  /// The pre-signed URL to PUT the bytes to.
  final String uploadUrl;

  /// Extra headers S3 requires on the PUT (usually just `Content-Type`).
  final Map<String, String> headers;

  const UploadTicket({
    required this.uploadId,
    required this.objectKey,
    required this.uploadUrl,
    this.headers = const {},
  });

  factory UploadTicket.fromJson(Map<String, dynamic> json) {
    final rawHeaders = json['headers'];
    return UploadTicket(
      uploadId: '${json['uploadId'] ?? json['upload_id'] ?? ''}',
      objectKey: '${json['objectKey'] ?? json['object_key'] ?? ''}',
      uploadUrl:
          '${json['uploadUrl'] ?? json['upload_url'] ?? json['url'] ?? ''}',
      headers: rawHeaders is Map
          ? rawHeaders.map((k, v) => MapEntry('$k', '$v'))
          : const {},
    );
  }
}

/// Implements the three-step upload documented in the mobile API guide:
///
/// 1. `POST /files/upload/request-url` - ask for a pre-signed S3 URL,
/// 2. `PUT <uploadUrl>` - send the bytes **straight to S3**,
/// 3. `POST /files/upload/confirm` - persist the object key.
///
/// Step 2 must not carry the Sahely `Authorization` header (S3 rejects the
/// request when it sees one alongside the pre-signed query signature), so it
/// goes out on a bare Dio instance rather than through [ApiClient].
class FileUploadApi {
  final ApiClient _apiClient;
  final Dio _rawDio;

  FileUploadApi(this._apiClient, {Dio? rawDio})
      : _rawDio = rawDio ?? Dio(BaseOptions(followRedirects: false));

  /// Runs all three steps and returns the stored object key.
  Future<String> uploadFile({
    required String filePath,
    required String uploadType,
    String? propertyId,
    String? oldObjectKey,
    void Function(int sent, int total)? onProgress,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw ArgumentError('File not found: $filePath');
    }

    final bytes = await file.readAsBytes();
    final contentType = _contentTypeFor(filePath);

    final ticket = await requestUploadUrl(
      uploadType: uploadType,
      propertyId: propertyId,
      contentType: contentType,
      fileSize: bytes.length,
    );

    await putToStorage(
      ticket: ticket,
      bytes: bytes,
      contentType: contentType,
      onProgress: onProgress,
    );

    await confirmUpload(
      uploadId: ticket.uploadId,
      objectKey: ticket.objectKey,
      oldObjectKey: oldObjectKey,
    );

    return ticket.objectKey;
  }

  /// Step 1.
  Future<UploadTicket> requestUploadUrl({
    required String uploadType,
    String? propertyId,
    String? contentType,
    int? fileSize,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.uploadRequestUrl,
      data: {
        'uploadType': uploadType,
        if (propertyId != null) 'propertyId': propertyId,
        if (contentType != null) 'contentType': contentType,
        if (fileSize != null) 'fileSize': fileSize,
      },
    );
    return UploadTicket.fromJson(asMap(unwrapData(response.data)));
  }

  /// Step 2 - a direct PUT to S3, deliberately outside [ApiClient].
  Future<void> putToStorage({
    required UploadTicket ticket,
    required List<int> bytes,
    String? contentType,
    void Function(int sent, int total)? onProgress,
  }) async {
    await _rawDio.put<void>(
      ticket.uploadUrl,
      data: Stream.fromIterable([bytes]),
      onSendProgress: onProgress,
      options: Options(
        headers: {
          Headers.contentLengthHeader: bytes.length,
          if (contentType != null) Headers.contentTypeHeader: contentType,
          ...ticket.headers,
        },
      ),
    );
  }

  /// Step 3.
  Future<void> confirmUpload({
    required String uploadId,
    required String objectKey,
    String? oldObjectKey,
  }) async {
    await _apiClient.post(
      ApiEndpoints.uploadConfirm,
      data: {
        'uploadId': uploadId,
        'objectKey': objectKey,
        if (oldObjectKey != null) 'oldObjectKey': oldObjectKey,
      },
    );
  }

  static String _contentTypeFor(String path) {
    final extension = path.split('.').last.toLowerCase();
    return switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      'gif' => 'image/gif',
      'mp4' => 'video/mp4',
      'pdf' => 'application/pdf',
      _ => 'image/jpeg',
    };
  }
}
