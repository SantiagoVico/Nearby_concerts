import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/concert.dart';

class ApiService {
  static const String apiKey = "27RhCTumG0Q7M2xYGhUxDuhG5lvFo9BP";

  static Future<List<Concert>> fetchConcerts() async {
    // 1. Récupération GPS
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );


    // On ajoute un paramètre &locale=fr pour aider l'API
    final String url = "https://app.ticketmaster.com/discovery/v2/events.json"
        "?apikey=$apiKey"
        "&latlong=${position.latitude},${position.longitude}"
        "&radius=50&unit=km"
        "&locale=fr"
        "&classificationName=music";


    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List events = data['_embedded']?['events'] ?? [];
      
      List<Concert> concerts = [];
      
      for (var eventJson in events) {
        try {
          concerts.add(Concert.fromJson(eventJson));
        } catch (e) {
          // Si un concert pose problème, on l'ignore et on continue
          // print("Erreur lors de la conversion d'un concert : $e");
        }
      }
      return concerts;
    } else {
      throw Exception("Erreur API : code ${response.statusCode}");
    }
  }
}