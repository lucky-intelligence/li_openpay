import 'package:flutter/material.dart';

class Card {
  String holderName;
  String cardNumber;
  int expirationMonth;
  int expirationYear;
  String cvv;
  String token;

  Card({
    @required this.holderName,
    @required this.cardNumber, 
    @required this.expirationMonth, 
    @required this.expirationYear, 
    @required this.cvv, 
    @required this.token});

}