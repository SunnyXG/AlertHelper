# AlertHelper

[![CI Status](https://img.shields.io/travis/SunnyXG/AlertHelper.svg?style=flat)](https://travis-ci.org/SunnyXG/AlertHelper)
[![Version](https://img.shields.io/cocoapods/v/AlertHelper.svg?style=flat)](https://cocoapods.org/pods/AlertHelper)
[![License](https://img.shields.io/cocoapods/l/AlertHelper.svg?style=flat)](https://cocoapods.org/pods/AlertHelper)
[![Platform](https://img.shields.io/cocoapods/p/AlertHelper.svg?style=flat)](https://cocoapods.org/pods/AlertHelper)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## How to use

You should import header first

```objective-c
#import "AlertHelper.h"
```

If you want alert some text for tips, pls used

```objective-c
AlertText(self.view).title(@"这是一条提示信息").show();   // it will hide delay 1.5s, replace self.view to your target source view.
```

If you want alert and need operate some thing, pls used

```objective-c
AlertView(self.view).title(@"这是一条提示信息").cancelButton(@"取消").confirmButton(@"确定").cancelHandler(^{ 
}).confirmHandler(^{   
}).show();
```

If you want alert in the window, pls used

```objective-c
AlertTextInWindow().title(@"").show();
```

or 

```
AlertViewInWindow().title(@"")..cancelButton(@"取消").confirmButton(@"确定").cancelHandler(^{ 
}).confirmHandler(^{   
}).show();
```

If you want custom configuration, pls used

```objective-c
AlertText(self.view).title(@"").font([UIFont ..]).titleColor([UIColor ..]).show();  // it have some comtus set, pls use it.
```

 

## Installation

AlertHelper is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AlertHelper'
```

## Author

SunnyXG, zhangx7635093@163.com, if you have any issues and suggest, please email to me, thanks.

## License

AlertHelper is available under the MIT license. See the LICENSE file for more info.
