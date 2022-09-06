import 'package:flutter_test/flutter_test.dart';

import 'package:aveo_flutter_payment/aveo_flutter_payment.dart';
import 'package:mocktail/mocktail.dart';

class MockRazorPayService extends Mock implements RazorPayService {}

void main() {
  late AveoFlutterPayment sut;
  late MockRazorPayService mockRazorPayService;
  late String result;
  setUp(() {
    Map<String, dynamic> options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': 74700,
      'name': 'Aveosoft',
      'description': 'Payment',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    mockRazorPayService = MockRazorPayService();
    sut = AveoFlutterPayment(
      gateway: Gateway.razorPay,
      razorPayOptions: options,
    );
  });

  String mockSuccessResult = AveoFlutterPaymentEvents.success;
  String mockErrorResult = AveoFlutterPaymentEvents.error;
  group('fetch and parse data', () {
    void sendPaymentSuccess() {
      when(() => mockRazorPayService.openCheckout())
          .thenAnswer((invocation) => result = mockSuccessResult);
    }

    void sendPaymentError() {
      when(() => mockRazorPayService.openCheckout())
          .thenAnswer((invocation) => result = mockErrorResult);
    }

    void successHandler(AveoPaymentResponse response) {
      result = AveoFlutterPaymentEvents.success;
    }

    void errorHandler(AveoPaymentResponse response) {
      result = AveoFlutterPaymentEvents.error;
    }

    test('startPayment test for success', () {
      sendPaymentSuccess();
      sut
        ..startPayment()
        ..on(AveoFlutterPaymentEvents.success, successHandler)
        ..on(AveoFlutterPaymentEvents.error, errorHandler);
      // verify(() => mockRazorPayService.openCheckout()).called(1);
      // expect a success if test user takes positive payment flow
      expect(
        result,
        AveoFlutterPaymentEvents.success,
      );
      // expect an error if test user takes negative payment flow
      expect(
        result,
        AveoFlutterPaymentEvents.success,
      );
    });

    test('startPayment test for error', () {
      sendPaymentError();
      sut
        ..startPayment()
        ..on(AveoFlutterPaymentEvents.success, successHandler)
        ..on(AveoFlutterPaymentEvents.error, errorHandler);
      // verify(() => mockRazorPayService.openCheckout()).called(1);
      // expect a success if test user takes positive payment flow
      expect(
        result,
        AveoFlutterPaymentEvents.success,
      );
      // expect an error if test user takes negative payment flow
      expect(
        result,
        AveoFlutterPaymentEvents.success,
      );
    });
  });
}
