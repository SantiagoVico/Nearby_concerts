import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/concert.dart';

class ConcertDetailScreen extends StatelessWidget {
  final Concert concert;

  const ConcertDetailScreen({super.key, required this.concert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(concert.name)),
      body: SingleChildScrollView(
        // Permet de scroller si l'écran est petit
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // L'image en grand
            Image.network(concert.imageUrl, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concert.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(concert.date, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(concert.venue, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Le bouton d'achat
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // 1. On vérifie si le lien existe
                        if (concert.ticketUrl.isNotEmpty) {
                          final Uri url = Uri.parse(concert.ticketUrl);

                          // 2. On vérifie si le téléphone peut ouvrir ce lien
                          if (await canLaunchUrl(url)) {
                            // 3. On ouvre le navigateur externe du téléphone
                            await launchUrl(
                              url,
                              mode: LaunchMode
                                  .externalApplication, // Ouvre Chrome/Safari et non l'app elle-même
                            );
                          } else {
                            // Message d'erreur si le téléphone n'y arrive pas
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Impossible d'ouvrir le lien du billet.",
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          // Message si Ticketmaster n'a pas fourni de lien
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Aucun lien de billetterie disponible pour ce concert.",
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.local_activity),
                      label: const Text("Acheter des billets"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                    ),
                  
                  ),
                  const SizedBox(height: 15),
                  // NOUVEAU BOUTON : Voir sur la carte
                  if (concert.latitude != null && concert.longitude != null)
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          // Crée un lien universel Google Maps avec les coordonnées
                          final Uri mapUrl = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=${concert.latitude},${concert.longitude}'
                          );
                          
                          if (await canLaunchUrl(mapUrl)) {
                            await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
                          }
                        },
                        icon: const Icon(Icons.map, color: Colors.indigo),
                        label: const Text("Voir sur la carte", style: TextStyle(color: Colors.indigo)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
