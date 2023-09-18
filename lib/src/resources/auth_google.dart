import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class AuthGoogle {
  final String fileJson;
  final List<String> scope;

  AuthGoogle(
      {required this.fileJson,
      this.scope = const ["https://www.googleapis.com/auth/cloud-platform"]});

  String? _projectId;
  String? _sessionId;
  AccessCredentials? _credentials;

  Future<String> getReadJson() async {
    String data = await rootBundle.loadString(this.fileJson);
    return data;
  }

  Future<AuthGoogle> build() async {
    String readJson = await getReadJson();
    Map jsonData = json.decode(readJson);
    var _credentialsResponse = new ServiceAccountCredentials.fromJson(readJson);
    var data = await clientViaServiceAccount(_credentialsResponse, this.scope);
    _projectId = jsonData['project_id'];
    _sessionId = getRandomNumberString();
    _credentials = data.credentials;
    return this;
  }

  String getRandomNumberString() {
    int min = 100000; //min and max values act as your 6 digit range
    int max = 999999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);
    return rNum.toString();
  }

  bool get hasExpired {
    return _credentials?.accessToken.hasExpired == true;
  }

  String? get getSessionId {
    return _sessionId;
  }

  String? get getProjectId {
    return _projectId;
  }

  String? get getToken {
    return _credentials?.accessToken.data;
  }

  Future<Response> post(url,
      {required Map<String, String> headers, body,  Encoding? encoding}) async {
    if (!hasExpired) {
      return await http.post(url, headers: headers, body: body);
    } else {
      await build();
      return await http.post(url, headers: headers, body: body);
    }
  }

  Future<Response> delete(url,
      {required Map<String, String> headers, body,  Encoding? encoding}) async {
    return await http.delete(url, headers: headers);
  }
}
