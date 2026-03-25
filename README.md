# Rick & Morty Character Explorer (Flutter)

## 📱 Overview
This Flutter application was developed as part of a technical assignment.  
It integrates with the Rick & Morty API and demonstrates clean architecture, state management, offline-first behavior, and local data handling.

---

## 🚀 Features

### 🔹 Character List
- Fetches characters from the Rick & Morty API
- Infinite scroll pagination
- Displays image, name, species, and status
- Local search (name, species, status)

### 🔹 Character Details
- Full character information view
- Includes:
  - Name
  - Status
  - Species
  - Type
  - Gender
  - Origin
  - Location

### 🔹 Favorites
- Add/remove characters to favorites
- Favorites stored locally using Hive
- Accessible offline

### 🔹 Local Editing (Key Requirement)
- Editable fields:
  - Name, Status, Species, Type, Gender
  - Origin name, Location name
- Edits are stored locally (no API write-back)
- Edited values override API data:
  - List view
  - Detail view
- Changes persist after app restart

### 🔹 Offline Support
- API responses cached locally
- Offline mode automatically falls back to cached data
- Favorites and edited data remain accessible

---

## 🧠 Architecture & Design

- **State Management:** Riverpod
- **Networking:** Dio
- **Local Storage:** Hive
- **Connectivity:** connectivity_plus
- **Architecture:** Feature-based clean structure

```
lib/
 ├── core/
 │   ├── constants/
 │   ├── network/
 │   └── utils/
 ├── features/
 │   └── characters/
 │       ├── data/
 │       │   ├── datasources/
 │       │   ├── models/
 │       │   └── repositories/
 │       └── presentation/
 │           ├── providers/
 │           ├── screens/
 │           └── widgets/
 └── main.dart
```

---

## 🔄 Data Handling Strategy

The application maintains three separate data layers:

1. **API Data (Base Layer)** → Cached locally
2. **Local Edits (Override Layer)**
3. **Favorites (User Preference Layer)**

### Merge Logic

At runtime, the app merges data as follows:

```
Final UI Data = API Data + Local Edits
```

- API data is loaded from cache
- Local edits are applied by character ID
- Edited fields override API values consistently across all screens

---

## 🌐 Offline Behavior

### When Online:
- Fetch paginated data from API
- Store characters locally

### When Offline:
- Load cached characters
- Apply:
  - Favorites
  - Local edits

---

## ⚙️ Setup Instructions

1. Install Flutter (latest stable version)
2. Run the following commands:

```bash
flutter pub get
flutter run
```

---

## 📽️ Demo Explanation (Text Walkthrough)

### Character List
- Displays paginated characters
- Infinite scroll implemented

### Character Details
- Shows full character data

### Favorites
- Persistent using local storage

### Local Editing (Core Feature)
- Users can edit character fields
- Edits override API data
- Persist after restart

### Offline Mode
- App works without internet using cached data
- Favorites and edits remain visible

---

## ⚠️ Known Limitations

- No unit/widget tests included
- Search is local (no API query integration)
- Offline detection uses connectivity + fallback logic

---

## 💡 Design Decisions

- Focused on correctness and clarity over over-engineering
- Used Hive for fast local storage and offline-first behavior
- Kept UI minimal but clean and responsive
- Implemented merge logic inside repository for consistency



---

## 👨‍💻 Author
partha Sarathi Baral
