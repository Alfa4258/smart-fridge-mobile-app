class Ingredient {
  final int id;
  final int count;
  final int frequency;
  final int isFresh;
  final String imageUrl;
  final String entryTime;
  final String lastUpdated;
  final String namaItem;
  final String status;

  const Ingredient({
    required this.id,
    required this.count,
    required this.frequency,
    required this.isFresh,
    required this.imageUrl,
    required this.entryTime,
    required this.lastUpdated,
    required this.namaItem,
    required this.status,
  });

  factory Ingredient.fromMap(Map<dynamic, dynamic> map) {
    int parseInt(dynamic value) {
      if (value is int) {
        return value;
      }
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    String parseString(dynamic value) {
      return value?.toString() ?? '';
    }

    return Ingredient(
      id: parseInt(map['id']),
      count: parseInt(map['count']),
      frequency: parseInt(map['frequency']),
      isFresh: parseInt(map['is_fresh']),
      imageUrl: parseString(map['image_url']),
      entryTime: parseString(map['entry_time']),
      lastUpdated: parseString(map['last_updated']),
      namaItem: parseString(map['nama_item']),
      status: parseString(map['status']),
    );
  }
}
