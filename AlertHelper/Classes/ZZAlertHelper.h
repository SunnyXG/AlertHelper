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

@property (nonatomic, strong) UIColor *contentViewColor;
@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIColor *confirmButtonTextColor;
@property (nonatomic, strong) UIColor *cancelButtonTextColor;
@property (nonatomic, strong) UIColor *confirmButtonBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;
@property (nonatomic, strong) UIFont *textFont;

- (ZZAlertHelper * (^)(UIImage *))image;

- (ZZAlertHelper * (^)(NSString *))title;

- (ZZAlertHelper * (^)(void))show;

- (ZZAlertHelper * (^)(NSTimeInterval))delay;

- (ZZAlertHelper * (^)(NSString *))confirmButton;

- (ZZAlertHelper * (^)(NSString *))cancelButton;

- (ZZAlertHelper * (^)(ButtonActionBlock))confirmHandler;

- (ZZAlertHelper * (^)(ButtonActionBlock))cancelHandler;

- (ZZAlertHelper * (^)(UIColor *))cancelTitleColor;

- (ZZAlertHelper * (^)(UIColor *))confirmTitleColor;

- (ZZAlertHelper * (^)(UIColor *))titleColor;

- (ZZAlertHelper * (^)(UIFont *))font;

- (ZZAlertHelper * (^)(UIColor *))confirmBackgroundColor;

- (ZZAlertHelper * (^)(UIColor *))cancelBackgroundColor;

#pragma mark - Functions

/*
 * Configuration alert customized.
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
