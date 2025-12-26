# Ka📄bar

**Flutter • Splash → Onboarding → Login → Home**

A modern Flutter application demonstrating a complete mobile authentication pipeline with Material Design 3. Built for university coursework showcasing API integration, state management, and professional UI/UX patterns.

---

## Table of Contents

* [🧾 Overview](#-overview)
* [📱 Features](#-features)
* [🧰 Core Components](#-core-components)
* [🚀 Getting Started](#-getting-started)
* [🔁 Navigation Flow](#-navigation-flow)
* [🔐 Authentication](#-authentication)
* [🧪 Test Accounts](#-test-accounts)
* [📦 Dependencies](#-dependencies)
* [🏗️ Project Structure](#️-project-structure)
* [🔌 API Integration](#-api-integration)
* [📝 Notes](#-notes)
* [🔗 Resources](#-resources)

---

## 🧾 Overview

**KaLbar** is a Flutter application that demonstrates a typical mobile entry pipeline and authentication layer. The user experience progresses from a splash screen into a short onboarding sequence, followed by credential-based login and a post-authenticated home view.

### Assignment Objectives

**Assignment 1:**
- ✅ Splash screen implementation with animations
- ✅ Onboarding screens (3 pages) with smooth transitions
- ✅ Login screen GUI with form validation

**Assignment 2:**
- ✅ Integration with [DummyJSON Auth API](https://dummyjson.com/docs/auth#auth-login)
- ✅ Dio package for HTTP requests
- ✅ Success & failure result handling with user feedback

The project includes:
* 💦 **Splash screen** with animated transitions
* 🧭 **Onboarding flow** with page indicators
* 🔐 **Login screen** with validation and error handling
* 🏠 **Home screen** displaying authenticated user data
* 🧩 **Authentication model** (`AuthUser`) and service (`AuthService`)

---

## 📱 Features

- **Animated Splash Screen** - Smooth entrance animation with fade and scale effects
- **Interactive Onboarding** - Three-page walkthrough with swipe gestures
- **Form Validation** - Real-time input validation with error messages
- **Loading States** - Visual feedback during authentication
- **Error Handling** - User-friendly error messages via SnackBar
- **Remember Me** - Checkbox option for persistent sessions
- **Social Login UI** - Facebook & Google button designs (UI-only)
- **Responsive Design** - Adapts to various screen sizes
- **Material Design 3** - Modern theming with custom color scheme
- **Token Management** - Access and refresh token handling

---

## 🧰 Core Components

### 💦 Splash Screen
Renders a brief entrance animation with fade, scale, and lift effects, then automatically routes to onboarding after 1.4 seconds.

**Features:**
- Animated logo with multiple synchronized animations
- Precaches onboarding images for smooth transitions
- Custom page route with fade transition

### 🧭 Onboarding Screen
Three swipeable pages implemented with `PageView`, featuring:
- Dynamic page indicators (dots)
- "Back" and "Next" navigation buttons
- Animated button that expands to "Get Started" on final page
- Smooth content animations on page change
- Rounded card design with shadow effects

### 🔐 Login Screen
Professional authentication interface with:
- ✅ Required field validation (non-empty username and password)
- ⏳ Loading state with circular progress indicator
- 🎯 Success/failure result handling
- 🔴 Error indication with red border and close button
- 👁️ Password visibility toggle
- ☑️ "Remember me" checkbox
- 🔗 "Forgot password" link (UI-only)
- 📱 Social login buttons (UI-only)

### 🏠 Home Screen
Displays authenticated user information:
- User avatar from API
- Full name display
- Username, email, and access token preview
- Logout functionality with smooth transition

---

## 🚀 Getting Started

### Prerequisites

- ✅ **Flutter SDK** (3.0.0 or higher)
- ✅ **Dart SDK** (3.0.0 or higher)
- 📱 Android emulator, iOS simulator, or physical device
- 🔧 Android Studio / VS Code with Flutter extensions

### Installation

1. **Extract the project**
   ```bash
   cd kalbar-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

> **Note:** All assets (splash screen, onboarding images) are included in the project. No additional setup required!

---

## 🔁 Navigation Flow

```
┌─────────────┐
│   Splash    │ (1.4s auto-transition)
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Onboarding  │ (3 pages, swipeable)
│   Page 1    │
│   Page 2    │
│   Page 3    │
└──────┬──────┘
       │ "Get Started"
       ▼
┌─────────────┐
│    Login    │ (credential input)
└──────┬──────┘
       │ Successful auth
       ▼
┌─────────────┐
│    Home     │ (user dashboard)
└──────┬──────┘
       │ "Logout"
       └──────> Back to Login
```

All transitions use custom `PageRouteBuilder` with fade animations for a polished user experience.

---

## 🔐 Authentication

### Implementation

- **Service:** `AuthService` (in-memory test accounts + DummyJSON API ready)
- **Model:** `AuthUser` (contains id, username, email, name, tokens)
- **State Management:** StatefulWidget with loading and error states

### Contract

```dart
Future<AuthUser> AuthService.login({
required String username,
required String password,
})
```

**Inputs:**
- `username`: String (trimmed, non-empty)
- `password`: String (non-empty)

**Output:**
- Returns `AuthUser` instance on success
- Throws `AuthException` with error message on failure

### Result Handling

#### ✅ Success Path
1. 🧩 Returns populated `AuthUser` instance
2. 🔁 Replaces login route with `HomeScreen(user: user)`
3. 💾 Displays user information on home screen

#### ❌ Failure Path
1. 🧯 Sets error state on username field (red border)
2. 💬 Displays SnackBar with error message
3. 🔴 Shows close button to clear error state
4. 🎯 Maintains form state for user correction

---

## 🧪 Test Accounts

Use one of the following accounts to validate the success path:

| Account | Username | Password |
|---------|----------|----------|
| 1       | `amir`   | `123`    |
| 2       | `test2`  | `456`    |
| 3       | `miro`   | `789`    |

**To validate the failure path:**
- Submit an incorrect username and/or password
- Observe error message: "Invalid username or password"
- Note the red border on username field and SnackBar notification

---

## 📦 Dependencies

### Core Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0  # Poppins typography
  dio: ^5.4.0           # HTTP client for API integration

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

### Asset Configuration

```yaml
flutter:
  assets:
    - assets/images/
```

**Included Assets:**
- `splash.png` - App logo for splash screen
- `onboarding_1.png` - First onboarding illustration
- `onboarding_2.png` - Second onboarding illustration
- `onboarding_3.png` - Third onboarding illustration

---

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point and all components
│   ├── KaLbarApp               # App shell with theme configuration
│   ├── AppAssets               # Asset path constants
│   ├── SplashScreen            # Animated splash screen
│   ├── OnboardingScreen        # Three-page onboarding flow
│   ├── LoginScreen             # Authentication UI with validation
│   ├── HomeScreen              # Post-login dashboard
│   ├── AuthUser                # User domain model
│   ├── AuthService             # Authentication logic
│   └── AuthException           # Custom exception class
│
assets/
└── images/
    ├── splash.png
    ├── onboarding_1.png
    ├── onboarding_2.png
    └── onboarding_3.png
```

> **Note:** This is a single-file implementation for educational purposes. Production apps should follow proper separation of concerns.

---

## 🔌 API Integration

### DummyJSON Auth API

The app is designed to integrate with the [DummyJSON Authentication API](https://dummyjson.com/docs/auth#auth-login).

#### Endpoint

```http
POST https://dummyjson.com/auth/login
Content-Type: application/json
```

#### Request Body

```json
{
  "username": "emilys",
  "password": "emilyspass",
  "expiresInMins": 30
}
```

#### Success Response (200 OK)

```json
{
  "id": 1,
  "username": "emilys",
  "email": "emily.johnson@x.dummyjson.com",
  "firstName": "Emily",
  "lastName": "Johnson",
  "gender": "female",
  "image": "https://dummyjson.com/icon/emilys/128",
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### Error Response (400 Bad Request)

```json
{
  "message": "Invalid credentials"
}
```

### Dio Implementation Example

```dart
import 'package:dio/dio.dart';

class AuthService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 30,
        },
      );

      return AuthUser(
        id: response.data['id'],
        username: response.data['username'],
        email: response.data['email'],
        firstName: response.data['firstName'],
        lastName: response.data['lastName'],
        gender: response.data['gender'],
        image: response.data['image'],
        accessToken: response.data['accessToken'],
        refreshToken: response.data['refreshToken'],
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw const AuthException('Invalid username or password');
      }
      throw AuthException('Network error: ${e.message}');
    } catch (e) {
      throw AuthException('Unexpected error: $e');
    }
  }
}
```

---

## 📝 Notes

### Current Limitations

- ℹ️ **Social Login:** Facebook/Google buttons are UI-only (OAuth not implemented)
- ℹ️ **Password Recovery:** "Forgot password" link is a placeholder
- ℹ️ **Registration:** "Sign up" link is not functional
- ℹ️ **Persistence:** "Remember me" checkbox doesn't persist data (no local storage)
- ℹ️ **Token Refresh:** No automatic token refresh mechanism

### Implementation

- Splash screen with animations
- Three-page onboarding flow
- Login UI with validation
- In-memory authentication service
- Error handling and user feedback
- Home screen with user data display

---

## 🔗 Resources

### Documentation

- **DummyJSON API:** [https://dummyjson.com/docs/auth](https://dummyjson.com/docs/auth)
- **Flutter Documentation:** [https://docs.flutter.dev](https://docs.flutter.dev)
- **Dio Package:** [https://pub.dev/packages/dio](https://pub.dev/packages/dio)
- **Google Fonts:** [https://pub.dev/packages/google_fonts](https://pub.dev/packages/google_fonts)

### Design Resources

- **Material Design 3:** [https://m3.material.io](https://m3.material.io)
- **Poppins Font:** [https://fonts.google.com/specimen/Poppins](https://fonts.google.com/specimen/Poppins)
- **Flutter Animations:** [https://docs.flutter.dev/ui/animations](https://docs.flutter.dev/ui/animations)

### Learning Resources

- **Flutter Cookbook:** [https://docs.flutter.dev/cookbook](https://docs.flutter.dev/cookbook)
- **Dart Language Tour:** [https://dart.dev/guides/language/language-tour](https://dart.dev/guides/language/language-tour)
- **REST API Integration:** [https://docs.flutter.dev/cookbook/networking/fetch-data](https://docs.flutter.dev/cookbook/networking/fetch-data)

---

<div align="center">

**KaLbar** - Built with Flutter 💙

*University Mobile Development Assignment • 2024*

</div>