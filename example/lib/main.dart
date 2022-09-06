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
  Future<void> getOffering() async {
    Offerings offerings =
        await AveoFlutterPayment(gateway: Gateway.inAppPurchase)
            .fetchPurchase();
    package = offerings.all.entries.first.value.monthly!;
  }

  @override
  void initState() {
    getOffering().then((value) {
      pay = AveoFlutterPayment(
        gateway: Gateway.inAppPurchase,
        stripeOption: SetupPaymentSheetParameters(),
        inappPurchaseOptions:
            InappPurchaseOptions(isPro: false, package: package),
        razorPayOptions: rzrPayOptions,
        stripePublishableKey: stripePublishableKey,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment eg')),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
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
