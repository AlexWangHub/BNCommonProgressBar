//
//  BNBuildHelper.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "BNBuildHelper.h"
#import "BNButton.h"
#import "UIView+Extend.h"

@implementation BNBuildHelper

+ (UILabel *)buildLabelWithFont:(UIFont *)font
                      textColor:(UIColor *)textColor
                     textHeight:(CGFloat)textHeight
                    defaultText:(NSString *)defaultText
                       maxWidth:(CGFloat)maxWidth
                  textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, textHeight)];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    if (defaultText.length > 0) {
        [label setText:defaultText];
        [label sizeToFit];
        label.width = (label.width > maxWidth) ? maxWidth : label.width;
        label.height = textHeight;
    }
    return label;
}

+ (UIButton *)buildButtonWithFrame:(CGRect)frame
                   backgroundColor:(UIColor *)backgroundColor
                        titleColor:(UIColor *)titleColor
                             title:(NSString *)title
                            target:(NSObject *)oTarget
                            action:(SEL)oSelector
                      cornerRadius:(CGFloat)cornerRadius {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = backgroundColor;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.accessibilityLabel = title;
    if (cornerRadius > 0) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = cornerRadius;
    }
    [button addTarget:oTarget action:oSelector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
