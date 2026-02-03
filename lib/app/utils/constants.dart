import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get sheetId => dotenv.env['SHEET_ID'] ?? '';
  static String get sheetsApiKey => dotenv.env['SHEETS_API_KEY'] ?? '';
  static String get usersSheetName => dotenv.env['USERS_SHEET_NAME'] ?? 'Users';
  static String get ordersSheetName => dotenv.env['ORDERS_SHEET_NAME'] ?? 'Orders';
  static String get appsScriptBaseUrl => dotenv.env['APPS_SCRIPT_BASE_URL'] ?? '';
  static String get assignedMatchField =>
      dotenv.env['ASSIGNED_MATCH_FIELD'] ?? 'Name';

  static const storageUserKey = 'current_user';
  static const storageSessionKey = 'session_active';

  static const roleDeliveryBoy = 'Delivery Boy';

  static const pickupStatusPicked = 'Picked';
  static const deliveryStatusDelivered = 'Delivered';
}
