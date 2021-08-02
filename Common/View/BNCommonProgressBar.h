//
//  BNCommonProgressBar.h
//  BNCommonProgressBarDemo
//
//  Created by binbinwang on 2021/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BNCommonGestureState);

@protocol BNCommonProgressBarDelegate <NSObject>

@optional
- (void)progressBarCurPlayPrecent:(CGFloat)precent dragState:(BNCommonGestureState)dragState;

@end

@interface BNCommonProgressBar : UIView

@property (nonatomic, weak) id<BNCommonProgressBarDelegate> delegate;
@property (nonatomic, assign, getter=isShowLargeBar) BOOL showLargeBar; ///< YES，进度条高度4；NO，进度条高度为2
@property (nonatomic, assign, getter=isShowAnchorPoint) BOOL showAnchorPoint; ///< YES，展示圆点；NO，隐藏圆点

- (instancetype)initWithFrame:(CGRect)frame
                    barHeight:(CGFloat)progressBarHeight
                    dotHeight:(CGFloat)dotHeight
                 defaultColor:(UIColor *)defaultColor
              inProgressColor:(UIColor *)inProgressColor
                    dragColor:(UIColor *)dragColor
                 cornerRadius:(CGFloat)cornerRadius
         progressBarIconImage:(UIImage *)progressBarIconImage
         enablePanProgressIcon:(BOOL)enablePanProgressIcon;

+ (CGFloat)progressBarVisibleHeight;
- (CGFloat)value;
- (void)setValue:(CGFloat)value;
- (void)setValue:(CGFloat)value animateWithDuration:(NSTimeInterval)duration time:(NSTimeInterval)time;
- (void)setValue:(CGFloat)value animateWithDuration:(NSTimeInterval)duration completion:(void (^__nullable)(BOOL finished))completion;
- (void)reset;
- (void)pauseAnimation;
- (void)resumeAnimation;
- (void)removeProgressAnimation;

@end

NS_ASSUME_NONNULL_END
