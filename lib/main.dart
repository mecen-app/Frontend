import 'package:flutter/material.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'dart:developer';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/src/io_web_auth.dart';
import 'package:oauth2_client/google_oauth2_client.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:http/http.dart' as http;

//Instantiate an OAuth2Client...
GoogleOAuth2Client client = GoogleOAuth2Client(
  customUriScheme: 'com.example.mecene',
  redirectUri: 'com.example.mecene:/oauth2redirect',
);

const String clientId = '';
const String backendHost = '';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignInButton(
              Buttons.Google,
              onPressed: () async {
                OAuth2Helper oauth2Helper = OAuth2Helper(
                  client,
                  grantType: OAuth2Helper.AUTHORIZATION_CODE,
                  clientId: clientId,
                  scopes: [
                    'https://www.googleapis.com/auth/userinfo.email',
                    'https://www.googleapis.com/auth/userinfo.profile'
                  ],
                  webAuthClient: IoWebAuth(),
                  webAuthOpts: {'preferEphemeral': true},
                );
                oauth2Helper.getToken().then((AccessTokenResponse? response) {
                  log(name: 'ID', response!.respMap['id_token']);
                  if ((response.respMap['id_token'] as String).isNotEmpty) {
                    http.post(Uri(scheme: 'http', host: backendHost, path: 'user', port: 8000), headers: {
                      'Authorization': 'Bearer ${response.respMap['id_token']}'
                    }).then((http.Response response) {
                      log(name: 'Response', response.toString());
                    }).catchError((error) => print(error));
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
