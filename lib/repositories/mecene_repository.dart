import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/src/io_web_auth.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';



class MeceneRepository {
  final String host;
  final String clientId;
  static final GoogleOAuth2Client _client = GoogleOAuth2Client(
    customUriScheme: 'com.example.mecene',
    redirectUri: 'com.example.mecene:/oauth2redirect',
  );

  AccessTokenResponse? _token;
  late final OAuth2Helper _oauth2Helper;

  MeceneRepository({required this.host, required this.clientId}) {
    _oauth2Helper = OAuth2Helper(
      _client,
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: clientId,
      scopes: ['https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/userinfo.profile'],
      webAuthClient: IoWebAuth(),
      webAuthOpts: {'preferEphemeral': true},
    );

    _oauth2Helper.getTokenFromStorage().then((AccessTokenResponse? response) {
      _token = response;
      log(name: "MeceneRepository", '$_token');

      if (response != null) {
        if (response.isExpired()) {
          _oauth2Helper.refreshToken(response);
        }
      }
    });
  }

  bool get logged => _token != null;

  Future<bool> logIn() async {
    _token = await _oauth2Helper.getToken();

    if (_token != null) {
      Response response = await post(Uri.parse(host), headers: {'Authorization': 'Bearer ${_token!.respMap['id_token']}'});

      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  void logOut() {
    _oauth2Helper.disconnect();
  }
}
