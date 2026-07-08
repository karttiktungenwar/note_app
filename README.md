# Note App

A simple and intuitive Note-Taking application built using Flutter. This app allows users to easily create, view, update, and delete notes, providing a clean and responsive user interface.

## Features

- **User Authentication:** Secure Login and Signup functionality.
- **CRUD Operations:** Create, Read, Update, and Delete notes seamlessly.
- **Clean UI/UX:** Built with Flutter's modern design components for a fluid user experience.
- **REST API Integration:** Connects to a backend service to persist user data and notes.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed on your local machine:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Latest stable version recommended)
- Dart SDK
- An Android Emulator, iOS Simulator, or a physical device for testing.
- An IDE like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).

### Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/karttiktungenwar/note_app.git](https://github.com/karttiktungenwar/note_app.git)
   cd note_app
Install dependencies:
Get all the required packages specified in pubspec.yaml:

Bash
flutter pub get
Run the application:
Launch the app on your connected device or emulator:

Bash
flutter run
API Integration & Testing Guide
If you need help testing or integrating the authentication APIs, this application can be configured to interface with the mock environment provided by ReqRes.

Backend API Reference
API Documentation & Sandbox: https://reqres.in/ (or https://app.reqres.in/)

Test Credentials
To test the successful login flow via the ReqRes API endpoint (POST /api/login), you can use the following pre-defined user credentials:

Email: eve.holt@reqres.in

Password: cityslicka (or any password required by the sandbox)

Example Login Payload
When making a request to the login endpoint, ensure your HTTP client sends a JSON payload formatted as follows:

JSON
POST [https://reqres.in/api/login](https://reqres.in/api/login)
Header
Content-Type: application/json
x-api-key: add your api key


{
    "email": "eve.holt@reqres.in",
    "password": "cityslicka"
}
Expected Response (Success 200 OK):

JSON
{
    "token": "QpwL5tke4Pnpja7X4"
}
Note: Securely store this token locally (e.g., using flutter_secure_storage or shared_preferences) to persist the user's session.
