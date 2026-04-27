import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const Duration _timeout = Duration(seconds: 12);

  Future<AuthResponse> login({
    required String email,
    required String senha,
  }) {
    return _post(
      '/auth/login',
      <String, dynamic>{
        'email': email.trim(),
        'senha': senha,
      },
    );
  }

  Future<AuthResponse> register({
    required String nome,
    required String email,
    required String senha,
  }) {
    return _post(
      '/auth/register',
      <String, dynamic>{
        'nome': nome.trim(),
        'email': email.trim(),
        'senha': senha,
      },
    );
  }

  Future<AuthResponse> _post(String path, Map<String, dynamic> body) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('${_baseUrl()}$path');
      final request = await client.postUrl(uri).timeout(_timeout);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.add(utf8.encode(jsonEncode(body)));

      final response = await request.close().timeout(_timeout);
      final responseText = await response.transform(utf8.decoder).join();

      final dynamic decoded = responseText.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(responseText);
      final json = decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{};

      final message = (json['message'] is String && (json['message'] as String).trim().isNotEmpty)
          ? json['message'] as String
          : _statusMessage(response.statusCode);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return AuthResponse.success(
          message: message,
          token: json['token'] as String?,
          user: json['user'],
        );
      }

      return AuthResponse.failure(message: message);
    } on TimeoutException {
      return AuthResponse.failure(message: 'tempo de conexão esgotado');
    } on SocketException {
      return AuthResponse.failure(
        message: 'não foi possível conectar ao servidor',
      );
    } catch (_) {
      return AuthResponse.failure(message: 'erro inesperado na autenticação');
    } finally {
      client.close(force: true);
    }
  }

  String _baseUrl() {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }

    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      default:
        return 'http://localhost:3000';
    }
  }

  String _statusMessage(int statusCode) {
    if (statusCode >= 500) {
      return 'erro interno do servidor';
    }
    if (statusCode == 404) {
      return 'rota não encontrada';
    }
    return 'não foi possível concluir a autenticação';
  }
}

class AuthResponse {
  const AuthResponse._({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });

  final bool success;
  final String message;
  final String? token;
  final dynamic user;

  factory AuthResponse.success({
    required String message,
    String? token,
    dynamic user,
  }) {
    return AuthResponse._(
      success: true,
      message: message,
      token: token,
      user: user,
    );
  }

  factory AuthResponse.failure({required String message}) {
    return AuthResponse._(
      success: false,
      message: message,
    );
  }
}
