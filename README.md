# AveoFlutterPayment
 Aveopayment helps to simplify the payment integration process.
Configuring Payment module inside your app can be very lengthy process. For implementing below payment methods it can take you upto 40-50 hrs, but by using AveoflutterPayment it will come down to just 1 hr. 
- [RazorPay Config : ](#razorpay-config)
  - [ANDROID](#android)
  - [IOS](#ios)
  
- [Stripe Config](#stripe-config)
  - [ANDROID](#android-1)
  - [IOS](#ios-1)
- [Inapp Purchases Config](#inapppurchase-config)
  - [ANDROID](#android-2)
  - [IOS](#ios-2)
- [Implementation Examples](#implementation-examples)
  - [Stripe](#stripe)
  - [RazorPay](#razorpay)
  - [Inapp Purchase](#inapppurchase)
- [Why to use](#why-to-use)


## RazorPay Config:

### ***iOS***
update your Podfile

**Set platform**:
```
platform :ios, '10.0'
```
**Post install**: 
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
          config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
  end
end
```
### ***Android***
```groovy
example/android/app/build.gradle:        
 android {  
  .
  .
                                                                                     
   defaultConfig {                                                                             
     minSdkVersion 19                                                                          
   }
  .
  .
}                                                                                           
```

## Stripe Config:

### ***Android***

```groovy
example/android/app/build.gradle:        
 android {  
  .
  .
                                                                                     
   defaultConfig {                                                                             
     minSdkVersion 21                                                                          
   }
  .
  .
}                                                                                           
```

### ***iOS***
add NSCameraUsageDescription in info.plist as Stripe requires it and it is not mentioned in Stripe's documentation



## InAppPurchase Config
AveoFlutterPayment is powered by RavenueCat.So for Ravenuecat dashboard configration please refer their documentation.
### [Ravenuecat Documentation](https://www.revenuecat.com/docs/getting-started-1#section-configure-purchases)

go to the above link and setup ravenuecat account and dashboard. add your Products and Entitlements there.
### ***Android***
add the following permission inside your AndroidManifest.xml

```xml
 <uses-permission android:name="com.android.vending.BILLING" />

    <uses-permission android:name="android.permission.INTERNET" />
```


### ***iOS***
add InappPurchase capability in your project.

## Implementation Examples

### RazorPay
```dart
AveoFlutterPayment pay = AveoFlutterPayment(
        gateway: Gateway.razorPay,
        razorPayOptions: rzrPayOptions,
      );

    pay
        ..startPayment()
        ..on(AveoFlutterPaymentEvents.success, successHandler)
        ..on(AveoFlutterPaymentEvents.error, errorHandler);

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
            
```

### Stripe
```dart
 AveoFlutterPayment pay = AveoFlutterPayment(
        gateway: Gateway.stripe,
        stripeOption: SetupPaymentSheetParameters(),
        stripePublishableKey: stripePublishableKey,
      );

    pay
        ..startPayment()
        ..on(AveoFlutterPaymentEvents.success, successHandler)
        ..on(AveoFlutterPaymentEvents.error, errorHandler);

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
```

### InAppPurchase
```dart
/// there are three steps while using inAppPurchase 

/// 1st
  AveoFlutterPayment(gateway: Gateway.inAppPurchase).init(
      uid:  '<UID>',
      revanueCatApiKey: '<YOUR_KEY>');

///2nd
/// this method will fatch all the puchases available on ravanuecat
  Offerings offerings = AveoFlutterPayment(gateway: Gateway.inAppPurchase.fetchPurchase();
/// you need to select a perticular package to purchase from above offering

///3rd
  AveoFlutterPayment pay = AveoFlutterPayment(
        gateway: Gateway.inAppPurchase,
        inappPurchaseOptions:
            InappPurchaseOptions(isPro: isPro, package: your package),
      );

    pay
        ..startPayment()
        ..on(AveoFlutterPaymentEvents.success, successHandler)
        ..on(AveoFlutterPaymentEvents.error, errorHandler);

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

```

### Why to Use
- Integrating payment interface in your app can be hard and time consuming if not done properly. 
- While integrating payment module in your app you will always end up writing boilerplate code here and there but by using AveoPayment you will save your self from this.
