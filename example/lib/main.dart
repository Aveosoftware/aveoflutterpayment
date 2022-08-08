import 'package:aveo_flutter_payment/aveo_flutter_payment.dart';
import 'package:example/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {

  runApp(const MyApp());
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

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pay = AveoFlutterPayment(
      gateway: Gateway.razorPay,
      options: rzrPayOptions,
      key:stripePublishableKey,
    );
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
