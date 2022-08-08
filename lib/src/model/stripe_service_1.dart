// part of aveo_flutter_payment;
//
// class StripeTransactionResponse {
//   String message;
//   bool success;
//   StripeTransactionResponse({required this.message, required this.success});
// }
//
// class StripeService {
//   static String apiBase = 'https://api.stripe.com/v1';
//   static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
//   static String secret =
//       'YOUR SECRET';
//   static Map<String, String> headers = {
//     'Authorization': 'Bearer ${StripeService.secret}',
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };
//   static init() async{
//     Stripe.publishableKey = key;
//     Stripe.merchantIdentifier = 'any string works';
//     await Stripe.instance.applySettings();
//   }
//
//   static Future<StripeTransactionResponse> payViaExistingCard(
//       {String amount, required String currency, CreditCard card}) async {
//     try {
//       var paymentMethod = await StripePayment.createPaymentMethod(PaymentMethodRequest(card: card));
//       var paymentIntent = await StripeService.createPaymentIntent(amount, currency);
//       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
//           clientSecret: paymentIntent['client_secret'], paymentMethodId: paymentMethod.id));
//       if (response.status == 'succeeded') {
//         return new StripeTransactionResponse(message: 'Transaction successful', success: true);
//       } else {
//         return new StripeTransactionResponse(message: 'Transaction failed', success: false);
//       }
//     } on PlatformException catch (err) {
//       return StripeService.getPlatformExceptionErrorResult(err);
//     } catch (err) {
//       return new StripeTransactionResponse(
//           message: 'Transaction failed: ${err.toString()}', success: false);
//     }
//   }
//
//   static Future<StripeTransactionResponse> payWithNewCard({String amount, String currency}) async {
//     try {
//       var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
//       var paymentIntent = await StripeService.createPaymentIntent(amount, currency);
//       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
//           clientSecret: paymentIntent['client_secret'], paymentMethodId: paymentMethod.id));
//       if (response.status == 'succeeded') {
//         return new StripeTransactionResponse(message: 'Transaction successful', success: true);
//       } else {
//         return new StripeTransactionResponse(message: 'Transaction failed', success: false);
//       }
//     } on PlatformException catch (err) {
//       return StripeService.getPlatformExceptionErrorResult(err);
//     } catch (err) {
//       return new StripeTransactionResponse(
//           message: 'Transaction failed: ${err.toString()}', success: false);
//     }
//   }
//
//   static getPlatformExceptionErrorResult(err) {
//     String message = 'Something went wrong';
//     if (err.code == 'cancelled') {
//       message = 'Transaction cancelled';
//     }
//
//     return new StripeTransactionResponse(message: message, success: false);
//   }
//
//   static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       var response =
//       await http.post(StripeService.paymentApiUrl, body: body, headers: StripeService.headers);
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//     return null;
//   }
// }