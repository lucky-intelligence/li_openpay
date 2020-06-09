import 'package:intl/intl.dart';

class CardValidator {
  
  static bool validateCard(String holderName, String cardNumber, int expMonth, int expYear, String cvv) {
    return validateHolderName(holderName) && validateCVV(cvv, cardNumber) && validateExpiryDate(expMonth, expYear) && validateNumber(cardNumber);
  }

  static bool validateHolderName(String holderName) {
    return holderName != null && holderName.trim().length > 0;
  }

  static bool validateCVV(String cvv, String cardNumber) {
    return cvv != null && cvv.trim().length != 0;
  }

  static bool validateExpiryDate(int expirationMonth, int expirationYear) {
    if (!validateMonth(expirationMonth)) {
      return false;
    } else if (expirationYear == null) {
      return false;
    } else {
      DateTime now = DateTime.now();
      DateFormat dateFormat = new DateFormat("MM-yy");
      DateTime expirationDate = dateFormat.parse("$expirationMonth-$expirationYear");
      return now.isAfter(expirationDate);
    }
  }

  static bool validateMonth(int month) {
    if (month == null) {
      return false;
    } else {
      return month >= 1 && month <= 12;
    }
  }

  static bool validateNumber(String number) {
    if (number != null && number.trim().length != 0) {
      return passesLuhnTest(number);
    } else {
      return false;
    }
  }

  static bool startsWith(String cardNumber, List<String> prefixes) {      
    int var3 = prefixes.length;

    for(int var4 = 0; var4 < var3; ++var4) {
      String prefix = prefixes[var4];
      if (cardNumber.startsWith(prefix)) {
        return true;
      }
    }

    return false;
  }

  static CardType getType(String cardNumber) {
    if (cardNumber != null && cardNumber.trim().length > 0) {
      if (startsWith(cardNumber, ["34", "37"])) {
        return CardType.AMEX;
      }

      if (startsWith(cardNumber, ["4"])) {
        return CardType.VISA;
      }

      if (startsWith(cardNumber, ["51", "52", "53", "54", "55"])) {
        return CardType.MASTERCARD;
      }
    }
    return CardType.UNKNOWN;
  }

  static bool passesLuhnTest(String value) {
    List<String> chars = value.split("");        
    List<int> digits = new List();
    List<String> var3 = chars;
    int sum = chars.length;

    for(int var5 = 0; var5 < sum; ++var5) {
      String c = var3[var5];
      
      if (int.parse(c) != null) {
        digits.add(int.parse(c) - 48);
      }
    }

    int length = digits.length;
    sum = 0;
    bool even = false;

    for(int index = length - 1; index >= 0; --index) {
      int digit = digits[index];
      if (even) {
        digit *= 2;
      }

      if (digit > 9) {
        digit = (digit / 10 + digit % 10).round();
      }

      sum += digit;
      even = !even;
    }
    return sum % 10 == 0;
  }
}

enum CardType {
  AMEX, VISA, MASTERCARD, UNKNOWN
}