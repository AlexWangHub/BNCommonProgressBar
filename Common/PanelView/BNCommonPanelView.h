//
//  BNCommonPanelView.h
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import <UIKit/UIKit.h>

@class BNCommonPanelViewInfo;

NS_ASSUME_NONNULL_BEGIN

@protocol BNCommonPanelViewDelegate <NSObject>

@required
- (void)onClickBusinessViewWithInfo:(BNCommonPanelViewInfo *)info;

@optional
- (void)panelViewHeightChanged; // panelView 的高度发生变更了

@end

@interface BNCommonPanelView : UIView

@property (nonatomic, weak) id<BNCommonPanelViewDelegate> delegate;

- (instancetype)init DISPATCH_UNAVAILABLE_MSG("Use initWithFrame:");
+ (instancetype)new DISPATCH_UNAVAILABLE_MSG("Use initWithFrame:");

- (void)updateWithInfoArray:(NSArray<BNCommonPanelViewInfo *> *)infoArray;

@end

NS_ASSUME_NONNULL_END
