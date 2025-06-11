import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/article_controller.dart';
import '../models/article.dart';
import '../widgets/comment_card.dart';

class DetailScreen extends StatefulWidget {
  final Article article;

  const DetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ArticleController>()
          .fetchComments(widget.article.id, context);
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1A1A1A),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Article Details',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Container(
                height: 1,
                color: Color(0xFFE0E0E0),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildArticleContent(),
                    _buildCommentsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ID: ${widget.article.id}',
                  style: TextStyle(
                    color: Color(0xFF2196F3),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(),
              Icon(
                Icons.person_outline,
                size: 16,
                color: Color(0xFF757575),
              ),
              SizedBox(width: 4),
              Text(
                'User ${widget.article.userId}',
                style: TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            widget.article.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              height: 1.3,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 1,
            color: Color(0xFFE0E0E0),
          ),
          SizedBox(height: 16),
          Text(
            widget.article.body,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF424242),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Consumer<ArticleController>(
      builder: (context, controller, child) {
        return Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '💬 Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  if (controller.isLoadingComments) ...[
                    SizedBox(width: 12),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2196F3),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12),
              if (controller.comments.isEmpty && !controller.isLoadingComments)
                _buildNoComments()
              else
                ...controller.comments
                    .map((comment) => CommentCard(comment: comment))
                    .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoComments() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: Color(0xFFBDBDBD),
            size: 24,
          ),
          SizedBox(width: 12),
          Text(
            'No comments yet',
            style: TextStyle(
              color: Color(0xFF757575),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
