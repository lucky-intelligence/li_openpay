import 'dart:async';

import 'package:flutter/material.dart' as Material;
import 'package:flutter/services.dart';
import 'package:li_openpay/openpay/card.dart';

class LiOpenpay {
  
  MethodChannel _channel;

  final String merchantId;
  final String publicKey;
  final bool sandbox;

  LiOpenpay({@Material.required this.merchantId, @Material.required this.publicKey, @Material.required this.sandbox}){
    this._channel = const MethodChannel('li_openpay');
    this._channel.invokeMethod("instance", <String, dynamic> {
      'merchantId': this.merchantId,
      'publicKey': this.publicKey,
      'sandbox': this.sandbox
    });
  }

  Future<String> getDeviceSessionId() async {
    return await this._channel.invokeMethod("deviceSessionId");
  }

  Future<Card> createCard(holderName, cardNumber, expirationMonth, expirationYear, cvv) async {
    final String tokenId = await this._channel.invokeMethod("createCard", <String, dynamic> {
      'name': holderName,
      'card': cardNumber,
      'month': expirationMonth,
      'year': expirationYear,
      'cvv': cvv
    });

    return new Card(holderName: holderName, cardNumber: cardNumber, expirationMonth: expirationMonth, expirationYear: expirationYear, cvv: cvv, token: tokenId);
  }

  
}
