import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Map<String, String>? defaultHeaders = {
    'Content-Type': 'application/json',
  };

  Future<http.Response> get(String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    BuildContext? context,
  }) async {
    Uri uri = Uri.parse(endpoint);
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }
    Map<String, String> combinedHeaders = {...?defaultHeaders, ...?headers};
    http.Response response = await http.get(uri, headers: combinedHeaders);

    // Optionally handle cookies here
    // updateCookie(response);

    return response; // Return the full response
  }

  Future<http.Response> post(
      String endpoint,
      dynamic data, {
        Map<String, String>? headers,
        BuildContext? context,
      }) async {
    try {
      Uri uri = Uri.parse(endpoint);
      Map<String, String> combinedHeaders = {
        'Content-Type': 'application/json', // Ensure a default content type
        ...?defaultHeaders,
        ...?headers,
      };

      // Log for debugging
      print('Making POST request to $uri');
      print('Headers: $combinedHeaders');
      print('Data: $data');

      http.Response response = await http.post(
        uri,
        body: json.encode(data),
        headers: combinedHeaders,
      );

      // Optionally handle cookies here
      // updateCookie(response);

      return response; // Return the full response
    } catch (e) {
      print('Error during POST request: $e');
      rethrow;
    }
  }


  // Future<Map<String, dynamic>> put(String endpoint,
  //     dynamic data, {
  //       Map<String, String>? headers,
  //       BuildContext? context,
  //     }) async {
  //   try {
  //     return await _tryRequest(() async {
  //       Map<String, String> combinedHeaders = {...?defaultHeaders, ...?headers};
  //       http.Response response = await http.put(
  //         Uri.parse(baseURL + endpoint),
  //         body: json.encode(data),
  //         headers: headers ?? combinedHeaders,
  //       );
  //       // updateCookie(response);
  //       return json.decode(response.body);
  //     }, context);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<Map<String, dynamic>> delete(String endpoint,
  //     {
  //       Map<String, String>? headers,
  //       BuildContext? context,
  //     }) async {
  //   try {
  //     return await _tryRequest(() async {
  //       Map<String, String> combinedHeaders = {...?defaultHeaders, ...?headers};
  //       http.Response response = await http.delete(
  //         Uri.parse(baseURL + endpoint),
  //
  //         headers: headers ?? combinedHeaders,
  //       );
  //       // updateCookie(response);
  //       return json.decode(response.body);
  //     }, context);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<Map<String, dynamic>> _tryRequest(
  //     Future<Map<String, dynamic>> Function() requestFunction,
  //     BuildContext? context,) async {
  //   Map<String, dynamic> responseJson;
  //   try {
  //     responseJson = await requestFunction();
  //   } catch (e) {
  //     if (e is http.ClientException) {
  //       throw e;
  //     }
  //     responseJson = {};
  //   }
  //
  //   if (responseJson['statusCode'] == 401) {
  //     // Redirect to login page
  //     if (context != null) {
  //       Navigator.pushReplacementNamed(context, '/login');
  //     }
  //   } else  {
  //
  //     bool tokenRefreshed = await refreshToken();
  //     if (tokenRefreshed) {
  //       responseJson = await requestFunction(); // Retry the original request
  //     } else {
  //       // Redirect to login page if token refresh failed
  //       if (context != null) {
  //         Navigator.pushReplacementNamed(context, '/login');
  //       }
  //     }
  //   }
  // }

}

class ApiConstants{
  static final String baseurl= "http://192.168.253.162:3001/api/";

  //authentication enpoints
  static final String register= "${baseurl}auth/register";
}