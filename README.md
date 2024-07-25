# Time News

This project is a Flutter application for a news app that consumes data from [newsapi.org](https://newsapi.org).

## Requirements

Make sure you have the following tools installed on your system:

- [Flutter 3.22.2](https://flutter.dev/docs/get-started/install)
- [Xcode](https://developer.apple.com/xcode/) (for iOS)
- [Android Studio](https://developer.android.com/studio) (for Android)

## Steps to run the application

### 1. Set up the Flutter environment

1. Make sure Flutter is installed and configured correctly. To verify, run:

   ```bash
   flutter doctor

2. Resolve any issues indicated by flutter doctor.

### 2. Set up project dependencies

1. Navigate to the Flutter project directory:

    ```bash
    cd path/to/project

2. Install Flutter dependencies:
    
    ```bash
    flutter pub get

### 3. Create the environment file

1. Create a .env file in the root of your project with the following content:

    ```bash
    API_KEY=YOUR_API_KEY
    BASE_URL=https://newsapi.org/v2
    DATABASE_NAME=time_news_db
    FAVORITE_TABLE_NAME=favorite_news
    CREATE_FAVORITE_TABLE_SCRIPT=CREATE TABLE favorite_news (id INTEGER PRIMARY KEY, author TEXT, title TEXT, description TEXT, content TEXT, sourceName TEXT, url TEXT, urlToImage TEXT, publishedAt TEXT)

Note: Make sure to keep the API key secure and do not share it publicly.

### 4. Run on iOS simulator

1. Open the iOS simulator via terminal:

    ```bash
    open -a Simulator

2. With the iOS simulator running, go back to the Flutter project root directory and run:

    ```bash
    flutter run

### 5. Run on Android emulator

1. Open Android Studio.

2. Go to Configure > AVD Manager.

3. Create a new virtual device (if necessary) and start the emulator.

4. With the Android emulator running, go back to the Flutter project root directory and run:

    ```bash
    flutter run


This README covers the essential steps to run a Flutter application on both the iOS simulator and Android emulator, including instructions for creating an environment file.
