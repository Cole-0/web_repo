# Software Engineer Technical Assessment - Justine Nicole Daquioag

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

* **Google Maps Configuration (Android):**
    To use the map features, you must provide your own Google Maps API Key.
    1. Open `android/app/src/main/AndroidManifest.xml`.
    2. Inside the `<application>` tag, locate or add the following `<meta-data>` element:
    ```xml
    <meta-data 
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_API_KEY_HERE"/>
    ```
    3. Replace `YOUR_API_KEY_HERE` with your actual key.

* **Web Testing:** Ensure the *Maps SDK for JavaScript* is enabled in your Google Cloud Console and the script tag is added to `web/index.html`.

---

### **3. How to Obtain a Google Maps API Key**

If you do not have an API key, follow these steps:

1. **Google Cloud Console:** Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. **Project:** Create a new project or select an existing one.
3. **Enable APIs:** Navigate to **APIs & Services > Library**. Search for and enable:
    * **Maps SDK for Android**
    * **Maps SDK for JavaScript**
4. **Create Credentials:**
    * Go to **APIs & Services > Credentials**.
    * Click **+ CREATE CREDENTIALS** and select **API key**.
5. **Copy & Paste:** Copy the generated key and paste it into the `AndroidManifest.xml` as shown in Section 2.

---

### **4. Key Features**

* **Authentication & Persistence:** Uses `shared_preferences` to maintain login state and features a functional Logout button.
* **Real-time Geolocation:** Fetches detailed IP data (City, Region, Country, Lat/Lng) via `ipinfo.io`.
* **Interactive Map:** Pins the exact location of any searched IP address.
* **History Management:** Scrollable search history with checkboxes for multi-delete functionality.
* **Validation:** Robust IP address regex validation to prevent invalid API calls.

---

### **5. Troubleshooting**

* **Black Screen on Launch:** This usually means the Google Maps plugin cannot find a valid API key in `AndroidManifest.xml`. Ensure the key is placed correctly inside the `<application>` element.
* **Connection Refused:** Ensure the Laravel server is running (`php artisan serve --host=0.0.0.0`) and the `baseUrl` in the Flutter service matches your machine's Local IP address.
