# 📰 Flutter Article Reader

A mobile app that displays articles from JSONPlaceholder API with search and detail views.

## 🚀 Setup & Run

### Prerequisites
- Flutter SDK 3.0+
- Android Studio/VS Code with Flutter plugins

### Installation
```bash
flutter pub get
flutter run
```

## 📚 Libraries Used

- **provider**: ^6.0.5 - State management (lightweight, Flutter-native)
- **http**: ^0.13.5 - API requests (official Dart package)

## 🏗️ Architecture

### MVC Pattern
```
├── models/      # Data classes (Article, Comment)
├── controllers/ # Business logic (ArticleController)
├── services/    # API calls (ApiService)
├── screens/     # UI screens (Home, Detail)
└── widgets/     # Reusable components
```

### Key Decisions

**Provider State Management**
- Simple setup for small-medium apps
- Reactive UI updates with ChangeNotifier
- Less boilerplate than BLoC/Redux

**MVC Architecture**
- Clear separation of concerns
- Easy to test and maintain
- Scalable for future features

**Single Controller**
- Manages all article operations
- Handles search, loading, errors
- Can be split as app grows

## 🎯 Features

### Core ✅
- Article list with title/snippet
- Article detail with comments
- Loading and error states
- Clean MVC structure

### Bonus ✅
- Search by title
- Pull-to-refresh
- Smooth animations
- Modern Material Design

## 📱 Project Structure

```
lib/
├── main.dart
├── models/
│   ├── article.dart
│   └── comment.dart
├── controllers/
│   └── article_controller.dart
├── services/
│   └── api_service.dart
├── screens/
│   ├── home_screen.dart
│   └── detail_screen.dart
└── widgets/
    ├── article_card.dart
    ├── comment_card.dart
    └── search_bar.dart
```

## 🔗 API Endpoints

- Articles: `https://jsonplaceholder.typicode.com/posts`
- Comments: `https://jsonplaceholder.typicode.com/comments?postId={id}`