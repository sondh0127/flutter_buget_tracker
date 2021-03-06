class Item {
  final String name;
  final String category;
  final double price;
  final DateTime date;

  const Item({
    required this.name,
    required this.category,
    required this.price,
    required this.date,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    final dateStr = (properties['Date']?['date']?['start']) as String;
    return Item(
      name: (properties['Name']?['title']?[0]?['plain_text'] ?? '?') as String,
      category: (properties['Category']?['select']?['name'] ?? 'Any') as String,
      price: (properties['Price']?['number'] ?? 0).toDouble() as double,
      date: dateStr != null ? DateTime.parse(dateStr) : DateTime.now(),
    );
  }

  static bool isEmpty(Map<String, dynamic> map) {
    final properties = map['properties'] as Map<String, dynamic>;
    return properties['Name']?['title'].length == 0;
  }
}
