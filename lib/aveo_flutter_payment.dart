// Copyright 2022, Aveosoft Pvt Ltd.
// All rights reserved.
library aveo_flutter_payment;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:eventify/eventify.dart' as emit;
import 'package:http/http.dart' as http;
import 'package:stripedart/stripedart.dart' as stripe_BE;

part 'src/start_service.dart';
part 'src/stripe_service.dart';
// part 'src/model/stripe_service_1.dart';
part 'src/razorpay_service.dart';
part 'src/model/response_model.dart';
// part 'src/methods/on_call_back.dart';
