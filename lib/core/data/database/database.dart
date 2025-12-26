// Placeholder database classes for compilation
enum ReadingStatus {
  wishlist,
  toRead,
  reading,
  read,
}

class WorkWithLibraryStatus {
  final String id;
  final String title;
  final String? author;
  final ReadingStatus? status;
  final String? coverImageURL;

  const WorkWithLibraryStatus({
    required this.id,
    required this.title,
    this.author,
    this.status,
    this.coverImageURL,
  });
}
