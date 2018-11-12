//
//  ZZAlertHelper.m
//  demo
//
//  Created by zhangxiaoguang on 2018/11/8.
//  Copyright © 2018 -. All rights reserved.
//

#import "ZZAlertHelper.h"
#import <Masonry/Masonry.h>

#define kAlertImageHeight   40
#define kAlertMargin    20

static HelperConfigurationHandler configHandler;
@interface ZZAlertHelper ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, assign) NSTimeInterval delayTime;
@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, copy) ButtonActionBlock confirmHandleBlock;
@property (nonatomic, copy) ButtonActionBlock cancelHandleBlock;

@property (nonatomic, assign) CGFloat titleLabelWidth;
@property (nonatomic, assign) CGFloat titleLabelHeight;

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
    return [[ZZAlertHelper alloc] initWithSourceView:view delay:1.5];
}

ZZAlertHelper * AlertView(UIView *view)
{
    return [[ZZAlertHelper alloc] initWithSourceView:view delay:0];
}

ZZAlertHelper * AlertTextInWindow()
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    return [[ZZAlertHelper alloc] initWithSourceView:keyWindow delay:1.5];;
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
        
        [self layoutIfNeeded];
        
        SetViewEdgeBorder(self.titleLabel, UIRectEdgeBottom);
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
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.titleLabelWidth));
            if (self.titleLabel.text) {
                make.height.equalTo(@(kAlertMargin + kAlertImageHeight + self.titleLabelHeight));
            } else {
                make.height.equalTo(@(kAlertMargin * 2 + kAlertImageHeight));
            }
        }];
        
        return self;
    };
}

- (ZZAlertHelper * (^)(NSString *))title
{
     return ^(NSString *title){
         self.titleLabel.text = title;
         
         [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.imageView.mas_bottom);
             make.centerX.equalTo(self.contentView.mas_centerX);
             make.width.equalTo(@(self.titleLabelWidth));
             make.height.equalTo(@(self.titleLabelHeight));
         }];
         
         [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.width.equalTo(@(self.titleLabelWidth));
             if (self.imageView.image) {
                 make.height.equalTo(@(kAlertMargin + kAlertImageHeight + self.titleLabelHeight));
             } else {
                 make.height.equalTo(@(self.titleLabelHeight));
             }
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
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
            make.height.equalTo(@40);
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
            }];
        }
    }
}

#pragma mark - Property

- (void)setContentViewColor:(UIColor *)contentViewColor
{
    _contentView.backgroundColor = contentViewColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setConfirmButtonTextColor:(UIColor *)confirmButtonTextColor
{
    [_btnConfirm setTitleColor:confirmButtonTextColor forState:UIControlStateNormal];
}

- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor
{
    [_btnCancel setTitleColor:cancelButtonTextColor forState:UIControlStateNormal];
}

- (void)setConfirmButtonBackgroundColor:(UIColor *)confirmButtonBackgroundColor
{
    _btnConfirm.backgroundColor = confirmButtonBackgroundColor;
}

- (void)setCancelButtonBackgroundColor:(UIColor *)cancelButtonBackgroundColor
{
    _btnCancel.backgroundColor = cancelButtonBackgroundColor;
}

- (void)setTextFont:(UIFont *)textFont
{
    _titleLabel.font = textFont;
    _btnConfirm.titleLabel.font = textFont;
    _btnCancel.titleLabel.font = textFont;
}

- (CGFloat)titleLabelWidth
{
    if (_titleLabelWidth <= 0) {
        if (self.delayTime > 0) {
            _titleLabelWidth = CGRectGetWidth(self.sourceView.frame) * 0.85;
        } else {
            _titleLabelWidth = CGRectGetWidth(self.sourceView.frame) * 0.72;
        }
    }
    
    return _titleLabelWidth;
}

- (CGFloat)titleLabelHeight
{
    if (_titleLabelHeight <= 0) {
        _titleLabelHeight = GetHeightWithText(self.titleLabel.text, CGSizeMake(self.titleLabelWidth, 120)) + 50;
    }
    
    return _titleLabelHeight;
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

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithRed:(51 / 255.0f) green:(51 / 255.0f)                                                                                        blue:(51 / 255.0f) alpha:1];
        _titleLabel.numberOfLines = 2;
        
        [self.contentView addSubview:_titleLabel];
    }
    
    return _titleLabel;
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
    handler = configHandler;
}

CGFloat GetHeightWithText(NSString *text, CGSize textSize)
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 2;
    
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
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
