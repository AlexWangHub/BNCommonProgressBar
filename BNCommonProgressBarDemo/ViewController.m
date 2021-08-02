//
//  ViewController.m
//  BNCommonProgressBarDemo
//
//  Created by binbinwang on 2021/8/2.
//

#import "ViewController.h"
#import "BNCommonPanelView.h"
#import "BNCommonPanelViewInfo.h"
#import "BNDataDefine.h"
#import "UIView+Extend.h"
#import "BNSystemSliderViewController.h"
#import "BNCustomProgressViewController.h"

#define BNPanelViewLeftRightMargin 32

@interface ViewController ()
@property (nonatomic,strong) BNCommonPanelView *panelView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.panelView];
    [self.panelView updateWithInfoArray:[self _getPanelInfoArray]];
}

- (NSArray<BNCommonPanelViewInfo *> *)_getPanelInfoArray {
    NSMutableArray *infoArray = [NSMutableArray array];
    
    BNCommonPanelViewInfo *scrollInfo = [[BNCommonPanelViewInfo alloc] init];
    scrollInfo.level = BNCommonPanelViewLevelSystemSlider;
    
    BNCommonPanelViewInfo *tableViewInfo = [[BNCommonPanelViewInfo alloc] init];
    tableViewInfo.level = BNCommonPanelViewLevelCustomProgressBar;
    
    [infoArray addObject:scrollInfo];
    [infoArray addObject:tableViewInfo];
    
    return [infoArray mutableCopy];
}

- (BNCommonPanelView *)panelView {
    if (!_panelView) {
        _panelView = [[BNCommonPanelView alloc] initWithFrame:CGRectMake(BNPanelViewLeftRightMargin, 220, self.view.width - 2 * BNPanelViewLeftRightMargin, self.view.height)];
        _panelView.delegate = self;
    }
    return _panelView;
}

#pragma mark - BNCommonPanelViewDelegate
- (void)onClickBusinessViewWithInfo:(BNCommonPanelViewInfo *)info {
    NSLog(@"ViewController onClickBusinessViewWithInfo level:%lu",(unsigned long)info.level);
    switch (info.level) {
        case BNCommonPanelViewLevelSystemSlider: {
            // 系统 slider
            BNSystemSliderViewController *systemSliderVC = [[BNSystemSliderViewController alloc] init];
            systemSliderVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController pushViewController:systemSliderVC animated:YES];
        }
            break;
        case BNCommonPanelViewLevelCustomProgressBar: {
            // 自定义 slider
            BNCustomProgressViewController *customProgressVC = [[BNCustomProgressViewController alloc] init];
            customProgressVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController pushViewController:customProgressVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
