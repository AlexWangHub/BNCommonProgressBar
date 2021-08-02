//
//  BNBuildHelper.h
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BNButton;

NS_ASSUME_NONNULL_BEGIN

@interface BNBuildHelper : NSObject

+ (UILabel *)buildLabelWithFont:(UIFont *)font
                      textColor:(UIColor *)textColor
                     textHeight:(CGFloat)textHeight
                    defaultText:(NSString *)defaultText
                       maxWidth:(CGFloat)maxWidth
                  textAlignment:(NSTextAlignment)textAlignment;

+ (UIButton *)buildButtonWithFrame:(CGRect)frame
                   backgroundColor:(UIColor *)backgroundColor
                        titleColor:(UIColor *)titleColor
                             title:(NSString *)title
                            target:(NSObject *)oTarget
                            action:(SEL)oSelector
                      cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
