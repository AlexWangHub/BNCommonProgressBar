//
//  BNCommonPanelView.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "BNCommonPanelView.h"
#import "BNCommonPanelViewInfo.h"
#import "UIView+Extend.h"
#import "BNCommonBusinessView.h"

// 这两个宏业务可配
#define BNBusinessViewHeight 56
#define BNPanelViewPadding 8

@interface BNCommonPanelView () <BNCommonBusinessViewDelegate>
@end

@implementation BNCommonPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)setHeight:(CGFloat)height {
    CGFloat lastHeight = self.height;
    [super setHeight:height];
    if (lastHeight != self.height) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(panelViewHeightChanged)]) {
            [self.delegate panelViewHeightChanged];
        }
    }
}

- (void)updateWithInfoArray:(NSArray<BNCommonPanelViewInfo *> *)infoArray {
    [self _updatePanelViewWithInfoArray:infoArray];
}

- (void)_updatePanelViewWithInfoArray:(NSArray<BNCommonPanelViewInfo *> *)infoArray {
    [self removeAllSubViews];
    
    for (BNCommonPanelViewInfo *info in infoArray) {
        BNCommonBusinessView *businessView = [[BNCommonBusinessView alloc] initWithFrame:CGRectMake(0, 0, self.width, BNBusinessViewHeight) info:info];
        businessView.delegate = self;
        [self addSubview:businessView];
    }
    
    [self _adjustPanelViewLayout];
}

- (void)_adjustPanelViewLayout {
    __block CGFloat curOffsetY = BNPanelViewPadding;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BNCommonBusinessView class]]) {
            BNCommonBusinessView *businessView = (BNCommonBusinessView *)obj;
            businessView.top = curOffsetY;
            curOffsetY += businessView.height + BNPanelViewPadding;
        }
    }];
    self.height = curOffsetY;
}

#pragma mark - BNCommonBusinessViewDelegate
- (void)onClickBusinessViewWithInfo:(BNCommonPanelViewInfo *)info {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBusinessViewWithInfo:)]) {
        [self.delegate onClickBusinessViewWithInfo:info];
    }
}

@end
