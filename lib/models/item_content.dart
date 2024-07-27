class Content {
  final String title;
  final String text;
  final String? path;

  Content({this.title = "", this.text = "", this.path});

  @override
  String toString() {
    return "Content(title: $title, text: $text, path: $path)";
  }
}
