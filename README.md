# Event Sharing

A comprehensive Flutter-based event sharing and management application that enables users to create, share, discover, and participate in events within their community.

## 📱 Features

### Core Functionality
- **Event Management** - Create, view, and manage events with multi-step forms
- **Authentication** - Complete auth flow with sign up, sign in, OTP verification, password reset
- **Calendar Integration** - View and manage events with calendar view
- **Location Services** - Map-based event discovery using Google Maps
- **Donation System** - Suggest and process donations with payment integration
- **Profile Management** - User profiles, family members, connections, and contributions
- **Notifications** - Stay updated with event notifications
- **Search & Filters** - Advanced filtering by categories, date, and location

### Additional Features
- **Multi-language Support** - Localization capabilities
- **Dark/Light Theme** - Theme customization
- **Offline Detection** - No internet screen handling
- **Image Handling** - Network image caching and photo viewing
- **Invitation System** - Create and share event invitations
- **Event Ownership** - Transfer and manage event ownership
- **Wallet** - Integrated wallet functionality

## 🏗️ Project Structure

```
lib/
├── main.dart                 # Application entry point
├── controllers/              # Global state controllers
│   ├── auth_controller.dart
│   ├── home_controller.dart
│   ├── localization_controller.dart
│   ├── splash_controller.dart
│   └── theme_controller.dart
├── helpers/                  # Dependency injection & routing
│   ├── di.dart
│   └── route.dart
├── models/                   # Data models
│   ├── language_model.dart
│   └── userModel.dart
├── services/                 # API and network services
│   └── api_service.dart
├── themes/                   # App theming
│   ├── dark_theme.dart
│   └── light_theme.dart
├── utils/                    # Constants and utilities
│   ├── api_constants.dart
│   ├── app_colors.dart
│   ├── app_constants.dart
│   ├── app_icons.dart
│   ├── app_images.dart
│   ├── app_strings.dart
│   ├── message.dart
│   └── style.dart
└── views/                    # UI screens and widgets
    ├── base/                 # Reusable UI components
    └── screen/               # Feature screens
        ├── AddEvent/         # Event creation (5-step form)
        ├── Auth/             # Authentication screens
        ├── Calender/         # Calendar view
        ├── Categories/       # Event categories & filters
        ├── Home/             # Home screen & donations
        ├── InviteEvent/      # Event invitations
        ├── MapScreen/        # Location-based view
        ├── MyEvent/          # User's events management
        ├── Notifications/    # Notifications list
        ├── Onboard/          # Onboarding flow
        ├── OwnerShip/        # Event ownership
        ├── Profile/          # Profile & settings
        ├── SearchEvent/      # Event search
        ├── Splash/           # Splash screen
        ├── UpComingEvent/    # Upcoming events
        └── Wallet/           # Wallet screen
```

## 📦 Dependencies

### State Management & Utilities
- **get** - State management and routing
- **shared_preferences** - Local storage
- **intl** - Internationalization
- **timeago** - Relative time formatting

### UI Components
- **flutter_screenutil** - Responsive UI
- **flutter_svg** - SVG support
- **flutter_spinkit** - Loading indicators
- **shimmer** - Loading skeletons
- **dotted_border** - Custom borders
- **fluttertoast** - Toast messages
- **pin_code_fields** - OTP input
- **easy_stepper** - Step indicators
- **grouped_list** - Grouped lists

### Network & Images
- **cached_network_image** - Image caching
- **http** - HTTP client
- **image_picker** - Image selection
- **photo_view** - Image zooming

### Maps & Location
- **google_maps_flutter** - Map integration
- **geolocator** - Location services
- **geocoding** - Address conversion

### Calendar
- **table_calendar** - Calendar widget
- **syncfusion_flutter_calendar** - Advanced calendar

### Connectivity
- **connectivity_plus** - Network status
- **internet_connection_checker** - Connection monitoring

### Other
- **flutter_html** - HTML rendering
- **webview_flutter** - Web content
- **flutter_typeahead** - Typeahead search
- **country_code_picker** - Country codes
- **google_fonts** - Custom fonts
- **flutter_keyboard_visibility** - Keyboard detection

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.4.3)
- Dart SDK (>=3.4.3 <4.0.0)
- Android Studio / VS Code
- Android SDK or Xcode for development

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Event-Sharing
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🎨 Configuration

### Assets
The app uses the following asset directories:
- `assets/language/` - Language files
- `assets/icons/` - Icon assets
- `assets/images/` - Image assets
- `assets/fonts/` - Custom fonts (Poppins)

### API Configuration
Update API endpoints in `lib/utils/api_constants.dart`

### Theme
Customize themes in:
- `lib/themes/light_theme.dart`
- `lib/themes/dark_theme.dart`

## 📱 Screens Overview

### Authentication Flow
- Sign Up → OTP Verification → Account Created
- Sign In → Verification (if needed)
- Forgot Password → OTP → Reset Password

### Event Management
1. **Create Event** - 5-step form with details, location, date, etc.
2. **View Events** - Home, upcoming, today, history
3. **Filter Events** - By category, date, location
4. **Event Details** - Full event information with actions

### Profile & Social
- Personal profile editing
- Family member management
- Connections (new, remove)
- Contributions tracking
- Settings and preferences

## 🔧 Architecture

This project follows a **feature-based architecture** with:
- **Controllers** for state management using GetX
- **Services** for API calls and data fetching
- **Models** for data structures
- **Views** organized by feature
- **Dependency Injection** for service management

## 🌍 Localization

Multi-language support is implemented through:
- `localization_controller.dart` for language switching
- Language files in `assets/language/`
- `app_strings.dart` for string constants

## 📝 Development Guidelines

### Adding New Features
1. Create feature folder in `views/screen/`
2. Add controller in `controllers/` if needed
3. Update routes in `helpers/route.dart`
4. Register dependencies in `helpers/di.dart`

### API Integration
- Use `api_service.dart` for network calls
- Define endpoints in `api_constants.dart`
- Handle loading states with custom widgets
- Implement error handling with no internet screen

## 🐛 Troubleshooting

### Common Issues

**Build fails:**
```bash
flutter clean
flutter pub get
flutter run
```

**Map issues:**
- Ensure Google Maps API key is configured in Android/iOS

**Dependency conflicts:**
```bash
flutter pub deps
flutter pub upgrade
```

## 📄 License

This project is private and not for public distribution.

## 👥 Contributing

For contributions, please:
1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## 📞 Support

For issues or questions, please refer to:
- Flutter Documentation: https://docs.flutter.dev
- GetX Documentation: https://pub.dev/packages/get

---

Built with ❤️ using Flutter
