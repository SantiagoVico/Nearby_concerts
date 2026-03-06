import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/concert.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'widgets/concert_card.dart';

void main() async {
  // Wait for flutter to be ready and load environment variables
  WidgetsFlutterBinding.ensureInitialized();
  // Load the .env file to access the API key
  await dotenv.load();
  // Now we can run the app
  runApp(const MaterialApp(home: ConcertListScreen()));
}

class ConcertListScreen extends StatefulWidget {
  const ConcertListScreen({super.key});

  @override
  State<ConcertListScreen> createState() => _ConcertListScreenState();
}

class _ConcertListScreenState extends State<ConcertListScreen> {
  late Future<List<Concert>> _concertsFuture;
  double _radius = 50;

  @override
  void initState() {
    super.initState();
    _concertsFuture = ApiService.fetchConcerts(radius: _radius.toInt());
  }

  void _refreshConcerts() {
    setState(() {
      _concertsFuture = ApiService.fetchConcerts(radius: _radius.toInt());
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        double tempRadius = _radius; 
        
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Filtres de recherche",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Distance maximum : ${tempRadius.toInt()} km",
                    style: const TextStyle(fontSize: 16, color: Colors.indigo),
                  ),
                  Slider(
                    value: tempRadius,
                    min: 10,
                    max: 200,
                    divisions: 19,
                    activeColor: Colors.indigo,
                    onChanged: (value) {
                      setModalState(() {
                        tempRadius = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        _radius = tempRadius;
                        Navigator.pop(context);
                        _refreshConcerts();
                      },
                      child: const Text("Appliquer et rechercher", style: TextStyle(fontSize: 16)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Concerts"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Concert>>(
        future: _concertsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else {
            final concerts = snapshot.data ?? [];
            if (concerts.isEmpty) {
              return const Center(child: Text("Aucun concert trouvé dans ce rayon."));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 80),
              itemCount: concerts.length,
              itemBuilder: (context, index) => ConcertCard(concert: concerts[index]),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showFilterModal,
        icon: const Icon(Icons.tune),
        label: const Text("Filtres"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }
}