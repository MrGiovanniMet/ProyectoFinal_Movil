class BookModel {
  final int? localId;
  final int userId;
  final String title;
  final String author;
  final String status;
  final String? imagePath;
  final String? genre;
  final int? pages;
  final int? year;
  final String? synopsis;

  BookModel({
    this.localId,
    required this.userId,
    required this.title,
    required this.author,
    required this.status,
    this.imagePath,
    this.genre,
    this.pages,
    this.year,
    this.synopsis,
  });

  Map<String, dynamic> toMap() {
    return {
      'localId': localId,
      'userId': userId,
      'title': title,
      'author': author,
      'status': status,
      'imagePath': imagePath,
      'genre': genre,
      'pages': pages,
      'year': year,
      'synopsis': synopsis,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      localId: map['localId'],
      userId: map['userId'],
      title: map['title'],
      author: map['author'],
      status: map['status'],
      imagePath: map['imagePath'],
      genre: map['genre'],
      pages: map['pages'],
      year: map['year'],
      synopsis: map['synopsis'],
    );
  }
}