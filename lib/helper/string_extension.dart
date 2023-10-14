extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
  String addSpacesToFirstParagraph() {
    List<String> paragraphs = split('\n');

    for (int i = 0; i < paragraphs.length; i++) {
      if (paragraphs[i].isNotEmpty) {
        List<String> words = paragraphs[i].split(' ');

        if (words.isNotEmpty) {

          words[0] = '\u00A0\u00A0${words[0]}';
          paragraphs[i] = words.join(' ');
        }
      }
    }

    return paragraphs.join('\n\n');
  }
}
