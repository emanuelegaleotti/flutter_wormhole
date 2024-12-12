class KeycloakUser {
  final String email;
  final String preferred_username;

  KeycloakUser({required this.email, required this.preferred_username});

  factory KeycloakUser.fromJson(Map<String, dynamic> json) {
    return KeycloakUser(
        email: json['email'], preferred_username: json['preferred_username']);
  }
}
