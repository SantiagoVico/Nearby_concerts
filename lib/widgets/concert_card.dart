import 'package:flutter/material.dart';
import '../models/concert.dart';
import '../screens/concert_detail.dart';

class ConcertCard extends StatelessWidget {
  final Concert concert;
  const ConcertCard({super.key, required this.concert});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConcertDetailScreen(concert: concert),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              concert.imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concert.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.indigo),
                      const SizedBox(width: 6),
                      Text(concert.date, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      
                      const SizedBox(width: 16),
                      
                      const Icon(Icons.location_on, size: 16, color: Colors.indigo),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          concert.venue,
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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