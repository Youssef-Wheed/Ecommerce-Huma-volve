class TokenStorage {
  static String? accessToken;
  static String? refreshToken;

  static void clear() {
    accessToken = null;
    refreshToken = null;
  }
}