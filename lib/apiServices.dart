import 'dart:convert';
import 'package:http/http.dart' as http;


const String baseApiUrl = 'https://reqres.in/api';


class ApiService {
  // Signup function
  Future<Map<String, dynamic>> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseApiUrl/register'),
      body: {
        'email': email,
        'password': password,
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return {'status': true, 'message': 'Signup successful'};
    } else {
      final data = json.decode(response.body);
      return {'status': false, 'error': data['error']};
    }
  }

  // Login function
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseApiUrl/login');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return {'status': true, 'message': 'Login Successful'};
    } else {
      final responseBody = json.decode(response.body);
      return {'status': false, 'message': responseBody['error'] ?? 'Login Failed'};
    }
  }

  // Fetch Users function
  Future<List<dynamic>> fetchUsers() async {
    final url = Uri.parse('$baseApiUrl/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['data'];
    } else {
      throw Exception('Failed to load users');
    }
  }
}
