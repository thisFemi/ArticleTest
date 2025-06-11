import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/article_controller.dart';
import '../widgets/article_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleController>().fetchArticles();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('📰 Article Reader'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Container(
                height: 1,
                color: Color(0xFFE0E0E0),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white,
                    child: CustomSearchBar(),
                  ),
                  Expanded(
                    child: Consumer<ArticleController>(
                      builder: (context, controller, child) {
                        if (controller.isLoading) {
                          return CustomLoadingIndicator();
                        }

                        if (controller.error != null) {
                          return CustomErrorWidget(
                            error: controller.error!,
                            onRetry: () => controller.fetchArticles(),
                          );
                        }

                        if (controller.articles.isEmpty) {
                          return _buildEmptyState();
                        }

                        return RefreshIndicator(
                          onRefresh: () => controller.fetchArticles(),
                          child: ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: controller.articles.length,
                            itemBuilder: (context, index) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                margin: EdgeInsets.only(bottom: 12),
                                child: ArticleCard(
                                  article: controller.articles[index],
                                  index: index,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Color(0xFFBDBDBD),
          ),
          SizedBox(height: 16),
          Text(
            'No articles found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF757575),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}
