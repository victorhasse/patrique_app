import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class ChatbotService {
  ChatbotService._();

  static final ChatbotService instance = ChatbotService._();
  static const Duration _timeout = Duration(seconds: 10);

  Future<ChatbotReply?> reply({
    required String option,
    String? email,
  }) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('${_baseUrl()}/chatbot/reply');
      final request = await client.postUrl(uri).timeout(_timeout);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.add(
        utf8.encode(
          jsonEncode(<String, dynamic>{
            'option': option,
            if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
          }),
        ),
      );

      final response = await request.close().timeout(_timeout);
      final responseText = await response.transform(utf8.decoder).join();
      final dynamic decoded = responseText.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(responseText);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final mensagem = decoded['mensagem'];
      final opcoesRaw = decoded['opcoes'];
      final opcoes = opcoesRaw is List
          ? opcoesRaw.map((item) => item.toString()).toList()
          : <String>[];

      if (mensagem is! String || mensagem.trim().isEmpty) {
        return null;
      }

      return ChatbotReply(
        mensagem: mensagem,
        opcoes: opcoes,
      );
    } on TimeoutException {
      return null;
    } on SocketException {
      return null;
    } catch (_) {
      return null;
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
}

class ChatbotReply {
  const ChatbotReply({
    required this.mensagem,
    required this.opcoes,
  });

  final String mensagem;
  final List<String> opcoes;
}
