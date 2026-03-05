import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../screens/concert_detail.dart'; // 👈 N'oublie pas l'import !

class ConcertCard extends StatelessWidget {
  final Concert concert;
  const ConcertCard({super.key, required this.concert});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(concert.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(concert.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${concert.date} • ${concert.venue}"),
        trailing: const Icon(Icons.music_note, color: Colors.indigo),
        // 👈 LA MAGIE DU CLIC EST ICI :
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConcertDetailScreen(concert: concert),
            ),
          );
        },
      ),
    );
  }
}