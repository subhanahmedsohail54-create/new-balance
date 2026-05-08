class Shoe {
  int? id;
  String title;
  String description;

  Shoe({
    this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory Shoe.fromMap(Map<String, dynamic> map) {
    return Shoe(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }
}