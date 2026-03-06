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
        // Scrollable for smaller screens
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Big image at the top
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
                  // Buy Tickets Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // Check for existence of ticket URL
                        if (concert.ticketUrl.isNotEmpty) {
                          final Uri url = Uri.parse(concert.ticketUrl);

                          // Check if the device can open the URL (safety check)
                          if (await canLaunchUrl(url)) {
                            // Open the URL in the default browser (not in-app)
                            await launchUrl(
                              url,
                              mode: LaunchMode
                                  .externalApplication,
                            );
                          } else {
                            // Error handling if the URL cannot be opened
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
                          // Inform the user if no ticket URL is available
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
