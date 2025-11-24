# FruitSense 🍎

**Smart Fruit Management & Detection**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

FruitSense uses AI to detect fruits, track inventory, and monitor freshness to prevent waste.

## ✨ Features

*   **🤖 AI Detection**: Identify fruits via Camera/Gallery using ML Kit.
*   **📦 Inventory**: Track stock, quantity, and expiry dates.
*   **🔔 Smart Alerts**: Get notified before fruits spoil.
*   **🎨 Modern UI**: Beautiful Dark & Light mode support.

## 🚀 Quick Start

### 1. Setup
Clone the repo and install dependencies:
```bash
git clone https://github.com/LeonelAgustav/FruitSense-FrontEnd-Flutter.git
cd fruitsense
flutter pub get
```

### 2. Configuration (.env)
Create a `.env` file in the root directory with your Firebase credentials:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_APP_ID=your_app_id
FIREBASE_PROJECT_NUMBER=your_project_number
```

### 3. Build Config
Generate `google-services.json` automatically:
```bash
dart run scripts/generate_config.dart
```

### 4. Run App
```bash
flutter run
```

## 🛠️ Tech Stack

*   **Core**: Flutter, Provider
*   **AI**: Google ML Kit Image Labeling
*   **Services**: Workmanager (Background tasks), Local Notifications
