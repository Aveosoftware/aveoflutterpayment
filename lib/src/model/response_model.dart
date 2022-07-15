// ignore_for_file: public_member_api_docs, sort_constructors_first
// Copyright 2022, Aveosoft Pvt Ltd.
// All rights reserved.

part of aveo_flutter_payment;

enum Resp {
  success,
  error,
}

class AveoPaymentResponse {
  Resp? response;
  String? paymentId;
  String? signature;
  String? wallet;
  String? message;
  String? orderId;
  int? code;
  AveoPaymentResponse({
    this.response,
    this.paymentId,
    this.signature,
    this.wallet,
    this.message,
    this.orderId,
    this.code,
  });
}
