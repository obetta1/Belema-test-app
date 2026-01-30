# Belema Test App

A Flutter-based mobile fintech application demo for banking and financial services including user authentication, fund transfers, transaction PIN management, and transaction history tracking.

## Features

### 🔐 Authentication
- Secure user login with username and password
- Automatic token management with secure storage
- Conditional navigation based on PIN setup status

### 💰 Fund Transfers
- Inter-bank money transfers simulation
- Transaction PIN authentication
- Balance validation before transfers

### 🔒 Transaction PIN Management
- PIN setup for transaction authorization
- PIN validation and confirmation

### 📊 Dashboard & Transactions
- Real-time wallet balance display
- Transaction history with credit/debit indicators
- Quick action shortcuts for common operations
- User profile and account information

## Architecture

### Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Networking**: Custom HTTP client with bearer token authentication
- **Storage**: Secure storage for tokens and sensitive data
- **UI**: Responsive design with ScreenUtil
- **Validation**: Form validation with real-time feedback

### Project Structure
```
lib/
├── core/                    # Shared infrastructure
│   ├── api/                # HTTP networking layer
│   ├── models/             # Data models
│   ├── routes/             # App navigation
│   ├── states/             # Global state management
│   ├── utils/              # Utilities and constants
│   └── widgets/            # Reusable UI components
└── features/               # Feature modules
    ├── auth/               # Authentication screens & services
    ├── dashboard/          # Dashboard & transaction history
    ├── pin/                # PIN management
    └── transfer/           # Money transfer functionality
```

## API Endpoints

The app integrates with the following backend endpoints:
- `POST /login` - User authentication
- `GET /get-account-details` - Account validation
- `POST /transfer` - Money transfer processing
- `POST /set-transaction-pin` - PIN setup
- `GET /get-transactions` - Transaction history

## Getting Started

### Prerequisites
- Flutter SDK (3.1.2 or higher)
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter extensions
- iOS Simulator (macOS only) or Android emulator/device

### Installation

1. **Clone the repository**
   ```bash
   git clone  https://github.com/obetta1/Belema-test-app.git
   cd belema_test_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Android
   flutter run

   # For iOS (macOS only)
   flutter run --platform ios

   # For web
   flutter run -d chrome
   ```


## Configuration

### Environment Setup
- **Base URL**: Configured in `lib/core/utils/constants.dart`
- **Design Size**: 375x800 (iPhone X dimensions) for responsive scaling
- **Text Scaling**: Clamped to 1.0 to prevent accessibility scaling


