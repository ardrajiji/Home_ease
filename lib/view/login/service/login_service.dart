import 'dart:convert';
import 'dart:io';
import 'package:home_ease/constants/ursls.dart';
import 'package:home_ease/view/login/model/login_model.dart';
import 'package:http/http.dart' as http;



Future<UserLoginModel> userLoginService({
  required String email,
  required String password,
}) async {
  try {
    Map<String, dynamic> param = {
      "email": email,
      "password": password,
    };

    final resp = await http.post(
      Uri.parse(UserUrl.user_login), 
      body: jsonEncode(param),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );

    if (resp.statusCode == 200) {
      
      final dynamic decoded = jsonDecode(resp.body);
      final response = UserLoginModel.fromJson(decoded);
          
      return response;
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(resp.body);
      throw Exception(
        'Failed to login: ${errorResponse['message'] ?? 'Unknown error'}',
      );
    }
  } on SocketException {
    throw Exception('No Internet connection');
  } on HttpException {
    throw Exception('Server error');
  } on FormatException {
    throw Exception('Bad response format');
  } catch (e) {
    throw Exception('Unexpected error: ${e.toString()}');
  }
}