//
//  UIView+Extend.h
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extend)

- (void)removeAllSubViews;

@property CGSize size;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

@property CGFloat x;
@property CGFloat y;


@end

NS_ASSUME_NONNULL_END
