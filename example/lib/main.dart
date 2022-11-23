import 'package:aveo_flutter_payment/aveo_flutter_payment.dart';
import 'package:example/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
  AveoFlutterPayment(gateway: Gateway.inAppPurchase).init(
      uid: 'UP0X2YxUtpdeiZ4PEU0b1RoptL53',
      revanueCatApiKey: 'goog_cEZXOpzbmXxTOzovtKAoUztPtqT');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment module demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Package package;
  late AveoFlutterPayment pay;

  @override
  void initState() {
    // getOffering().then((value) {

    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment eg')),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          pay = AveoFlutterPayment(
            gateway: Gateway.stripe,
            stripeWebOptions: StripeWebOptions(
                stripeWebCancelUrl: 'http://localhost:49813/#/',
                stripeWebSucessUrl: 'http://localhost:49813/#/',
                lineItem: Lineitem(
                    productId: 'price_1M6wifSE9jF7kJL3vdv1tzmL', quantity: 1),
                paymentMode: 'subscription'),
            stripeOption: SetupPaymentSheetParameters(),
            razorPayOptions: rzrPayOptions,
            stripePublishableKey: stripePublishableKey,
          );
          pay
            ..startPayment()
            ..on(AveoFlutterPaymentEvents.success, successHandler)
            ..on(AveoFlutterPaymentEvents.error, errorHandler);
        },
        child: const Text('Pay'),
      )),
    );
  }

  successHandler(AveoPaymentResponse response) {
    Fluttertoast.showToast(
        backgroundColor: Colors.green.shade400,
        msg: "SUCCESS: ${response.paymentId}",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5);
  }

  errorHandler(AveoPaymentResponse response) {
    Fluttertoast.showToast(
        backgroundColor: Colors.red.shade400,
        msg: "ERROR: code ${response.code} ${response.message}",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5);
  }
}
