//
//  ZZAlertHelper.m
//  demo
//
//  Created by zhangxiaoguang on 2018/11/8.
//  Copyright © 2018 -. All rights reserved.
//

#import "ZZAlertHelper.h"
#import <MasonryFlow/Masonry.h>
#import "CustomLabel.h"

#define kAlertImageHeight   40
#define kAlertMargin    20

static HelperConfigurationHandler configHandler;
@interface ZZAlertHelper ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CustomLabel *titleLabel;
@property (nonatomic, strong) CustomLabel *subtitleLabel;
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, assign) NSTimeInterval delayTime;
@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, copy) ButtonActionBlock confirmHandleBlock;
@property (nonatomic, copy) ButtonActionBlock cancelHandleBlock;
@property (nonatomic, copy) ButtonActionBlock dismissHandleBlock;

@property (nonatomic, assign) CGFloat contentViewWidth;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign) CGFloat subtitleLabelHeight;

@property (nonatomic, assign) BOOL isHasTitle;   // is the alert has title.

@end

@implementation ZZAlertHelper

- (instancetype)initWithSourceView:(UIView *)sourceView delay:(NSTimeInterval)delayTime
{
    if (self = [super init]) {
        if (sourceView != nil) {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            self.delayTime = delayTime;
            self.sourceView = sourceView;
            
            if (configHandler) {
                configHandler(self);
            }
            
            [self.sourceView addSubview:self];
        }
    }
    
    return self;
}

#pragma mark - Actions

- (void)confirmButtonTapped:(id)sender
{
    if (self.confirmHandleBlock) {
        self.confirmHandleBlock();
    }
    
    [self _hideViewFromSourceView];
}

- (void)cancelButtonTapped:(id)sender
{
    if (self.cancelHandleBlock) {
        self.cancelHandleBlock();
    }
    
    [self _hideViewFromSourceView];
}

#pragma mark - Public

ZZAlertHelper * AlertText(UIView *view)
{
    return [[ZZAlertHelper alloc] initWithSourceView:view delay:2.0];
}

ZZAlertHelper * AlertView(UIView *view)
{
    return [[ZZAlertHelper alloc] initWithSourceView:view delay:0];
}

ZZAlertHelper * AlertTextInWindow()
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    return [[ZZAlertHelper alloc] initWithSourceView:keyWindow delay:2.0];;
}

ZZAlertHelper * AlertViewInWindow()
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    return [[ZZAlertHelper alloc] initWithSourceView:keyWindow delay:0];
}

void AlertHide(UIView *sourceView)
{
    for (UIView *view in sourceView.subviews) {
        if ([view isKindOfClass:[ZZAlertHelper class]]) {
            [UIView animateWithDuration:0.2
                             animations:^{
                [view removeFromSuperview];
            }];
        }
    }
}

void AlertHideInWindow(void)
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    for (UIView *view in keyWindow.subviews) {
        if ([view isKindOfClass:[ZZAlertHelper class]]) {
            [UIView animateWithDuration:0.2
                             animations:^{
                [view removeFromSuperview];
            }];
        }
    }
}

// --------------------------

-(ZZAlertHelper * (^)(void))show
{
    return ^(){
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.sourceView);
        }];
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.imageView.image) {
                make.height.equalTo(@(kAlertMargin + kAlertImageHeight + self.titleLabelHeight + self.subtitleLabelHeight));
            } else {
                make.height.equalTo(@(self.titleLabelHeight + self.subtitleLabelHeight));
            }
        }];
        
        [self layoutIfNeeded];
        
        SetViewEdgeBorder(self.subtitleLabel.text ? self.subtitleLabel : self.titleLabel, UIRectEdgeBottom);
        if (self.delayTime > 0) {
            SetRoundedCorners(self.contentView, UIRectCornerAllCorners, CGSizeMake(6, 6));
        } else {
            SetRoundedCorners(self.contentView, UIRectCornerTopLeft | UIRectCornerTopRight, CGSizeMake(4, 4));
        }
        
        return self;
    };
}

-(ZZAlertHelper * (^)(NSTimeInterval))delay
{
    return ^(NSTimeInterval delay) {
        self.delayTime = delay;
        return self;
    };
}

- (ZZAlertHelper * (^)(UIImage *))image
{
    return ^(UIImage *image) {
        self.imageView.image = image;
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kAlertMargin);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.height.equalTo(@(kAlertImageHeight));
        }];

        return self;
    };
}

- (ZZAlertHelper * (^)(NSString *))title
{
     return ^(NSString *title){
         self.titleLabel.text = title;
         self.isHasTitle = YES;
         
         [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.imageView.mas_bottom);
             make.centerX.equalTo(self.contentView.mas_centerX);
             make.width.equalTo(@(self.contentViewWidth));
             make.height.equalTo(@(self.titleLabelHeight));
         }];

        return self;
    };
}

- (ZZAlertHelper * (^)(NSString *))message
{
    return ^(NSString *message){
        self.subtitleLabel.text = message;
        
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@(self.contentViewWidth));
            make.height.equalTo(@(self.subtitleLabelHeight));
        }];

        return self;
    };
}

- (ZZAlertHelper * (^)(NSString *))confirmButton
{
    return ^(NSString *str) {
        [self.btnConfirm setTitle:str forState:UIControlStateNormal];
        
        [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@40);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
        }];
        
        [self layoutIfNeeded];
        SetRoundedCorners(self.btnConfirm, UIRectCornerBottomRight, CGSizeMake(4, 4));

        return self;
    };
}

- (ZZAlertHelper * (^)(NSString *))cancelButton
{
    return ^(NSString *str) {
        [self.btnCancel setTitle:str forState:UIControlStateNormal];
        
        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_bottom);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
            make.height.equalTo(@40);
        }];
        
        [self layoutIfNeeded];
        SetViewEdgeBorder(self.btnCancel, UIRectEdgeRight);
        SetRoundedCorners(self.btnCancel, UIRectCornerBottomLeft, CGSizeMake(4, 4));
        
        return self;
    };
}

- (ZZAlertHelper * (^)(ButtonActionBlock))confirmHandler
{
    return ^(void(^handleBlock)(void)){
        self.confirmHandleBlock = handleBlock;
        
        return self;
    };
}

- (ZZAlertHelper * (^)(ButtonActionBlock))cancelHandler
{
    return ^(void(^handleBlock)(void)){
        self.cancelHandleBlock = handleBlock;
        
        return self;
    };
}

- (ZZAlertHelper * (^)(ButtonActionBlock))dismissHandler
{
    return ^(void(^handleBlock)(void)){
        self.dismissHandleBlock = handleBlock;
        
        return self;
    };
}

- (ZZAlertHelper * (^)(UIColor *))cancelTitleColor
{
    return ^(UIColor *color) {
        [self.btnCancel setTitleColor:color forState:UIControlStateNormal];
        
        return self;
    };
}

- (ZZAlertHelper * (^)(UIColor *))confirmTitleColor
{
    return ^(UIColor *color) {
        [self.btnConfirm setTitleColor:color forState:UIControlStateNormal];
        
        return self;
    };
}

- (ZZAlertHelper * (^)(UIColor *))titleColor
{
    return ^(UIColor *color) {
        self.titleLabel.textColor = color;
        
        return self;
    };
}

- (ZZAlertHelper * (^)(UIColor *))messageColor
{
    return ^(UIColor *color) {
        self.subtitleLabel.textColor = color;
        
        return self;
    };
}

- (ZZAlertHelper * (^)(UIColor *))confirmBackgroundColor
{
    return ^(UIColor *color) {
        self.btnConfirm.backgroundColor = color;
        
        return self;
    };
}

- (ZZAlertHelper * (^)(UIColor *))cancelBackgroundColor
{
    return ^(UIColor *color) {
        self.btnCancel.backgroundColor = color;
        
        return self;
    };
}

- (ZZAlertHelper * (^)(UIFont *))font
{
    return ^(UIFont *font) {
        self.titleLabel.font = font;
        
        return self;
    };
}

- (ZZAlertHelper * (^)(UIFont *))messageFont
{
    return ^(UIFont *font) {
        self.subtitleLabel.font = font;
        
        return self;
    };
}

- (ZZAlertHelper * (^)(UIFont *))buttonFont
{
    return ^(UIFont *font) {
        self.btnConfirm.titleLabel.font = font;
        self.btnCancel.titleLabel.font = font;
        
        return self;
    };
}

#pragma mark - Private

- (void)_hideViewFromSourceView
{
    for (UIView *view in self.sourceView.subviews) {
        if ([view isKindOfClass:[ZZAlertHelper class]]) {
            [UIView animateWithDuration:0.2
                             animations:^{
                [view removeFromSuperview];
                                 
                if (self.dismissHandleBlock) {
                    self.dismissHandleBlock();
                }
            }];
        }
    }
}

#pragma mark - Property

- (void)setContentViewColor:(UIColor *)contentViewColor
{
    self.contentView.backgroundColor = contentViewColor;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    self.titleLabel.textColor = titleTextColor;
}

- (void)setMessageTextColor:(UIColor *)messageTextColor
{
    self.subtitleLabel.textColor = messageTextColor;
}

- (void)setConfirmButtonTextColor:(UIColor *)confirmButtonTextColor
{
    [self.btnConfirm setTitleColor:confirmButtonTextColor forState:UIControlStateNormal];
}

- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor
{
    [self.btnCancel setTitleColor:cancelButtonTextColor forState:UIControlStateNormal];
}

- (void)setConfirmButtonBackgroundColor:(UIColor *)confirmButtonBackgroundColor
{
    self.btnConfirm.backgroundColor = confirmButtonBackgroundColor;
}

- (void)setCancelButtonBackgroundColor:(UIColor *)cancelButtonBackgroundColor
{
    self.btnCancel.backgroundColor = cancelButtonBackgroundColor;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    
    self.titleLabel.font = textFont;
}

- (void)setMessageTextFont:(UIFont *)messageTextFont
{
    _messageTextFont = messageTextFont;
    
    self.subtitleLabel.font = messageTextFont;
}

- (void)setButtonTextFont:(UIFont *)buttonTextFont
{
    _buttonTextFont = buttonTextFont;
    
    self.btnConfirm.titleLabel.font = buttonTextFont;
    self.btnCancel.titleLabel.font = buttonTextFont;
}

- (void)setIsHasTitle:(BOOL)isHasTitle
{
    _isHasTitle = isHasTitle;
    
    if (isHasTitle) {
        _subtitleLabel.edgeInsets = UIEdgeInsetsMake(0, 10, 20, 10);
    }
}

- (CGFloat)contentViewWidth
{
    if (_contentViewWidth <= 0) {
        if (self.delayTime > 0) {
            _contentViewWidth = CGRectGetWidth(self.sourceView.frame) * 0.85;
        } else {
            _contentViewWidth = CGRectGetWidth(self.sourceView.frame) * 0.72;
        }
    }
    
    return _contentViewWidth;
}

- (CGFloat)titleLabelHeight
{
    _titleLabelHeight = 0;
    
    if (_titleLabel.text) {
        _titleLabelHeight = GetHeightWithText(self.titleLabel.text, CGSizeMake(self.contentViewWidth -20, 120), self.textFont ? : [UIFont systemFontOfSize:17]) + 40;
    }
    
    return _titleLabelHeight;
}

- (CGFloat)subtitleLabelHeight
{
    _subtitleLabelHeight = 0;
    
    if (_subtitleLabel.text) {
        _subtitleLabelHeight = GetHeightWithText(self.subtitleLabel.text, CGSizeMake(self.contentViewWidth -20, 300), self.messageTextFont ? : [UIFont systemFontOfSize:16]) + (self.titleLabel.text ? 25 : 40);
    }
    
    return _subtitleLabelHeight;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(self.contentViewWidth));
        }];
    }
    
    return _contentView;
}

- (UIButton *)btnCancel
{
    if (!_btnCancel) {
        _btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnCancel.backgroundColor = [UIColor whiteColor];
        _btnCancel.titleLabel.font = [UIFont systemFontOfSize:17];
        [_btnCancel setTitleColor:[UIColor colorWithRed:(102 / 255.0f) green:(102 / 255.0f)                                                                                        blue:(102 / 255.0f) alpha:1] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCancel];
    }
    
    return _btnCancel;
}

- (UIButton *)btnConfirm
{
    if (!_btnConfirm) {
        _btnConfirm = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnConfirm.backgroundColor = [UIColor colorWithRed:(250 / 255.0f) green:(98 / 255.0f)                                                                                        blue:(27 / 255.0f) alpha:1];
        _btnConfirm.titleLabel.font = [UIFont systemFontOfSize:17];
        [_btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnConfirm addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnConfirm];
    }
    
    return _btnConfirm;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

- (CustomLabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [CustomLabel new];
        _titleLabel.edgeInsets = UIEdgeInsetsMake(20, 10, 20, 10);
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithRed:(51 / 255.0f) green:(51 / 255.0f)                                                                                        blue:(51 / 255.0f) alpha:1];
        
        [self.contentView addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (CustomLabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [CustomLabel new];
        _subtitleLabel.edgeInsets = UIEdgeInsetsMake(20, 10, 20, 10);
        _subtitleLabel.font = [UIFont systemFontOfSize:16];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.textColor = [UIColor colorWithRed:(151 / 255.0f) green:(151 / 255.0f)                                                                                        blue:(151 / 255.0f) alpha:1];
        _subtitleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_subtitleLabel];
    }
    
    return _subtitleLabel;
}

- (void)setDelayTime:(NSTimeInterval)delayTime
{
    _delayTime = delayTime;
    
    if (delayTime > 0) {
        if (@available(iOS 10.0, *)) {
            [NSTimer scheduledTimerWithTimeInterval:delayTime
                                            repeats:NO
                                              block:^(NSTimer *_Nonnull timer) {
                [self _hideViewFromSourceView];
            }];
        } else {
           [NSTimer scheduledTimerWithTimeInterval:delayTime target:self selector:@selector(_hideViewFromSourceView) userInfo:nil repeats:NO];
        }
    }
}

#pragma mark - Functions

void SetupZZAlertHelperConfiguration(HelperConfigurationHandler handler)
{
    configHandler = handler;
}

CGFloat GetHeightWithText(NSString *text, CGSize textSize, UIFont *font)
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 2;
    
    NSDictionary* attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    CGRect rect = [text boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:attributes
                                          context:nil];
    return rect.size.height;
}

void SetRoundedCorners(UIView *sourceView, UIRectCorner rectCorner, CGSize size)
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:sourceView.bounds byRoundingCorners:rectCorner cornerRadii:size];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    shape.frame = sourceView.bounds;
    [shape setPath:rounded.CGPath];

    sourceView.layer.mask = shape;
}

void SetViewEdgeBorder(UIView *view, UIRectEdge rectEdge)
{
    CGRect frame;
    switch (rectEdge) {
        case UIRectEdgeBottom:
            frame = CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 0.5);
            break;
        case UIRectEdgeRight:
            frame = CGRectMake(view.frame.size.width - 1, 0, 0.5, view.frame.size.height);
            break;
        default:
            frame = CGRectZero;
            break;
    }
    
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = [UIColor colorWithRed:(240 / 255.0f) green:(240 / 255.0f)                                                                                       blue:(240 / 255.0f) alpha:1].CGColor;
    [view.layer addSublayer:layer];
}

@end
