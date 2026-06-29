# 🎓 Student Life Manager

<div align="center">

### Organize your academic life in one place.

*A modern offline-first Flutter application that helps students manage subjects, assignments, and notes with a clean and intuitive interface.*

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge\&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge\&logo=dart)
![SQLite](https://img.shields.io/badge/SQLite-Database-003B57?style=for-the-badge\&logo=sqlite)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-success?style=for-the-badge)

</div>

---

# 📖 About

Student Life Manager is an offline-first Flutter application that helps students organize their academic life by managing subjects, assignments, and notes in one place.

The application is lightweight, fast, and stores all data locally using SQLite, making it available without an internet connection.

---

# ✨ Features

* 📊 Dashboard with task statistics
* 📚 Subject Management
* ✅ Assignment & Task Tracking
* 📝 Subject Notes
* 🌙 Dark Mode
* 💾 SQLite Local Storage
* 🔍 Task Search
* 📱 Material Design 3
* 🌍 Cross Platform Support

---

# 🛠 Tech Stack

| Technology    | Description              |
| ------------- | ------------------------ |
| Flutter       | Cross-platform Framework |
| Dart          | Programming Language     |
| SQLite        | Local Database           |
| sqflite       | Database Package         |
| Material 3    | UI Design                |
| FutureBuilder | Async UI                 |
| ValueNotifier | Theme Switching          |

---

# 📱 Supported Platforms

* ✅ Android
* ✅ iOS
* ✅ Web
* ✅ Windows
* ✅ macOS
* ✅ Linux

---

# 📸 Screenshots

## Dashboard

<p align="center">
<img src="./assets/screenshots/dashboard.jpeg" width="280">
</p>

---

## Subjects

<p align="center">
<img src="./assets/screenshots/subjects.jpeg" width="280">
</p>

---

## Tasks

<p align="center">
<img src="./assets/screenshots/tasks.jpeg" width="280">
</p>

---

## Notes

<p align="center">
<img src="./assets/screenshots/notes.jpeg" width="280">
</p>

---

# 📂 Project Structure

```text
lib/
│
├── core/
│   ├── data/
│   ├── settings/
│   └── theme/
│
├── features/
│   ├── dashboard/
│   ├── settings/
│   ├── subjects/
│   └── tasks/
│
├── notes/
│
├── home_screen.dart
└── main.dart
```

---

# ⚙️ Installation

Clone the repository

```bash
git clone https://github.com/hussein-almasri/student_life_manager.git
```

Open the project

```bash
cd student_life_manager
```

Install dependencies

```bash
flutter pub get
```

Run the application

```bash
flutter run
```

---

# 🚀 Build

```bash
flutter build apk
flutter build appbundle
flutter build web
flutter build windows
flutter build linux
flutter build macos
```

---

# 📖 Usage

1. Create your academic subjects.
2. Add assignments and deadlines.
3. Track completed tasks.
4. Write notes for every subject.
5. Stay organized with the dashboard.

---

# 🏛 Architecture

The project follows a **Feature-First Architecture** with a shared **Core Layer**.

```
Presentation
      │
      ▼
Business Logic
      │
      ▼
SQLite Database
```

---

# 💾 Local Storage

All data is stored locally using SQLite.

* Subjects
* Tasks
* Notes
* Settings

No internet connection is required.

---

# 🚀 Future Improvements

* 🔔 Local Notifications
* 📅 Calendar View
* 🌍 Multi-language Support
* ☁️ Cloud Backup
* ⭐ Task Priority
* 📤 Export & Import Data

---

# 👨‍💻 Author

**Hussein Almasri**

GitHub:
https://github.com/hussein-almasri

---

# 📄 License

This project is licensed under the MIT License.

---

<div align="center">

### ⭐ If you like this project, don't forget to leave a star!

Made with ❤️ using Flutter.

</div>
