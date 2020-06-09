import 'dart:async';

import 'package:flutter/material.dart' as Material;
import 'package:flutter/services.dart';
import 'package:li_openpay/openpay/card.dart';
import 'package:li_openpay/utils/card_validator.dart';

class LiOpenpay {
  
  MethodChannel _channel;

  final String merchantId;
  final String apiKey;
  final bool production;

  LiOpenpay({@Material.required this.merchantId, @Material.required this.apiKey, @Material.required this.production}){
    this._channel = const MethodChannel('li_openpay');
    this._channel.invokeMethod("instance", <String, dynamic> {
      'merchantId': this.merchantId,
      'apiKey': this.apiKey,
      'production': this.production
    });
  }

  Future<String> getDeviceSessionId() async {
    return await this._channel.invokeMethod("deviceSessionId");
  }

  Future<Card> createCard(holderName, cardNumber, expirationMonth, expirationYear, cvv) async {

    String tokenId = await this._channel.invokeMethod("createCard", <String, dynamic> {
      'name': holderName,
      'card': cardNumber,
      'month': expirationMonth,
      'year': expirationYear,
      'cvv': cvv
    });

    return new Card(holderName: holderName, cardNumber: cardNumber, expirationMonth: expirationMonth, expirationYear: expirationYear, cvv: cvv, token: tokenId);
  }
}
