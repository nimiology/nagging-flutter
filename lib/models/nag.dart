import 'dart:convert';

import '../helper/auth_jwt_token_helper.dart';
import 'user.dart';

import 'package:http/http.dart' as http;

class Nag {
  final int id;
  final User owner;
  final String content;
  final DateTime createdAt;
  final Nag? reply;
  final bool? userLike;

  Nag({
    required this.id,
    required this.owner,
    required this.content,
    required this.createdAt,
    this.reply,
    this.userLike,
  });

  static Nag nagFromDict(Map nagJson) {
    return Nag(
      id: nagJson['id'],
      owner: User.minimalUserFromMap(nagJson['artist']),
      content: nagJson['content'],
      createdAt: DateTime.parse(
        nagJson['created_at'],
      ),
      reply: nagJson['reply'],
      userLike: nagJson['user_like'],
    );
  }

  static Future<List<Nag>> getNags({
    String owner = '',
    String reply = '',
    String content__icontains = '',
    String created_at__gte = '',
    String created_at__lte = '',
    String created_at = '',
    String ordering = '',
    String limit = '',
    String offset = '',
  }) async {
    try {
      String? token = await AuthToken.accessToken();
      http.Response response = await http.get(
          Uri.parse('https://api.hallery.art/art/?owner=$owner&reply=$reply'
              '&content__icontains=$content__icontains&created_at__gte=$created_at__gte'
              '&created_at__lte=$created_at__lte&created_at=$created_at'
              '&ordering=$ordering&offset=$offset&limit=$limit'),
          headers: {'Authorization': "Bearer $token"});
      final nagsJson = json.decode(response.body)['results'];
      List<Nag> nags = [];
      for (Map nagJson in nagsJson) {
        nags.add(Nag.nagFromDict(nagJson));
      }
      return nags;
    } catch (_) {
      rethrow;
    }
  }
}
