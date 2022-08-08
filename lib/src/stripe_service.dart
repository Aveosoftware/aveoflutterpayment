// // Copyright 2022, Aveosoft Pvt Ltd.
// // All rights reserved.
part of aveo_flutter_payment;

Future<String> createPaymentIntent() async {
  try {
    String client_secret =
        'sk_test_51LIseNSGudWBU43posDnmoPiPtnzYiQRt5z7JzNidEVR4qcO81fFZIup8o00OmKStzF4b7m5qK7MMaCR4qAjN6Hk00XsJDCcFZ';
    var stripeBE = stripe_BE.Stripe(client_secret);

    var result = await stripeBE.core.paymentIntents!.create(
        params: {'amount': '5599', 'currency': 'inr'});
    if (result != null) {
      return result['client_secret'];
    } else
      return '';
  } catch (err) {
    print('err charging user: ${err.toString()}');
    return err.toString();
  }
}

void stripe({required String key}) async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = key;
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();
  String secret = await createPaymentIntent();
  await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: secret,
        merchantDisplayName: 'Aveosoft Stripe Demo',
        customerId: 'customer',
        customerEphemeralKeySecret: 'ephemeralKey',
        style: ThemeMode.dark,
        testEnv: true,
        merchantCountryCode: 'IN',

      ),
  );
  await Stripe.instance.presentPaymentSheet();
  secret = '';
}
