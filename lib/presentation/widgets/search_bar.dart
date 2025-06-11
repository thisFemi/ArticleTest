import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/article_controller.dart';

class CustomSearchBar extends StatefulWidget {
  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        context.read<ArticleController>().searchArticles(value);
      },
      decoration: InputDecoration(
        hintText: 'Search articles...',
        hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
        prefixIcon: Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  context.read<ArticleController>().searchArticles('');
                },
              )
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
