class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final UserData? user;
  final String? error;

  AuthResponse({this.accessToken, this.refreshToken, this.user, this.error});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final session = json['session'];
    final user = json['user'];

    return AuthResponse(
      accessToken: session != null ? session['access_token'] : null,
      refreshToken: session != null ? session['refresh_token'] : null,
      user: user != null ? UserData.fromJson(user) : null,
      error: json['error'],
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl; // Field Baru

  UserData({required this.id, required this.email, this.name, this.avatarUrl});

  factory UserData.fromJson(Map<String, dynamic> json) {
    final metadata = json['user_metadata'];

    return UserData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      // Supabase kadang simpan nama/avatar di root user object, kadang di metadata
      // Kita cek dua-duanya biar aman
      name: (metadata != null && metadata['name'] != null)
          ? metadata['name']
          : json['name'],
      avatarUrl: (metadata != null && metadata['avatar_url'] != null)
          ? metadata['avatar_url']
          : json['avatar_url'],
    );
  }
}
