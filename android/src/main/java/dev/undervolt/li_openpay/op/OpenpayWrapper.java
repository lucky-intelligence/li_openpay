package dev.undervolt.li_openpay.op;

import android.app.Activity;

import mx.openpay.android.Openpay;
import mx.openpay.android.OperationCallBack;
import mx.openpay.android.model.Card;
import mx.openpay.android.model.Token;
import mx.openpay.android.validation.CardValidator;


public class OpenpayWrapper {

    private Openpay _openpay;

    public OpenpayWrapper(String merchandId, String publicKey, boolean sandbox){
        this._openpay = new Openpay(merchandId, publicKey, sandbox);
    }

    public String getDeviceSessionID(Activity activity){
        return this._openpay.getDeviceCollectorDefaultImpl().setup(activity);
    }

    public void createCard(String holderName, String cardNumber, int month, int year, String cvv, OperationCallBack<Token> cb){
        Card card = new Card();
        card.holderName(holderName);
        card.cardNumber(cardNumber);
        card.expirationMonth(month);
        card.expirationYear(year);
        card.cvv2(cvv);
        this._openpay.createToken(card, cb);
    }
}
