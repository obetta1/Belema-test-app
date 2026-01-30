# Belema Test App

A Flutter-based mobile fintech application that provides secure banking and financial services including user authentication, fund transfers, transaction PIN management, and transaction history tracking.

## Features

### 🔐 Authentication
- Secure user login with username and password
- Automatic token management with secure storage
- Conditional navigation based on PIN setup status

### 💰 Fund Transfers
- Inter-bank money transfers across Nigerian banks
- Real-time account validation and name verification
- Transaction PIN authentication
- Balance validation before transfers
- Support for 25+ Nigerian banks

### 🔒 Transaction PIN Management
- Secure PIN setup for transaction authorization
- PIN validation and confirmation
- Encrypted PIN storage and transmission

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
   git clone <repository-url>
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

### Build Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get

# Analyze code
flutter analyze

# Format code
dart format lib/

# Run tests (when available)
flutter test
```

## Configuration

### Environment Setup
- **Base URL**: Configured in `lib/core/utils/constants.dart`
- **Design Size**: 375x800 (iPhone X dimensions) for responsive scaling
- **Text Scaling**: Clamped to 1.0 to prevent accessibility scaling

### Security Features
- JWT token authentication with automatic refresh
- Secure storage for sensitive data
- PIN-based transaction authorization
- Encrypted API communications

## Development Guidelines

### Code Style
- Follow Flutter linting rules
- Use camelCase for files and variables
- Implement proper error handling with try-catch blocks
- Use Riverpod for state management
- Follow feature-driven modular architecture

### Testing
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for complete flows
- Mock API responses for testing

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.
