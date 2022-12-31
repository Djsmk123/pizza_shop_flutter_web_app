import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class Networking {
  static const String baseUrl = 'http://localhost:8080  ';
  static Future getRequest({
    required String endpoint,
    required Map<String, String> queryParams,
  }) async {
    try {
      var headers = {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Access-Control-Allow-Origin": "*",
      };
      var uri = Uri.parse(baseUrl + endpoint);
      if (queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      var response = await http.get(uri, headers: headers);

      switch (response.statusCode) {
        case 200:
          {
            var responseData = jsonDecode(response.body);
            return responseData['data'];
          }
        case 201:
          {
            var responseData = jsonDecode(response.body);
            return responseData['message'];
          }
        case 400:
          {
            var responseData = jsonDecode(response.body);
            throw responseData['message'];
          }
        case 404:
          {
            var responseData = jsonDecode(response.body);
            throw responseData['message'];
          }
        default:
          {
            throw 'Something went wrong';
          }
      }
    } catch (e) {
      log(e.toString());
      throw "Something went wrong";
    }
  }

  static Future post(
      {required String endpoint, required Map<String, dynamic> body}) async {
    try {
      var headers = {
        HttpHeaders.contentTypeHeader: "application/json",
      };
      var uri = Uri.parse(baseUrl + endpoint);

      var response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      switch (response.statusCode) {
        case 200:
          {
            var responseData = jsonDecode(response.body);
            return responseData['data'];
          }
        case 201:
          {
            var responseData = jsonDecode(response.body);
            return responseData['message'];
          }
        case 400:
          {
            var responseData = jsonDecode(response.body);
            throw responseData['message'];
          }
        case 404:
          {
            var responseData = jsonDecode(response.body);
            throw responseData['message'];
          }
        default:
          {
            throw 'Something went wrong';
          }
      }
    } catch (e) {
      log(e.toString());
      throw "Something went wrong";
    }
  }
}
