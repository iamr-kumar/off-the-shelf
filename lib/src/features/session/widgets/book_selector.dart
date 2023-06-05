import 'package:flutter/material.dart';
import 'package:off_the_shelf/src/models/book.model.dart';

class BookSelector extends StatefulWidget {
  final List<Book> currentlyReading;
  final Function(Book) onBookChange;

  const BookSelector(
      {super.key, required this.currentlyReading, required this.onBookChange});

  @override
  State<BookSelector> createState() => _BookSelectorState();
}

class _BookSelectorState extends State<BookSelector> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.currentlyReading.first.id;
  }

  void updateSelected(dynamic value) {
    setState(() {
      selected = value as String;
    });
    final book =
        widget.currentlyReading.firstWhere((element) => element.id == selected);
    widget.onBookChange(book);
  }

  String getTrimmedBookTitle(String title) {
    if (title.length > 30) {
      return '${title.substring(0, 30)}...';
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selected,
      items: widget.currentlyReading.map((book) {
        return DropdownMenuItem(
          value: book.id,
          child: Text(getTrimmedBookTitle(book.title)),
        );
      }).toList(),
      onChanged: updateSelected,
    );
  }
}
