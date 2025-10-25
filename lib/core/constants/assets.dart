/// Centralized asset constants
/// Easy to swap emoji placeholders with real images later
class BrandAssets {
  BrandAssets._();

  // Brand product images (emoji placeholders - replace with actual URLs later)
  static const String starbucks = '☕'; // 'assets/brands/starbucks.png'
  static const String mcdonalds = '🍔'; // 'assets/brands/mcdonalds.png'
  static const String cgv = '🎬'; // 'assets/brands/cgv.png'
  static const String yes24 = '📚'; // 'assets/brands/yes24.png'
  static const String gs25 = '🍿'; // 'assets/brands/gs25.png'
  static const String subway = '🥪'; // 'assets/brands/subway.png'
}

class GameAssets {
  GameAssets._();

  // Game icons (emoji placeholders)
  static const String basketball = '🏀';
  static const String trophy = '🏆';
  static const String coin = '🪙';
  static const String fire = '🔥';
  static const String star = '⭐';
}

class IconAssets {
  IconAssets._();

  // Common icons
  static const String party = '🎉';
  static const String sad = '😔';
  static const String money = '💰';
  static const String piggyBank = '🐷';
}

/// Extended asset constants for categories and UI
class Assets {
  Assets._();

  // JAR CATEGORY EMOJIS
  static const String jarVacation = '✈️';
  static const String jarEmergency = '🚨';
  static const String jarEducation = '📚';
  static const String jarHome = '🏠';
  static const String jarElectronics = '📱';
  static const String jarGeneral = '💰';
  static const String jarSavings = '🐷';

  // PRODUCT CATEGORY EMOJIS
  static const String productElectronics = '📱';
  static const String productFashion = '👕';
  static const String productFood = '🍔';
  static const String productTravel = '✈️';
  static const String productEntertainment = '🎮';
  static const String productHealth = '💪';

  // UI EMOJIS
  static const String success = '🎉';
  static const String error = '😔';
  static const String warning = '⚠️';
  static const String empty = '🫙';
  static const String lock = '🔒';

  /// Get jar emoji by category
  static String getJarEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'vacation':
      case 'travel':
        return jarVacation;
      case 'emergency':
        return jarEmergency;
      case 'education':
        return jarEducation;
      case 'home':
        return jarHome;
      case 'electronics':
        return jarElectronics;
      case 'savings':
        return jarSavings;
      default:
        return jarGeneral;
    }
  }
}
