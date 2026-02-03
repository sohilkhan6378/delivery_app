import 'package:logger/logger.dart';

class LoggerHelper {
  static late Logger logger;

  static void init() {
    logger = Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
      ),
    );
  }
}
