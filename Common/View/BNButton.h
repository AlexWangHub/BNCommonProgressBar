//
//  BNButton.h
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import <UIKit/UIButton.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNButton : UIButton

/*!
 *  用于设置button边界外的响应区域。例如：
 *  @code
 *    TRIPButton *button = ...
 *    button.frame = CGRectMake(100, 100, 100, 100);
 *    button.touchInsets = UIEdgeInsetsMake(0, 20, 20, 0); // top=20, bottom=20
 *    // button的响应区域为 { 100, 80, 120, 120 }
 *  @endcode
 *  默认为UIEdgeInsetsZero
 */
@property (nonatomic, assign) UIEdgeInsets touchInsets;

/**
 增加点击区域的宽度
 */
@property (nonatomic, assign) NSInteger expandHitWidth;

/**
 增加点击区域的高度
 */
@property (nonatomic, assign) NSInteger expandHitHeight;

/// 使用侧自由传入的上下文自定义对象
@property (nonatomic, strong) id customObject;

- (void)setNormalImage:(UIImage *)normal selectedImage:(UIImage *)selected;

@end

NS_ASSUME_NONNULL_END
