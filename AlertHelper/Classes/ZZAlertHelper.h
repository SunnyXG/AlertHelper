//
//  ZZAlertHelper.h
//  demo
//
//  Created by zhangxiaoguang on 2018/11/8.
//  Copyright © 2018 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZAlertHelper;

typedef void (^ButtonActionBlock) (void);
typedef void (*HelperConfigurationHandler)(ZZAlertHelper *);

@interface ZZAlertHelper : UIView

@property (nonatomic, strong) UIColor *contentViewColor;   // default is UIColor.whiteColor;
@property (nonatomic, strong) UIColor *titleTextColor;     // default is UIColor.blackColor;
@property (nonatomic, strong) UIColor *messageTextColor;   // default is UIColor.whiteColor;
@property (nonatomic, strong) UIColor *confirmButtonTextColor;  // default is RGB(250, 98, 27);
@property (nonatomic, strong) UIColor *cancelButtonTextColor;   // default is RGB(102, 102, 102);
@property (nonatomic, strong) UIColor *confirmButtonBackgroundColor;  // default is RGB(151, 151, 151);
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;   // default is UIColor.whiteColor;
@property (nonatomic, strong) UIFont *textFont;   // default is 17.0pt;
@property (nonatomic, strong) UIFont *messageTextFont;  // default is 16.00pt;
@property (nonatomic, strong) UIFont *buttonTextFont;   // default is 17.00pt;


- (ZZAlertHelper * (^)(UIImage *))image;

- (ZZAlertHelper * (^)(NSString *))title;

- (ZZAlertHelper * (^)(NSString *))message;

- (ZZAlertHelper * (^)(void))show;

- (ZZAlertHelper * (^)(NSTimeInterval))delay;

- (ZZAlertHelper * (^)(NSString *))confirmButton;

- (ZZAlertHelper * (^)(NSString *))cancelButton;

- (ZZAlertHelper * (^)(ButtonActionBlock))confirmHandler;

- (ZZAlertHelper * (^)(ButtonActionBlock))cancelHandler;

- (ZZAlertHelper * (^)(ButtonActionBlock))dismissHandler;

- (ZZAlertHelper * (^)(UIColor *))cancelTitleColor;

- (ZZAlertHelper * (^)(UIColor *))confirmTitleColor;

- (ZZAlertHelper * (^)(UIColor *))titleColor;

- (ZZAlertHelper * (^)(UIColor *))messageColor;

- (ZZAlertHelper * (^)(UIFont *))font;

- (ZZAlertHelper * (^)(UIFont *))messageFont;

- (ZZAlertHelper * (^)(UIFont *))buttonFont;

- (ZZAlertHelper * (^)(UIColor *))confirmBackgroundColor;

- (ZZAlertHelper * (^)(UIColor *))cancelBackgroundColor;

#pragma mark - Functions

/*
 * Configuration alert customized.
 *
 * demo
 *
 * void CustomConfigurationForAlertHelper(ZZAlertHelper *alertHelper);
 *
 * @interface ExampleClass()
 * @end
 *
 * @implementation ExampleClass
 
 * call this function at app launch<AppDelegate.m> or at the global app preference.
 * - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 * {
 *   SetupZZAlertHelperConfiguration(CustomConfigurationForAlertHelper);
 *
 *   return YES.
 * }
 *
 * //  setup custom config at here.
 * void CustomConfigurationForAlertHelper(ZZAlertHelper *alertHelper)
 * {
 *   alertHelper.titleLabelTextColor = [UIColor blackColor];
 *   alertHelper.textFont = [UIFont boldSystemFontOfSize:17];
 * }
 *
 * @end
 */
void SetupZZAlertHelperConfiguration(HelperConfigurationHandler handle);

/*
 * The alert view init and add to source view.
 * AlertText() | AlertTextInWindow() : alert hided delay 1.5s, when you want alert some message(ex:error meassge), used it!;
 * AlertView() | AlertViewInWindow() : if you want to operate some action, used it!.
 */
ZZAlertHelper * AlertText(UIView *view);
ZZAlertHelper * AlertView(UIView *view);
ZZAlertHelper * AlertTextInWindow(void);
ZZAlertHelper * AlertViewInWindow(void);

void AlertHide(UIView *sourceView);
void AlertHideInWindow(void);

@end

NS_ASSUME_NONNULL_END
