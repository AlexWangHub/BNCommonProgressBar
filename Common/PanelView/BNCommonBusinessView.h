//
//  BNCommonBusinessView.h
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import <UIKit/UIKit.h>

@class BNCommonPanelViewInfo;
@class BNCommonBusinessView;

NS_ASSUME_NONNULL_BEGIN

@protocol BNCommonBusinessViewDelegate <NSObject>

@optional
- (void)onClickBusinessViewWithInfo:(BNCommonPanelViewInfo *)info;

@end

@interface BNCommonBusinessView : UIView

@property (nonatomic, weak) id<BNCommonBusinessViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame info:(BNCommonPanelViewInfo *)info;

+ (instancetype)new DISPATCH_UNAVAILABLE_MSG("Use initWithFrame:info:");
- (instancetype)init DISPATCH_UNAVAILABLE_MSG("Use initWithFrame:info:");
- (instancetype)initWithFrame:(CGRect)frame DISPATCH_UNAVAILABLE_MSG("Use initWithFrame:info:");

@end

NS_ASSUME_NONNULL_END
