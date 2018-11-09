//
//  AlertHelper.h
//  demo
//
//  Created by zhangxiaoguang on 2018/11/8.
//  Copyright © 2018 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AlertHelper;

typedef void (^ButtonActionBlock) (void);
typedef void (*HelperConfigurationHandler)(AlertHelper *);

@interface AlertHelper : UIView

@property (nonatomic, strong) UIColor *contentViewColor;
@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIColor *confirmButtonTextColor;
@property (nonatomic, strong) UIColor *cancelButtonTextColor;
@property (nonatomic, strong) UIColor *confirmButtonBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;
@property (nonatomic, strong) UIFont *textFont;

- (AlertHelper * (^)(UIImage *))image;

- (AlertHelper * (^)(NSString *))title;

- (AlertHelper * (^)(void))show;

- (AlertHelper * (^)(NSTimeInterval))delay;

- (AlertHelper * (^)(NSString *))confirmButton;

- (AlertHelper * (^)(NSString *))cancelButton;

- (AlertHelper * (^)(ButtonActionBlock))confirmHandler;

- (AlertHelper * (^)(ButtonActionBlock))cancelHandler;

- (AlertHelper * (^)(UIColor *))cancelTitleColor;

- (AlertHelper * (^)(UIColor *))confirmTitleColor;

- (AlertHelper * (^)(UIColor *))titleColor;

- (AlertHelper * (^)(UIFont *))font;

- (AlertHelper * (^)(UIColor *))confirmBackgroundColor;

- (AlertHelper * (^)(UIColor *))cancelBackgroundColor;

#pragma mark - Functions

/*
 * Configuration alert customized.
 */
void SetupAlertHelperConfiguration(HelperConfigurationHandler handle);

/*
 * The alert view init and add to source view.
 * AlertText() | AlertTextInWindow() : alert hided delay 1.5s, when you want alert some message(ex:error meassge), used it!;
 * AlertView() | AlertViewInWindow() : if you want to operate some action, used it!.
 */
AlertHelper * AlertText(UIView *view);
AlertHelper * AlertView(UIView *view);
AlertHelper * AlertTextInWindow(void);
AlertHelper * AlertViewInWindow(void);

void AlertHide(UIView *sourceView);
void AlertHideInWindow(void);

@end

NS_ASSUME_NONNULL_END
