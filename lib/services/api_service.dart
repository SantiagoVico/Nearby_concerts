import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geohash_plus/geohash_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/concert.dart';

class ApiService {

  static Future<List<Concert>> fetchConcerts({int radius = 50}) async {
    // Load api key from .env file
    final String apiKey = dotenv.env['TICKETMASTER_API_KEY'] ?? '';

    // Check if API key is present
    if (apiKey.isEmpty) {
      throw Exception("API key is missing. Please set TICKETMASTER_API_KEY in your .env file.");
    }

    // Get user's current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Convert lat/lng to geohash
    String myGeohash = GeoHash.encode(position.latitude, position.longitude).hash;

    // Build the API URL with parameters    
    final String url = "https://app.ticketmaster.com/discovery/v2/events.json"
        "?apikey=$apiKey"
        "&geoPoint=$myGeohash"
        "&radius=$radius"
        "&unit=km"
        "&locale=fr"
        "&classificationName=music";

    // Make the HTTP GET request
    final response = await http.get(Uri.parse(url));
    
    // Check the response status and parse the data
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List events = data['_embedded']?['events'] ?? [];
      
      List<Concert> concerts = [];
      
      for (var eventJson in events) {
        try {
          concerts.add(Concert.fromJson(eventJson));
        } catch (e) {
          //print("Erreur sur un concert ignorée");
        }
      }
      
      return concerts;
    } else {
      throw Exception("Erreur API : code ${response.statusCode}");
    }
  }
}