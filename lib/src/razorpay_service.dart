// Copyright 2022, Aveosoft Pvt Ltd.
// All rights reserved.

part of aveo_flutter_payment;

class RazorPayService {
  final Razorpay razorPay = Razorpay();
  emit.EventEmitter razorPayServiceEmitter = emit.EventEmitter();
  Map<String, dynamic> options;
  RazorPayService({
    required this.options,
  });

  /// Registers event listeners for payment events
  void on(String event, Function handler) {
    void callBack(event, cont) {
      handler(event.eventData as AveoPaymentResponse);
    }

    emit.EventCallback cb = callBack;
    razorPayServiceEmitter.on(event, null, cb);
  }

  void openCheckout() {
    try {
      razorPay.open(options);
      razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    } catch (e) {
      razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    razorPayServiceEmitter.emit(
      AveoFlutterPaymentEvents.success,
      Gateway.razorPay,
      AveoPaymentResponse(
        response: Resp.success,
        paymentId: "${response.paymentId}",
        signature: "${response.signature}",
        orderId: "${response.orderId}",
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    razorPayServiceEmitter.emit(
      AveoFlutterPaymentEvents.error,
      Gateway.razorPay,
      AveoPaymentResponse(
        response: Resp.error,
        message: "${response.message}",
        code: response.code,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    razorPayServiceEmitter.emit(
      AveoFlutterPaymentEvents.wallet,
      Gateway.razorPay,
      AveoPaymentResponse(
        wallet: "${response.walletName}",
      ),
    );
  }
}
