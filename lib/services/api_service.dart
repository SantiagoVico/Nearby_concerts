import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/concert.dart';

class ApiService {
  static const String apiKey = "27RhCTumG0Q7M2xYGhUxDuhG5lvFo9BP";

  static Future<List<Concert>> fetchConcerts({int radius = 50}) async {
    // 1. Récupération de ta position GPS
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 2. On demande TOUJOURS très large à l'API (200km) et 100 résultats max
    final String url = "https://app.ticketmaster.com/discovery/v2/events.json"
        "?apikey=$apiKey"
        "&latlong=${position.latitude},${position.longitude}"
        "&radius=200"
        "&unit=km"
        "&locale=fr"
        "&size=100"
        "&classificationName=music";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List events = data['_embedded']?['events'] ?? [];
      
      List<Concert> concertsFiltres = [];
      
      for (var eventJson in events) {
        try {
          Concert c = Concert.fromJson(eventJson);
          
          if (c.latitude != null && c.longitude != null) {
            // Geolocator calcule la distance exacte à vol d'oiseau entre la position de l'utilisateur et celle du concert (en mètres)
            double distanceInMeters = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              c.latitude!,
              c.longitude!,
            );
            
            // On convertit en kilomètres
            double distanceInKm = distanceInMeters / 1000;

            // Si le concert est dans le rayon du Slider, on le garde !
            if (distanceInKm <= radius) {
              concertsFiltres.add(c);
            }
          } else {
            // Si Ticketmaster a oublié de mettre les coordonnées GPS de la salle,
            // on le garde uniquement si l'utilisateur cherche très large (>50km)
            if (radius >= 50) {
               concertsFiltres.add(c);
            }
          }
        } catch (e) {
          //print("❌ Erreur sur un concert ignorée");
        }
      }
      
      return concertsFiltres;
    } else {
      throw Exception("Erreur API : code ${response.statusCode}");
    }
  }
}