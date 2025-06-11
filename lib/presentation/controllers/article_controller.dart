import 'package:flutter/material.dart';
import '../../services/snackbar_service.dart';
import '../models/article.dart';

import '../../services/api_service.dart';

class ArticleController extends ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  List<Comment> _comments = [];
  bool _isLoading = false;
  bool _isLoadingComments = false;
  String? _error;
  String _searchQuery = '';

  List<Article> get articles => _filteredArticles;
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  bool get isLoadingComments => _isLoadingComments;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  Future<void> fetchArticles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _articles = await ApiService.fetchArticles();
      _filteredArticles = List.from(_articles);
      _applySearch();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchComments(int postId, BuildContext context) async {
    _isLoadingComments = true;
    notifyListeners();

    try {
      _comments = await ApiService.fetchComments(postId);
    } catch (e) {
      SnackBarService.showErrorSnackBar(
        context: context,
        message: e.toString(),
      );
    }

    _isLoadingComments = false;
    notifyListeners();
  }

  void searchArticles(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredArticles = List.from(_articles);
    } else {
      _filteredArticles = _articles
          .where((article) =>
              article.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
