class User {
  final int id;
  final DateTime? dateJoined;
  final String? bio;
  final String? location;
  final bool following;
  final int? followingCount;
  final int? followersCount;

  User(
      {required this.id,
      this.dateJoined,
      this.bio,
      this.location,
      required this.following,
      this.followingCount,
      this.followersCount});

  static User minimalUserFromMap(userJson) {
    return User(id: userJson['id'], following: userJson['following']);
  }

  static User userFromMap(userJson) {
    return User(
        id: userJson['id'],
        bio: userJson['bio'],
        location: userJson['location'],
        followingCount: userJson['followings_count'],
        followersCount: userJson['followers_count'],
        following: userJson['following'],
        dateJoined: DateTime.parse(userJson['date_joined']));
  }
}
