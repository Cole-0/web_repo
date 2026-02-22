
### **Quick Start Credentials**

* **Email:** `justine@test.com`
* **Password:** `password123`

---

### **1. Backend Setup (Laravel API)**

The API handles user authentication and serves as the bridge for session management.

* **Requirements:** PHP 8.x, Composer, SQLite/MySQL.
* **Installation:**
1. Navigate to the `api-repo` directory.
2. Run `composer install`.
3. Copy `.env.example` to `.env`.
4. Run `php artisan key:generate`.
5. Run `php artisan migrate --seed` to create the test user.


* **Running the Server:**
* To allow connections from physical devices or emulators, run:
`php artisan serve --host=0.0.0.0 --port=8000`



---

### **2. Frontend Setup (Flutter Web Repo)**

The Flutter app features authentication persistence, IP search validation, Google Maps integration, and multi-delete history.

* **Important Network Configuration:**
* **Android Emulator:** Set `baseUrl` in `lib/services/auth_service.dart` to `http://10.0.2.2:8000/api`.
* **Physical Device / Web:** Set `baseUrl` to your computer's Local IP (e.g., `http://192.168.1.XX:8000/api`).


* **Google Maps Integration:**
* The app is configured for **Android SDK 35**.
* A valid API Key must be placed in `android/app/src/main/AndroidManifest.xml` as a direct child of the `<application>` tag.
* **Note:** For web testing, ensure the *Maps SDK for JavaScript* is enabled in your Google Cloud Console and the script tag is added to `web/index.html`.



---

### **3. Key Features**

* **Authentication & Persistence:** Uses `shared_preferences` to maintain login state and features a functional Logout button.
* **Real-time Geolocation:** Fetches detailed IP data (City, Region, Country, Lat/Lng) via `ipinfo.io`.
* **Interactive Map:** Pins the exact location of any searched IP address.
* **History Management:** Scrollable search history with checkboxes for multi-delete functionality.
* **Validation:** Robust IP address regex validation to prevent invalid API calls.

---

### **4. Troubleshooting**

* **Black Screen on Launch:** This is typically a result of the Google Maps plugin failing to find a valid API key in the `AndroidManifest.xml`. Ensure the key is placed correctly inside the `<application>` element.
* **Connection Refused:** Ensure the Laravel server is running and the `baseUrl` in the Flutter service matches your machine's IP address.

