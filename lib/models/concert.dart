class Concert {
  final String name;
  final String date;
  final String venue;
  final String imageUrl;
  final String ticketUrl;
  final double? latitude;
  final double? longitude;

  Concert({
    required this.name,
    required this.date,
    required this.venue,
    required this.imageUrl,
    required this.ticketUrl,
    this.latitude,
    this.longitude,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    // On extrait les coordonnées si elles existent
    double? lat;
    double? lng;
    if (json['_embedded']?['venues'] != null && json['_embedded']['venues'].isNotEmpty) {
      final venue = json['_embedded']['venues'][0];
      if (venue['location'] != null) {
        lat = double.tryParse(venue['location']['latitude'] ?? '');
        lng = double.tryParse(venue['location']['longitude'] ?? '');
      }
    }

    return Concert(
      name: json['name'] ?? 'Concert sans nom',
      date: json['dates']?['start']?['localDate'] ?? 'Date inconnue',
      venue: json['_embedded']?['venues']?[0]?['name'] ?? 'Lieu inconnu',
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url']
          : 'https://via.placeholder.com/150',
      ticketUrl: json['url'] ?? '',
      latitude: lat,
      longitude: lng,
    );
  }
}