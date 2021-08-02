//
//  BNCommonBusinessView.m
//  timeProfileUILagDemo
//
//  Created by binbinwang on 2021/7/31.
//

#import "BNCommonBusinessView.h"
#import "BNCommonPanelViewInfo.h"
#import "BNBuildHelper.h"
#import "BNDataDefine.h"
#import "UIView+Extend.h"

@interface BNCommonBusinessView ()
@property (nonatomic, strong) BNCommonPanelViewInfo *info;
@property (nonatomic, strong) BNButton *titleButton;
@end

@implementation BNCommonBusinessView

- (instancetype)initWithFrame:(CGRect)frame info:(BNCommonPanelViewInfo *)info {
    if (self = [super initWithFrame:frame]) {
        _info = info;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    NSString *tips = @"";
    switch (self.info.level) {
        case BNCommonPanelViewLevelScroll:
            tips = @"scrollView 卡顿 Demo";
            break;
        case BNCommonPanelViewLevelTableView:
            tips = @"tableView 卡顿 Demo";
            break;
        default:
            break;
    }
    
    self.titleButton = [BNBuildHelper buildButtonWithFrame:self.bounds backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] title:tips  target:self action:@selector(onClickButtonAction) cornerRadius:(self.height / 2)];
    [self addSubview:self.titleButton];
}

- (void)onClickButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBusinessViewWithInfo:)]) {
        [self.delegate onClickBusinessViewWithInfo:self.info];
    }
}

@end
