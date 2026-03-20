# 📚 Komga Reader

A lightweight Flutter comic reader for Komga, supporting Android and iOS.

## Features

- ✅ Multi-server support
- ✅ Browse libraries, series, and books
- ✅ Online reading with multiple modes (single/double/continuous)
- ✅ Reading progress sync
- ✅ Download for offline reading
- ✅ Dark/Light theme
- ✅ Cross-platform (Android & iOS)

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod 2.x
- **Network**: Dio + Retrofit
- **Local Storage**: Hive + Isar
- **Image Caching**: Cached Network Image

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / Xcode

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd komga_reader
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # App configuration
├── core/                        # Core utilities
├── data/                        # Data layer
├── domain/                      # Domain layer
├── presentation/                # Presentation layer
└── features/                    # Feature modules
```

## Development

### Code Generation

Run build_runner to generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
flutter test
```

## License

MIT License
