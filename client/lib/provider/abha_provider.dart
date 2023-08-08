import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ABHAProvider extends StateNotifier<AsyncValue<int>> {
  String _sessionToken = '';
  String _sessionApi = 'https://dev.abdm.gov.in/gateway/v0.5/sessions';
  String _baseURI = 'https://healthidsbx.abdm.gov.in';
  String _basePath = 'api';
  String _txId = '';
  ABHAProvider() : super(AsyncValue.loading());

  Future getSessionToken() async {
    var uri = Uri.parse(_sessionApi);
    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(
          {
            "clientId": dotenv.env['CLIENT_ID'],
            "clientSecret": dotenv.env['CLIENT_SECRET'],
          },
        ),
      );
      _sessionToken = json.decode(response.body)['accessToken'];
      print('This is teh access token ${_sessionToken}');
    } catch (err) {
      print('Error while getting sessionToken:${err}');
    }
  }

  Future aadharGenerateOtp(String aadharNumber) async {
    await getSessionToken();
    if (_sessionToken != '') {
      var uri = Uri.parse(
          '${_baseURI}/${_basePath}/v1/registration/aadhaar/generateOtp');
      print('THisi sthe aadhar number:${aadharNumber}');
      // print('THis ')
      final response = await http.post(
        uri,
        headers: {
          "accept": "*/*",
          "Accept-Language": "en-US",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_sessionToken}"
        },
        body: json.encode({"aadhaar": aadharNumber}),
      );
      print('Response of getting otp to generate id:${response.body}');

      // print(response.headers);
      _txId = json.decode(response.body)['txnId'];
      print('THis is the tx id:${_txId}');
      _sessionToken = '';
    } else {
      print('Session not set');
    }
  }

  Future aadhaarVerifyOTP(String otp) async {
    if (_txId != '') {
      var uri = Uri.parse(
          '${_baseURI}/${_basePath}/v1/registration/aadhaar/verifyOTP');
      print('This si the otp:${otp}');
      final response = await http.post(
        uri,
        headers: {
          "accept": "*/*",
          "Accept-Language": "en-US",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_sessionToken}"
        },
        body: json.encode({
          "otp": otp,
          "txnId": _txId,
        }),
      );
      print('Response of aadhaarverify otp is:${response.body}');
    }
  }

  Future generateMobileOTP(String mobile) async {
    if (_txId != '') {
      var uri = Uri.parse(
          '${_baseURI}/${_basePath}/v1/registration/aadhaar/generateMobileOTP');
      final response = await http.post(
        uri,
        headers: {
          "accept": "*/*",
          "Accept-Language": "en-US",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_sessionToken}"
        },
        body: json.encode({
          "mobile": mobile,
          "txnId": _txId,
        }),
      );
      print('Response of generateMobileotp is:${response.body}');
    }
  }
}

final ABHANotifierProvider =
    StateNotifierProvider<ABHAProvider, AsyncValue<int>>(
  (ref) => ABHAProvider(),
);
