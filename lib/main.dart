import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/concert.dart';
import 'widgets/concert_card.dart';

void main() => runApp(const MaterialApp(home: ConcertListScreen()));

class ConcertListScreen extends StatefulWidget {
  const ConcertListScreen({super.key});

  @override
  State<ConcertListScreen> createState() => _ConcertListScreenState();
}

class _ConcertListScreenState extends State<ConcertListScreen> {
  late Future<List<Concert>> _concertsFuture;

  @override
  void initState() {
    super.initState();
    // On lance la recherche au démarrage
    _concertsFuture = ApiService.fetchConcerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Concerts près de chez vous")),
      body: FutureBuilder<List<Concert>>(
        future: _concertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else {
            final concerts = snapshot.data ?? [];
            return ListView.builder(
              itemCount: concerts.length,
              itemBuilder: (context, index) => ConcertCard(concert: concerts[index]),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() { _concertsFuture = ApiService.fetchConcerts(); }),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}