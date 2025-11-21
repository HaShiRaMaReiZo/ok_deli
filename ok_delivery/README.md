# OK Delivery - Merchant App

A Flutter application for merchants to manage their delivery packages.

## Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Generate JSON serialization code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── api/          # API client and endpoints
│   ├── theme/        # App theme and colors
│   └── constants/    # App constants
├── models/           # Data models with json_serializable
├── repositories/     # Data repositories
├── bloc/             # BLoC state management
│   └── auth/         # Authentication BLoC
└── screens/          # UI screens
    └── auth/         # Authentication screens
```

## Color Theme

- Primary Blue: `#8FABD4`
- Light Beige: `#EFECE3`
- Dark Blue: `#4A70A9`
- Black: `#000000`

## Features

- ✅ Login with email/password
- ✅ Role validation (merchant only)
- ✅ Token-based authentication
- 🔄 Dashboard (coming soon)
- 🔄 Package management (coming soon)
