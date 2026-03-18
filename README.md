# Posts Manager - Flutter Lab 4 Assignment

A simple mobile application built with Flutter that allows staff to view, create, edit, and delete posts using the JSONPlaceholder API.

## Features

- ✅ View all available posts
- ✅ Read the details of a post
- ✅ Create a new post
- ✅ Edit an existing post
- ✅ Delete a post

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   └── post.dart                 # Post data model
├── services/
│   └── post_api_service.dart     # API service with error handling
└── screens/
    ├── posts_list_screen.dart    # List all posts (FutureBuilder)
    ├── post_detail_screen.dart   # View post details
    ├── create_post_screen.dart   # Create new post
    └── edit_post_screen.dart     # Edit existing post
```

## Dependencies Used

### 1. **http: ^1.1.0**
   - **Why:** Used for making HTTP requests to the JSONPlaceholder API
   - **Usage:** GET, POST, PUT, DELETE operations
   - **Advantage:** Official, well-maintained, and simple to use for REST API calls

### 2. **provider: ^6.0.0** (Optional for state management)
   - **Why:** For managing application state efficiently
   - **Usage:** Could be used for managing loading states and API responses
   - **Advantage:** Lightweight, reactive, and recommended by Flutter team

### 3. **flutter (SDK)**
   - **Why:** Core framework for building the UI
   - **Usage:** Material Design widgets, navigation, state management

## API Error Handling

The app implements comprehensive error handling in `post_api_service.dart`:

### Error Types Handled:

1. **Network Errors:**
   - Connection timeouts (10-second timeout limit)
   - No internet connectivity
   - DNS resolution failures

2. **HTTP Errors:**
   - Status code 4xx (Client errors)
   - Status code 5xx (Server errors)
   - Malformed responses

3. **Data Parsing Errors:**
   - Invalid JSON format
   - Missing required fields (handled with null coalescing)
   - Type mismatches

### Error Handling Implementation:

```dart
// Custom exception class
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException(this.message, {this.statusCode});
}

// Wrapped in try-catch blocks
try {
  // API call
} on ApiException {
  rethrow;  // Re-throw custom exceptions
} catch (e) {
  throw ApiException('Network error: ${e.toString()}');
}

// Timeout handling
.timeout(
  const Duration(seconds: 10),
  onTimeout: () => throw ApiException('Request timeout...')
)
```

### UI Error Handling:
- Loading spinner while fetching data
- Error widgets with retry button
- SnackBar notifications for create/edit/delete operations
- Graceful fallback for empty states

## FutureBuilder Widget Explanation

### What is FutureBuilder?

FutureBuilder is a Flutter widget that builds stuff based on the latest snapshot of interaction with a Future.

### Implementation in PostsListScreen:

```dart
FutureBuilder<List<Post>>(
  future: _postsFuture,
  builder: (context, snapshot) {
    // The builder is called multiple times as the Future progresses
  },
)
```

### Connection States Handled:

1. **ConnectionState.waiting:**
   - Displays `CircularProgressIndicator` while data is loading
   - User sees loading spinner during API call

2. **snapshot.hasError:**
   - Displays error message with retry button
   - Shows the actual error message from ApiException
   - User can tap "Retry" to refresh posts

3. **snapshot.hasData:**
   - Displays ListView with all posts
   - Each post is a ListTile with title, subtitle, and menu options
   - Tapping opens post details

4. **Empty Data:**
   - Shows empty state message if no posts exist

### UI Parts Depending on Future:

```dart
// 1. AppBar - Always visible
AppBar(title: const Text('Posts Manager'))

// 2. Body - DEPENDS ON FUTURE
body: FutureBuilder<List<Post>>(
  future: _postsFuture,
  builder: (context, snapshot) {
    // This entire section depends on the Future
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator(); // Loading UI
    }
    if (snapshot.hasError) {
      return ErrorWidget(); // Error UI
    }
    return ListView(...); // Data UI
  },
)

// 3. FloatingActionButton - Always visible
floatingActionButton: FloatingActionButton(...)
```

### Key Features:
- **Reactive UI:** Updates automatically when Future completes
- **State Management:** Manages async operations without callbacks
- **Error Handling:** Built-in snapshot error checking
- **Performance:** Only rebuilds the dependent parts
- **Null Safety:** snapshot.hasData and snapshot.hasError prevent null errors

## Building and Running

### Prerequisites:
- Flutter SDK installed
- Android SDK or iOS SDK configured
- An emulator or physical device

### Steps:

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Build release APK
flutter build apk --release
```

## API Endpoints Used

- **GET /posts** - Fetch all posts
- **GET /posts/{id}** - Fetch single post
- **POST /posts** - Create new post
- **PUT /posts/{id}** - Update post
- **DELETE /posts/{id}** - Delete post

Base URL: https://jsonplaceholder.typicode.com

## Testing the API Responses

All endpoints return JSON with the following structure:
```json
{
  "userId": 1,
  "id": 1,
  "title": "Post Title",
  "body": "Post Content..."
}
```


