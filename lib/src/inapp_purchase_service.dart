part of aveo_flutter_payment;

class InAppPurchaseService {
  emit.EventEmitter inappPurchaseEmitter = emit.EventEmitter();

  void on(String event, Function handler) {
    void callBack(event, cont) {
      handler(event.eventData as AveoPaymentResponse);
    }

    emit.EventCallback cb = callBack;
    inappPurchaseEmitter.on(event, null, cb);
  }

  Future<List<String>> init(
      {required String uid, required String revanueCatApiKey}) async {
    try {
      Completer<List<String>> plan = Completer();
      await Purchases.setDebugLogsEnabled(true);

      await Purchases.configure(
              PurchasesConfiguration(revanueCatApiKey)..appUserID = uid)
          .then((value) async {
        // LogInResult purchaseLoginData = await Purchases.logIn(uid);
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        List<String> activePlanList = customerInfo.activeSubscriptions;
        log(customerInfo.allExpirationDates.toString());
        log(customerInfo.latestExpirationDate.toString());
        plan.complete(activePlanList);
      });

      return plan.future;
    } catch (e) {
      rethrow;
    }
  }

  Future<Offerings> fetchPurchase() async {
    return await Purchases.getOfferings();
  }

  Future purchase(
      {required Package package,
      String? activePackage,
      required bool isPro}) async {
    // var pref = await SharedPreferences.getInstance();
    // bool _isProUser = activePackage != 'isFree';
    bool _isProUser = isPro;
    try {
      CustomerInfo purchaserInfo;
      if (_isProUser) {
        purchaserInfo = await Purchases.purchasePackage(package,
            upgradeInfo: UpgradeInfo(activePackage!,
                prorationMode: ProrationMode.immediateAndChargeProratedPrice));
        if (purchaserInfo.allPurchasedProductIdentifiers
            .contains(package.identifier)) {
          inappPurchaseEmitter.emit(
            AveoFlutterPaymentEvents.success,
            Gateway.inAppPurchase,
            AveoPaymentResponse(
              response: Resp.success,
              message: 'Purachase Succesfull',
              code: 200,
            ),
          );
        }
      } else {
        purchaserInfo = await Purchases.purchasePackage(package).then((value) {
          if (value.allPurchasedProductIdentifiers
              .contains(package.identifier)) {
            inappPurchaseEmitter.emit(
              AveoFlutterPaymentEvents.success,
              Gateway.inAppPurchase,
              AveoPaymentResponse(
                response: Resp.success,
                message: 'Purchase Succesfull',
                code: 200,
              ),
            );
          }
          return value;
        });
      }
      // String? purchasedId = purchaserInfo.activeSubscriptions.first;
      // var isPro =
      //     purchaserInfo.entitlements.all["drone_pro"]?.isActive ?? false;
      // // pref.setString('isPro', purchasedId);
      // if (isPro) {
      //   _isProUser = isPro;
      //   // _isRestored = false;
      //   purchasedId =
      //       purchaserInfo.entitlements.active['drone_pro']?.productIdentifier ??
      //           '';
      //   // var pref = await SharedPreferences.getInstance();
      //   // pref.setString('isPro', purchasedId);
      //   // return ProModes.fromString(purchasedId);
      //   // _callProStatusChangedListeners();
      // } else {
      //   // pref.setString('isPro', 'isFree');
      // }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      String getErrorMsg() {
        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
          return "User cancelled";
        } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
          return "User not allowed to purchase";
        } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
          return "Payment is pending";
        } else {
          return 'Unknown error';
        }
      }

      inappPurchaseEmitter.emit(
        AveoFlutterPaymentEvents.error,
        Gateway.inAppPurchase,
        AveoPaymentResponse(
          response: Resp.error,
          message: getErrorMsg(),
          code: 400,
        ),
      );
    }
  }
}
