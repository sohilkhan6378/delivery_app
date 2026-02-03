# Delivery Boy App (Flutter + Google Sheets)

A production-ready Flutter app for delivery staff that uses Google Sheets as the database. The app follows the flow: **Login → Assigned Orders → Pickup → Delivery → History**, with photo proofs and GPS capture.

## Features
- GetX routing and state management
- Responsive UI for mobile, web, and desktop
- Login against `Users` sheet
- Assigned order listing from `Orders` sheet
- Pickup proof upload
- Delivery proof upload (delivery photo + receiver photo + GPS)
- History search and filters
- Offline-aware error states and retry
- Toasts/snackbars on every action

## Google Sheets Schema
### Users Sheet
| Email | Name | Role | Phone |

### Orders Sheet
| OrderID | PartyName | AssignedPerson | PickupPhoto | PickupTime | PickupStatus | DeliveryPhoto | DeliveryTime | DeliveryStatus | ReceiverPhoto | DeliveryLocation |

> **Note:** `ReceiverPhoto` and `DeliveryLocation` are added automatically by the Apps Script if missing.

---

## Apps Script (Write API) Setup
The app uses a Google Apps Script Web App for write operations.

1. Open your Google Sheet → **Extensions → Apps Script**
2. Paste the code from `apps_script/Code.gs`
3. Set `DRIVE_FOLDER_ID` (optional) in the script to store uploaded photos
4. Deploy as **Web App** with access **Anyone**
5. Copy the Web App URL and use it in `.env` as `APPS_SCRIPT_BASE_URL`

### Endpoints
- `POST ?path=login`
- `GET ?path=orders&assignedTo=`
- `POST ?path=pickupSubmit`
- `POST ?path=deliverySubmit`

---

## Flutter Setup
### 1) Create `.env`
```bash
cp .env.example .env
```
Fill values:
```
SHEET_ID=your_sheet_id
SHEETS_API_KEY=your_api_key
USERS_SHEET_NAME=Users
ORDERS_SHEET_NAME=Orders
APPS_SCRIPT_BASE_URL=https://script.google.com/macros/s/.../exec
ASSIGNED_MATCH_FIELD=Name
```

### 2) Install Flutter SDK
```bash
flutter doctor
```

### 3) Install dependencies
```bash
flutter pub get
```

### 4) Run the app
- **Android**: `flutter run`
- **iOS**: `cd ios && pod install && flutter run`
- **Web**: `flutter run -d chrome`
- **Windows/macOS/Linux**: Enable desktop support and run `flutter run`

---

## Testing Checklist
- Valid login should succeed, invalid login should fail.
- Pickup submit updates pickup columns in sheet.
- Delivery submit updates delivery columns + receiver photo + location.
- Permission denied flows should show errors.
- Offline mode should show retry UI.

---

## Folder Structure
```
lib/
  main.dart
  app/
    routes/
      app_routes.dart
      app_pages.dart
    bindings/
      initial_binding.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_text_styles.dart
    utils/
      constants.dart
      validators.dart
      date_utils.dart
      permissions_helper.dart
      toast_helper.dart
      logger_helper.dart
      api_client.dart
    models/
      user_model.dart
      order_model.dart
    controllers/
      auth_controller.dart
      orders_controller.dart
      pickup_controller.dart
      delivery_controller.dart
      profile_controller.dart
    views/
      splash/
        splash_screen.dart
      auth/
        login_screen.dart
      home/
        home_screen.dart
      widgets/
        bottom_nav.dart
      pickup/
        pickup_list_screen.dart
        pickup_detail_screen.dart
      delivery/
        delivery_list_screen.dart
        delivery_proof_screen.dart
      history/
        history_screen.dart
      profile/
        profile_screen.dart
    widgets/
      app_button.dart
      app_text_field.dart
      status_chip.dart
      order_card.dart
      loading_shimmer.dart
```
