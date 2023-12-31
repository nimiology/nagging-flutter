import 'dart:convert';
import 'dart:io';

import '../helper/auth_jwt_token_helper.dart';

import 'package:http/http.dart' as http;

class User {
  final int id;
  final DateTime? dateJoined;
  final String? bio;
  final String? location;
  final String? link;
  bool following;
  int? followingsCount;
  int? followersCount;

  User(
      {required this.id,
      this.dateJoined,
      this.bio,
      this.link,
      this.location,
      required this.following,
      this.followingsCount,
      this.followersCount});

  Future<bool> follow() async {
    following = !following;
    String? token = await AuthToken.accessToken();
    try {
      http.Response response = await http.post(
          Uri.parse(
              'https://twitterbutanonymous.pythonanywhere.com/user/follow/user/$id/'),
          headers: {'Authorization': "Bearer $token"});
      if (response.statusCode != 200) {
        following = !following;
      }
    } on SocketException catch (_) {
      print("There is no internet connection");
    } catch (_) {
      throw _;
    }
    followersCount = followersCount! + 1;
    return following;
  }

  Future<User> minimalToAllFields() async {
    final User artist = await User.requestUserWithID(id);
    return artist;
  }

  Future<List<User>> getFollowers(
      {String ordering = '', String limit = '', String offset = ''}) async {
    String? token = await AuthToken.accessToken();
    try {
      http.Response response = await http.get(
          Uri.parse(
              'https://twitterbutanonymous.pythonanywhere.com/user/$id/follower/'
              '?ordering=$ordering&offset=$offset&limit=$limit'),
          headers: {'Authorization': "Bearer $token"});
      final followersJson = json.decode(response.body);
      if (response.statusCode == 200) {
        final users = User.userMapListToUser(followersJson['results']);
        return users;
      }
    } on SocketException catch (_) {
      print("There is no internet connection");
    } catch (_) {
      throw _;
    }
    return [];
  }

  Future<List<User>> getFollowings(
      {String ordering = '', String limit = '', String offset = ''}) async {
    String? token = await AuthToken.accessToken();
    try {
      http.Response response = await http.get(
          Uri.parse(
              'https://twitterbutanonymous.pythonanywhere.com/user/$id/following/'
              '?ordering=$ordering&offset=$offset&limit=$limit'),
          headers: {'Authorization': "Bearer $token"});
      final followingJson = json.decode(response.body);
      if (response.statusCode == 200) {
        final users = User.userMapListToUser(followingJson['results']);
        return users;
      }
    } on SocketException catch (_) {
      print("There is no internet connection");
    } catch (_) {
      throw _;
    }
    return [];
  }

  Future updateUser(
      {String? bioParameters,
      String? locationParameters,
      String? linkParameters}) async {
    String? token = await AuthToken.accessToken();
    try {
      final requestBody = {};
      if (bio != null || bioParameters != null) {
        requestBody['bio'] = (bioParameters ?? bio)!;
      }
      if (link != null || linkParameters != null) {
        requestBody['link'] = (linkParameters ?? link)!;
      }
      if (location != null || locationParameters != null) {
        requestBody['location'] = (locationParameters ?? location)!;
      }

      var request = await http.patch(
          Uri.parse(
              'https://twitterbutanonymous.pythonanywhere.com/auth/users/me/'),
          headers: {'Authorization': "Bearer $token"},
          body: requestBody);
      final userJson = json.decode(request.body);
      if (request.statusCode == 200) {
        final user = User.userFromMap(userJson);
        return user;
      }
      else{
        print(request.body);
      }
      print(userJson);
    } on SocketException catch (_) {
      print("There is no internet connection");
    } catch (_) {
      throw _;
    }
    return null;
  }

  static List<User> userMapListToUser(List users) {
    List<User> userList = [];
    for (Map user in users) {
      userList.add(User.minimalUserFromMap(user));
    }
    return userList;
  }

  static Future<User> requestUserWithID(int id) async {
    String? token = await AuthToken.accessToken();
    http.Response response = await http.get(
        Uri.parse(
            'https://twitterbutanonymous.pythonanywhere.com/user/get/$id'),
        headers: {'Authorization': "Bearer $token"});
    final userJson = json.decode(response.body);
    return User.userFromMap(userJson);
  }

  static Future<User> me() async {
    String? token = await AuthToken.accessToken();
    http.Response response = await http.get(
        Uri.parse(
            'https://twitterbutanonymous.pythonanywhere.com/auth/users/me/'),
        headers: {'Authorization': "Bearer $token"});
    final userJson = json.decode(response.body);
    return User.userFromMap(userJson);
  }

  static User minimalUserFromMap(userJson) {
    return User(id: userJson['id'], following: userJson['following']);
  }

  static User userFromMap(userJson) {
    return User(
        id: userJson['id'],
        bio: userJson['bio'],
        location: userJson['location'],
        followingsCount: userJson['followings_count'],
        followersCount: userJson['followers_count'],
        following: userJson['following'],
        dateJoined: DateTime.parse(userJson['date_joined']));
  }
}
