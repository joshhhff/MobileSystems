import 'package:intl/intl.dart';

class CommonTools {
    // returns ISO timestamp - 2025-02-05T20:24:06.907888
    String getTimestamp() {
        return DateTime.now().toIso8601String();
    }

    // returns user friendly date - 5 February 2025
    String getFormattedDate() {
        return DateFormat('d MMMM y').format(DateTime.now());
    }

    // returns user friendly time - 20:24
    String getCurrentTime() {
        return DateFormat('HH:mm').format(DateTime.now());
    }

    double convertToMl(double value, String unit) {
        switch (unit.toLowerCase()) {
            case 'litre':
                return value * 1000; // 1 L = 1000 ml
            case 'pint':
                return value * 568.261; // 1 UK pint = 568.261 ml
            case 'ml':
                return value; // Already in ml
            default:
                return 0.0;
        }
    }

    double calculateProgressPercentage(double goal, String goalUnit, double logged, String loggedUnit) {
        double goalInMl = convertToMl(goal, goalUnit);
        double loggedInMl = convertToMl(logged, loggedUnit);

        return (loggedInMl / goalInMl) * 100; // Returns progress as a percentage
    }

    double convertToPreferredUnit(double value, String unit) {
        switch (unit.toLowerCase()) {
            case 'litre':
                return value / 1000; // 1 L = 1000 ml
            case 'pint':
                return value / 568.261; // 1 UK pint = 568.261 ml
            case 'ml':
                return value; // Already in ml
            default:
                return 0.0;
        }
    }
}