import 'traveler.dart';

class TravelRequest {
  final String id;
  final String travelSpec;
  final String name;
  final String source;
  final String destination;
  final String? airline;
  final String? flightNumber;
  final String flightType;
  final String? connectingCity;
  final String date;
  final String time;
  final List<Traveler> travelers;

  TravelRequest({
    required this.id,
    required this.travelSpec,
    required this.name,
    required this.source,
    required this.destination,
    this.airline,
    this.flightNumber,
    required this.flightType,
    this.connectingCity,
    required this.date,
    required this.time,
    required this.travelers,
  });

  factory TravelRequest.fromJson(Map<String, dynamic> json) {
    return TravelRequest(
      id: json['id'],
      travelSpec: json['travelSpec'],
      name: json['name'],
      source: json['source'],
      destination: json['destination'],
      airline: json['airline'],
      flightNumber: json['flightNumber'],
      flightType: json['flightType'],
      connectingCity: json['connectingCity'],
      date: json['date'],
      time: json['time'],
      travelers: (json['travelers'] as List)
          .map((t) => Traveler.fromJson(t))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'travelSpec': travelSpec,
    'name': name,
    'source': source,
    'destination': destination,
    'airline': airline,
    'flightNumber': flightNumber,
    'flightType': flightType,
    'connectingCity': connectingCity,
    'date': date,
    'time': time,
    'travelers': travelers.map((t) => t.toJson()).toList(),
  };
}