package com.adobe.cairngorm.samples.store.business
{
  public class CreditCardDelegateMock extends BaseBusinessDelegateMock implements ICreditCardDelegate
  {
    public function CreditCardDelegateMock(){
      super();
    }

    public function validateCreditCard( cardholderName : String, cardNumber : String ) : void
    {
      setResults(true); //we just want it to work :)
    }
  }
}
