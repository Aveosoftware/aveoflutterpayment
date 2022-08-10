// Copyright 2022, Aveosoft Pvt Ltd.
// All rights reserved.

part of aveo_flutter_payment;

enum Gateway {
  razorPay,
  stripe,
  inAppPurchase,
}

class AveoFlutterPaymentEvents {
  static const String success = 'success';
  static const String error = 'error';
  static const String wallet = 'wallet';
}

class AveoFlutterPayment {
  final Gateway gateway;
  final Map<String, dynamic>? options;
  final String? key;
  late emit.EventEmitter _eventEmitter;
  final missingKeyErrorResponse = AveoPaymentResponse(
      code: -1, message: 'Key in the options cannot be empty or null!');

  /// should be initialised like this:
  /// ```dart
  /// var pay = AveoFlutterPayment(
  ///    gateway: Gateway.razorPay,
  ///    options: options,
  ///  );
  ///
  /// here options is of type Map<String, dynamic> which will be received from backend.
  /// ```
  AveoFlutterPayment({
    required this.gateway,
    this.options,
    this.key,
  }) {
    _eventEmitter = emit.EventEmitter();
  }

  /// Registers event listeners for payment events
  void on(String event, Function handler) {
    void callBack(event, cont) {
      handler(event.eventData as AveoPaymentResponse);
    }

    emit.EventCallback cb = callBack;
    _eventEmitter.on(event, null, cb);
  }

  /// Opens checkout for selected payment gateway:
  ///
  /// Can be implemented like this:
  /// ```dart
  /// pay..startPayment()
  ///    ..on(AveoFlutterPaymentEvents.success, successHandler)
  ///    ..on(AveoFlutterPaymentEvents.error, errorHandler);
  /// ```
  void startPayment() {
    if (!_isOptionValid()) {
      _eventEmitter.emit(
          AveoFlutterPaymentEvents.error, this, missingKeyErrorResponse);
    } else {
      if (gateway == Gateway.razorPay) {
        var razorPayService = RazorPayService(
          options: options!,
        );
        razorPayService
          ..openCheckout()
          ..on(AveoFlutterPaymentEvents.success, _successHandler)
          ..on(AveoFlutterPaymentEvents.error, _errorHandler);
      }
      if (gateway == Gateway.stripe) {
        stripeService()
          ..stripe(key: key!)
          ..on(AveoFlutterPaymentEvents.success, _successHandler)
          ..on(AveoFlutterPaymentEvents.error, _errorHandler);
      }
    }
  }

  /// Routine to handle successfull payment
  void _successHandler(AveoPaymentResponse response) {
    _eventEmitter.emit(AveoFlutterPaymentEvents.success, this, response);
  }

  /// Routine to handle error in payment process
  void _errorHandler(AveoPaymentResponse response) {
    _eventEmitter.emit(AveoFlutterPaymentEvents.error, this, response);
  }

  //check if the options have key or not
  bool _isOptionValid() {
    bool isValid = false;
    if (options!.containsKey("key")) {
      if ((options!["key"] != null && options!["key"] != "")) {
        isValid = true;
      }
    }
    return isValid;
  }
}
