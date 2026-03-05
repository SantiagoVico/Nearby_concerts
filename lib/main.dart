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
  double _radius = 50; // 👈 Distance par défaut

  @override
  void initState() {
    super.initState();
    _concertsFuture = ApiService.fetchConcerts(radius: _radius.toInt());
  }

  // Fonction pour recharger les données
  void _refreshConcerts() {
    setState(() {
      _concertsFuture = ApiService.fetchConcerts(radius: _radius.toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes Concerts")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text("Rayon : ${_radius.toInt()} km", style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Slider(
                    value: _radius,
                    min: 10,
                    max: 200,
                    divisions: 19, // Un cran tous les 10km
                    label: "${_radius.toInt()} km",
                    onChanged: (value) {
                      setState(() {
                        _radius = value; // Met à jour le texte en direct
                      });
                    },
                    onChangeEnd: (value) {
                      _refreshConcerts(); // Appelle l'API quand on lâche le doigt
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // La liste prend le reste de l'espace
          Expanded(
            child: FutureBuilder<List<Concert>>(
              future: _concertsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                } else {
                  final concerts = snapshot.data ?? [];
                  if (concerts.isEmpty) return const Center(child: Text("Aucun concert trouvé."));
                  return ListView.builder(
                    itemCount: concerts.length,
                    itemBuilder: (context, index) => ConcertCard(concert: concerts[index]),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshConcerts,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}