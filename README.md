# FitHub - Exercise Discovery App

A Flutter mobile application for discovering and managing exercises, built as part of the Artisans Mobile Developer recruitment process.

## Features

✅ **Firebase Authentication**
- Email/Password registration and login
- Google Sign-In integration
- Secure user authentication and session management

✅ **Exercise Discovery**
- Browse 100+ exercises from ExerciseDB API
- Grid view with smooth scrolling
- Cached exercise images for better performance

✅ **Search & Filtering**
- Real-time search by exercise name, target muscle, or body part
- Filter by body part (chest, back, legs, etc.)
- Filter by equipment (barbell, dumbbell, bodyweight, etc.)
- Combine multiple filters

✅ **Exercise Details**
- High-quality GIF demonstrations
- Detailed instructions (step-by-step)
- Target muscle information
- Secondary muscles involved
- Required equipment

✅ **Favorites System**
- Add/remove exercises from favorites
- Local storage using Hive
- Persistent across app sessions
- Dedicated favorites screen

✅ **Dark/Light Mode**
- Toggle between themes in profile screen
- Preference persisted using SharedPreferences
- Beautiful UI in both modes

✅ **User Profile**
- Display user information (from Google or Email)
- Theme toggle
- Sign out functionality
- App version info

✅ **Workout Gamification**
- Daily workout routine tracking
- Exercise completion with checkmarks
- XP (Experience Points) rewards system
- Level progression based on completed workouts  
- Confetti celebration on workout completion
- Local XP persistence using Hive
- Circular progress indicators

✅ **Network Connectivity**
- Real-time network status monitoring
- Offline/online indicators
- Red banner when disconnected
- Green banner when reconnected
- Automatic connectivity detection

## Architecture

Built using **Clean Architecture** principles with the following structure:

```
lib/
├── core/
│   ├── constants/      # App-wide constants
│   ├── network/        # Dio HTTP client
│   ├── router/         # GoRouter configuration
│   └── theme/          # Light/Dark themes
├── features/
│   ├── auth/           # Authentication screens & widgets
│   ├── exercises/      # Exercise list, details, widgets
│   ├── favorites/      # Favorites screen
│   └── profile/        # Profile screen
├── models/             # Data models (Exercise, User)
├── providers/          # Riverpod state management
├── services/           # Business logic services
└── widgets/            # Shared UI widgets
```

## Technology Stack

### Required
- **Flutter SDK**: ^3.8.0
- **State Management**: Riverpod
- **Firebase**: Authentication (Email & Google Sign-In)
- **HTTP Client**: Dio
- **Navigation**: GoRouter
- **Local Storage**: Hive + SharedPreferences
- **UI**: Cached Network Image, Shimmer

### API
- **ExerciseDB** (via RapidAPI): https://rapidapi.com/justin-WFnsXH_t6/api/exercisedb

## Setup Instructions

### Prerequisites
- Flutter SDK installed ([Installation Guide](https://flutter.dev/docs/get-started/install))
- Android Studio or VS Code with Flutter extensions
- Git

### 1. Clone the Repository

```bash
git clone https://github.com/mmb911/Exercise_app.git
cd Exercise_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

#### A. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (or use existing)
3. Enable Email/Password and Google Sign-In in Authentication

#### B. Android Configuration
1. Register your Android app in Firebase Console
   - Package name: `com.example.exercises_app_task`
2. Download `google-services.json`
3. Place it in `android/app/google-services.json`

The Google services plugin is already configured in:
- `android/settings.gradle.kts`
- `android/app/build.gradle.kts`

#### C. Add SHA Fingerprints (Required for Google Sign-In)

**For Debug Build:**
```bash
cd android
./gradlew signingReport
```

Copy the SHA-1 and SHA-256 fingerprints from the output and add them to Firebase Console:
1. Go to Firebase Console → Project Settings
2. Select your Android app
3. Click "Add fingerprint"
4. Paste SHA-1 and SHA-256 values

**For Release Build:**
```bash
keytool -list -v -keystore your-release-key.keystore -alias your-key-alias
```

> ⚠️ **Important**: Without proper SHA fingerprints, Google Sign-In will fail with `ApiException: 10`

#### D. iOS Configuration (Optional)
1. Register your iOS app in Firebase Console
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/GoogleService-Info.plist`

### 4. Environment Variables Setup

This app uses environment variables to store sensitive data securely.

1. **Copy the example environment file**:
   ```bash
   cp .env.example .env
   ```

2. **Get your RapidAPI Key**:
   - Sign up at [RapidAPI](https://rapidapi.com/)
   - Subscribe to [ExerciseDB API](https://rapidapi.com/justin-WFnsXH_t6/api/exercisedb) (FREE plan - 500 requests/month)
   - Copy your API key from the API dashboard

3. **Update `.env` file**:
   Open the `.env` file and replace `your_rapidapi_key_here` with your actual API key:
   
   ```env
   # RapidAPI Configuration
   RAPID_API_KEY=your_actual_api_key_here
   RAPID_API_HOST=exercisedb.p.rapidapi.com
   
   # API Base URL
   EXERCISE_API_BASE_URL=https://exercisedb.p.rapidapi.com
   ```

> ⚠️ **Important**: Never commit the `.env` file to version control. It's already in `.gitignore`.

### 5. Run the App

```bash
# Check for issues
flutter doctor

# Run on connected device/emulator
flutter run

# Run in release mode
flutter run --release
```

## Building APK

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

## Testing the App

1. **Sign Up** - Create account with email/password
2. **Login** - Sign in with credentials or Google
3. **Browse Exercises** - Scroll through exercise list
4. **Search** - Type in search bar (e.g., "push", "squat")
5. **Filter** - Tap Filters button, select body part or equipment
6. **View Details** - Tap any exercise card
7. **Favorite** - Tap heart icon in details screen
8. **View Favorites** - Tap favorites icon in app bar
9. **Toggle Theme** - Go to profile → toggle theme switch
10. **Sign Out** - Profile → Sign Out button

## State Management

Using **Riverpod** for reactive state management:

- `authProvider` - Firebase authentication state
- `exercisesProvider` - Exercise data from API
- `filteredExercisesProvider` - Filtered/searched exercises
- `favoritesProvider` - Local favorites management
- `themeModeProvider` - Dark/light theme state

## Key Features Explained

### Authentication
- Implemented via `FirebaseAuth`
- Google Sign-In uses `google_sign_in` package
- Auth state redirects handled by `GoRouter`

### Exercise API Integration
- Uses Dio HTTP client with interceptors
- Error handling for network failures
- Caching strategy with `CachedNetworkImage`

### Favorites
- Stored locally using Hive (NoSQL database)
- Persists across app sessions
- No backend required

### Search & Filters
- Client-side filtering for instant results
- Debounced search input
- Multiple filter combinations

## Project Structure

```
Exercise_app/
├── android/                # Android platform files
├── ios/                    # iOS platform files  
├── lib/                    # Dart source code
├── test/                   # Unit tests
├── pubspec.yaml            # Dependencies
├── README.md               # This file
├── FIREBASE_SETUP.md       # Firebase setup guide
└── SETUP_CHECKLIST.md      # Quick setup checklist
```

## Screenshots

> Add screenshots here after running the app

## Known Issues

- Google Sign-In requires SHA-1 fingerprint for release builds
- ExerciseDB API has rate limit (500 requests/month on free plan)

## Future Enhancements

- Workout planner
- Exercise history tracking
- Custom exercise notes
- Share exercises with friends
- Exercise video tutorials

## Contact

For questions about this project, contact:
- Email: mbmonther@gmail.com
- GitHub: mmb911

## Acknowledgments

- **ExerciseDB API** for providing comprehensive exercise data
- **Firebase** for authentication services
- **Artisan's** for the recruitment opportunity

---

**Submission Date**: December 2025  
**Developed by**: Monther Byala  
**For**: Artisans Mobile Developer Recruitment
