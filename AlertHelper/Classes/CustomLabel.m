//
//  CustomLabel.m
//  demo
//
//  Created by zhangxiaoguang on 2018/11/12.
//  Copyright © 2018 -. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    UIEdgeInsets insets = self.edgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    
    if (self.text.length > 0) {
        rect.size.width  += (insets.left + insets.right);
        rect.size.height += (insets.top + insets.bottom);
    }
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets = edgeInsets;
    [self invalidateIntrinsicContentSize];
}

@end
