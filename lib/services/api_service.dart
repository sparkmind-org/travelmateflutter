import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/travel_request.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.101:3000';

  Future<List<TravelRequest>> getTravelRequests() async {
    final response = await http.get(Uri.parse('$baseUrl/travel-requests'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => TravelRequest.fromJson(json)).toList();
    }
    throw Exception('Failed to load travel requests');
  }

  Future<TravelRequest> createTravelRequest(TravelRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/travel-requests'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );
    if (response.statusCode == 201) {
      return TravelRequest.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create travel request');
  }
}