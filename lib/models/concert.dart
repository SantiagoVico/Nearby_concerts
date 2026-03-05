class Concert {
  final String name;
  final String date;
  final String venue;
  final String imageUrl;
  final String ticketUrl;

  Concert({required this.name, required this.date, required this.venue, required this.imageUrl, required this.ticketUrl});

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      name: json['name'] ?? 'Concert sans nom',
      date: json['dates']?['start']?['localDate'] ?? 'Date inconnue',
      venue: (json['_embedded']?['venues'] != null && json['_embedded']['venues'].isNotEmpty)
          ? json['_embedded']['venues'][0]['name']
          : 'Lieu inconnu',
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url']
          : 'https://via.placeholder.com/150',
      ticketUrl: json['url'] ?? '', // 👈 NOUVEAU
    );
  }
}