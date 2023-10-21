import 'dart:convert';
import 'dart:io';

import '../helper/auth_jwt_token_helper.dart';
import 'user.dart';

import 'package:http/http.dart' as http;

class Nag {
  final int id;
  final User owner;
  final String content;
  final DateTime createdAt;
  final Nag? reply;
  int? userLike;
  int likesCount;

  Nag({
    required this.id,
    required this.owner,
    required this.content,
    required this.createdAt,
    this.reply,
    this.userLike,
    required this.likesCount,
  });

  Future<int?> like() async {
    String? token = await AuthToken.accessToken();
    try {
      if (userLike != null) {
        http.Response response = await http.delete(
            Uri.parse(
                'https://twitterbutanonymous.pythonanywhere.com/like/${userLike.toString()}/'),
            headers: {'Authorization': "Bearer $token"});
        if (response.statusCode == 204) {
          likesCount -= 1;
          userLike = null;
        }
      } else {
        http.Response response = await http.post(
            Uri.parse('https://twitterbutanonymous.pythonanywhere.com/like/'),
            body: {'tweet': id.toString()},
            headers: {'Authorization': "Bearer $token"});
        if (response.statusCode == 201) {
          likesCount += 1;
          final likeData = json.decode(response.body);
          userLike = likeData['id'];
        }
      }
    } on SocketException catch (_) {
      print("There is no internet connection");
    } catch (_) {
      rethrow;
    }
    return userLike;
  }

  static Future<int> nag(String content, int? reply) async {
    try {
      String? token = await AuthToken.accessToken();
      final body = {'content': content,};
      if (reply != null){
        body['reply']= reply.toString();
      }
      http.Response response = await http.post(
          Uri.parse('https://twitterbutanonymous.pythonanywhere.com/tweet/'),
          headers: {'Authorization': "Bearer $token"},
          body: body);
      return response.statusCode;
    } catch (_) {
      rethrow;
    }
  }

  static Nag nagFromDict(Map nagJson) {
    return Nag(
      id: nagJson['id'],
      owner: User.minimalUserFromMap(nagJson['owner']),
      content: nagJson['content'],
      createdAt: DateTime.parse(
        nagJson['created_at'],
      ),
      reply: nagJson['reply'],
      userLike: nagJson['user_like'],
      likesCount: nagJson['likes_count'],
    );
  }

  static Future<List<Nag>> getNags({
    String owner = '',
    String reply = '',
    String content__icontains = '',
    String created_at__gte = '',
    String created_at__lte = '',
    String created_at = '',
    String ordering = '-id',
    String limit = '',
    String offset = '',
  }) async {
    try {
      String? token = await AuthToken.accessToken();
      http.Response response = await http.get(
          Uri.parse(
              'https://twitterbutanonymous.pythonanywhere.com/tweet/?owner=$owner&reply=$reply'
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
