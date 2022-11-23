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

class InappPurchaseOptions {
  final Package package;
  final String? activePackage;
  final bool isPro;

  InappPurchaseOptions(
      {required this.package, required this.isPro, this.activePackage});
}

class Lineitem {
  final String productId;

  final int quantity;

  Lineitem({required this.productId, required this.quantity});
}

class StripeWebOptions {
  ///this url is required while using StripWeb after Sucessful payment user will be redirected to this path
  final String stripeWebSucessUrl;

  ///this url is required while using StripWeb after Unsucessful payment user will be redirected to this path
  final String stripeWebCancelUrl;

  ///mode of payment eg. 'payment','subscription' or 'setup'
  final String paymentMode;

  final Lineitem lineItem;

  StripeWebOptions({
    required this.stripeWebCancelUrl,
    required this.stripeWebSucessUrl,
    required this.lineItem,
    required this.paymentMode,
  });
}

class AveoFlutterPayment {
  final Gateway gateway;

  ///razorPayOptions should look like below example
  ///
  /// ```json
  /// {
  ///
  ///"key": "your key",
  ///
  ///"amount": 100,//your amount
  ///
  ///"name": "name",
  ///
  ///"description": "Payment",
  ///
  ///"prefill": {"contact": "8888888888", "email": "your email"},
  ///
  ///"external": {
  ///
  ///   "wallets": ["wallets"]
  ///
  ///}
  ///
  ///}
  ///```
  final Map<String, dynamic>? razorPayOptions;

  ///this is required while using inAppPurchase
  final InappPurchaseOptions? inappPurchaseOptions;

  ///this is required while using Stripe.
  final SetupPaymentSheetParameters? stripeOption;

  ///this is required while using stripe.
  final String? stripePublishableKey;

  /// this options is required while using Stripe on Web
  final StripeWebOptions? stripeWebOptions;

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
    this.stripeOption,
    this.razorPayOptions,
    this.inappPurchaseOptions,
    this.stripePublishableKey,
    this.stripeWebOptions,
  }) {
    _eventEmitter = emit.EventEmitter();
  }

  ///[AveoFlutterPayment] needs to be initialized only when using InAppPurchase
  ///
  ///there are 3 steps while using InappPurchase
  ///
  ///1 : initialization of InAppPurchase
  ///
  ///2 : Fatching Avilable offering
  ///
  ///3 : Purchasing a package
  Future<List<String>> init(
      {required String uid, required String revanueCatApiKey}) {
    return InAppPurchaseService()
        .init(uid: uid, revanueCatApiKey: revanueCatApiKey);
  }

  ///this method is only used while using InAppPurchase
  ///
  ///first run  AveoFlutterPayment(gateway: Gateway.inAppPurchase).init();
  ///
  ///only after successfully running above method you will get list of Offerings from revanuecat
  Future<Offerings> fetchPurchase() async {
    return InAppPurchaseService().fetchPurchase();
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
    if (gateway == Gateway.razorPay) {
      if (razorPayOptions == null) {
        AssertionError('razorPayOptions can not be null while using RazorPay');
      } else if (!_isOptionValid()) {
        _eventEmitter.emit(
            AveoFlutterPaymentEvents.error, this, missingKeyErrorResponse);
      } else {
        var razorPayService = RazorPayService(
          options: razorPayOptions!,
        );
        razorPayService
          ..openCheckout()
          ..on(AveoFlutterPaymentEvents.success, _successHandler)
          ..on(AveoFlutterPaymentEvents.error, _errorHandler);
      }
    }
    if (gateway == Gateway.stripe) {
      if (stripeOption == null || stripePublishableKey == null) {
        AssertionError('stripeOption can not be null while using Stripe');
      } else {
        StripeService(
            stripeOptions: stripeOption!, webOptions: stripeWebOptions)
          ..stripe(key: stripePublishableKey!)
          ..on(AveoFlutterPaymentEvents.success, _successHandler)
          ..on(AveoFlutterPaymentEvents.error, _errorHandler);
      }
    }
    if (gateway == Gateway.inAppPurchase) {
      if (inappPurchaseOptions == null) {
        throw AssertionError(
            'inappOption can not be null while using InAppPurchase');
      }
      InAppPurchaseService()
        ..purchase(
            isPro: inappPurchaseOptions!.isPro,
            package: inappPurchaseOptions!.package,
            activePackage: inappPurchaseOptions!.activePackage)
        ..on(AveoFlutterPaymentEvents.success, _successHandler)
        ..on(AveoFlutterPaymentEvents.error, _errorHandler);
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
    if (razorPayOptions!.containsKey("key")) {
      if ((razorPayOptions!["key"] != null && razorPayOptions!["key"] != "")) {
        isValid = true;
      }
    }
    return isValid;
  }
}
