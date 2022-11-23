// Copyright 2022, Aveosoft Pvt Ltd.
// All rights reserved.
library aveo_flutter_payment;

import 'dart:async';
import 'dart:developer';

import 'package:aveo_flutter_payment/src/strip_web.dart' as stripe_web;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
export 'package:flutter_stripe/flutter_stripe.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
export 'package:purchases_flutter/purchases_flutter.dart';
import 'package:eventify/eventify.dart' as emit;
import 'package:stripedart/stripedart.dart' as stripe_BE;

part 'src/start_service.dart';
part 'src/stripe_service.dart';
part 'src/razorpay_service.dart';
part 'src/model/response_model.dart';
part 'src/inapp_purchase_service.dart';
