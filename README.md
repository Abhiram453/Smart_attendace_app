# 🎓 Smart Attendance App (Rule-Based AI Powered)

![Flutter](https://img.shields.io/badge/Flutter-3.44.8-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.11.0-blue.svg)
[![Live Web Demo](https://img.shields.io/badge/Live%20Demo-classtrackkk.netlify.app-brightgreen.svg)](https://classtrackkk.netlify.app/)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![AI](https://img.shields.io/badge/Engine-Rule--Based%20AI-purple.svg)

> 🚀 **Live Web Application Demo**: [https://classtrackkk.netlify.app/](https://classtrackkk.netlify.app/)

**Smart Attendance App** is an intelligent, cross-platform mobile and web application built with Flutter and Firebase that streamlines classroom attendance management through high-speed dynamic QR code generation, real-time scanning, role-based authentication, and a built-in Rule-Based AI Engine. The AI engine continuously analyzes student attendance trends to automatically alert students at risk of falling below attendance thresholds (<75%), award streak badges for top performers, and provide teachers with data-driven engagement insights and interactive analytics charts.

---

## 🌐 Live Application URL

- 🔗 **Web Demo**: **[https://classtrackkk.netlify.app/](https://classtrackkk.netlify.app/)**
- 📦 **GitHub Repository**: **[https://github.com/Abhiram453/Smart_attendace_app.git](https://github.com/Abhiram453/Smart_attendace_app.git)**

## 🚀 Key Features

- **🤖 Rule-Based AI Engine**:
  - Automatically flags low attendance risks (<75%) and sends proactive warning notifications.
  - Detects consecutive absences and recommends immediate teacher intervention.
  - Rewards students with high attendance (90%+) with achievement streak badges.
  - Generates actionable class analytics and engagement recommendations for educators.

- **🎨 Google Stitch Inspired Dark Theme & Responsive UI**:
  - Premium dark UI design (`#0D0E15`) with vibrant neon gradients, smooth micro-animations, and custom typography (*Plus Jakarta Sans*).
  - 100% responsive across mobile phones, tablets, and web browsers using `LayoutBuilder` and `MediaQuery`.

- **🔐 Role-Based Authentication & Database**:
  - Real user registration and sign-in for **Teachers** and **Students**.
  - Custom student roll/ID registration and role-segregated navigation flows.

- **⚡ Dynamic QR Code Session Management**:
  - Teachers create live QR sessions with expiration timers (15m, 30m, 60m).
  - High-contrast pure white QR containers guarantee clear scanning on all devices.
  - Manual token entry fallback for web and desktop platforms without active camera hardware.

- **📊 Attendance Analytics & Visual Charts**:
  - Interactive attendance statistics, weekly distribution charts (`fl_chart`), and detailed student logs.

---

## 📸 Application Flow & Previews

1. **Animated Splash Screen**: Instagram-style scale & fade logo entrance.
2. **Role Selection & Real Auth**: Choose between Teacher or Student workspaces; register new accounts or sign in.
3. **Teacher Dashboard**: Create classes, launch live QR sessions, and review AI class insights.
4. **QR Session View**: Crisp white QR code card, active timer countdown, payload copy/share, and student scan simulation.
5. **Student Dashboard & Scanner**: Scan QR codes or submit tokens to log attendance in real-time.

---

## 🛠️ Getting Started & Setup Instructions

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)
- [Dart SDK](https://dart.dev/get-started/sdk) (v3.0.0 or higher)
- Google Chrome browser (for web testing) or Android Studio (for Android emulator/device)

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Abhiram453/Smart_attendace_app.git
   cd Smart_attendace_app
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   - **Run on Web (Chrome)**:
     ```bash
     flutter run -d chrome
     ```
   - **Run on Android Mobile**:
     ```bash
     flutter run -d android
     ```
   - **Run on Windows Desktop**:
     ```bash
     flutter run -d windows
     ```

---

## 🌐 Deployment & Build Guide

### 1. Web Release Build & Firebase Hosting
To build and deploy the production-ready web application:

```bash
# Generate production web assets
flutter build web --release
```

- **Deploying to Firebase Hosting**:
  ```bash
  firebase init hosting
  # Set public directory to: build/web
  firebase deploy --only hosting
  ```
- **Deploying to Netlify**:
  - Drag and drop the `build/web` folder directly into [Netlify Drop](https://app.netlify.com/drop).

---

### 2. Android Release APK Build
To build the standalone APK for Android deployment:

```bash
flutter build apk --release
```

- The release APK will be located at:
  `build/app/outputs/flutter-apk/app-release.apk`

---

## 🌟 Future Roadmap & Enhancements

- [ ] **🧠 RAG & Natural-Language Attendance Summaries**:
  - Integration with LLM Retrieval-Augmented Generation (RAG) to allow teachers to query attendance data in natural language (e.g., *"Summarize attendance trends for CS401 this month"*).

- [ ] **👤 Google ML Kit Face Recognition**:
  - Multi-factor attendance verification combining dynamic QR scanning with biometric face detection using `google_mlkit_face_detection`.

- [ ] **🔔 Firebase Cloud Messaging (FCM)**:
  - Automated push notifications delivered directly to students' mobile devices for low-attendance alerts and upcoming class sessions.

---

## 📄 License
This project is licensed under the [MIT License](LICENSE).
