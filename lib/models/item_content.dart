class Content {
  final String title;
  final String text;

  Content({this.title = "", this.text = ""});

  @override
  String toString() {
    return "Content(title: $title, text: $text)";
  }
}
