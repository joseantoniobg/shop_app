class GeneralConfig {
  static const apiToken = 'AIzaSyBt3fJ5LdXOLYmksQd7fKkC5q0YnyqNBWA';
  static const _baseAuthURL =
      'https://identitytoolkit.googleapis.com/v1/accounts:';
  static const baseURL = 'https://shop-app-14f38-default-rtdb.firebaseio.com';
  static const authSignUpURL = _baseAuthURL + 'signUp?key=' + apiToken;
  static const authLogInURL =
      _baseAuthURL + 'signInWithPassword?key=' + apiToken;
}
