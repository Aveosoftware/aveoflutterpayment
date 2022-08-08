# Payment module example

## RazorPay Config:

### ***iOS***
update your Podfile

**Set platform**:
```
platform :ios, '10.0'
```
**Post install**: 
```
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
```
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

```
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