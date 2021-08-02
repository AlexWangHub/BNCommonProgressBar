//
//  BNSystemSliderViewController.m
//  BNCommonProgressBarDemo
//
//  Created by binbinwang on 2021/8/2.
//

#import "BNSystemSliderViewController.h"
#import "UIView+Extend.h"
#import "BNBuildHelper.h"
#import "BNToolHelper.h"
#import "BNButton.h"

#define BNSliderLeftRightMargin 64
#define BNSliderHeight 20

#define BNBtnWid 132
#define BNBtnHeight 42
#define BNTimderDuration 0.3
#define BNTotalProgress 10

@interface BNSystemSliderViewController ()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, assign) CGFloat curProgress;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BNSystemSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithTitle:@"返回" style: UIBarButtonItemStylePlain target:self action:@selector(onClickBackAction)];
    self.navigationItem.leftBarButtonItem = leftButon;

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.slider];
    
    [self.view addSubview:self.startBtn];
    self.startBtn.center = CGPointMake(self.view.center.x, self.slider.bottom + 64);
    
    [self.view addSubview:self.pauseBtn];
    self.pauseBtn.center = CGPointMake(self.view.center.x, self.startBtn.bottom + 64);
}

- (void)onClickBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(BNSliderLeftRightMargin, self.view.height / 2 - 164, self.view.width - 2 * BNSliderLeftRightMargin, BNSliderHeight)];
    }
    return _slider;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [BNBuildHelper buildButtonWithFrame:CGRectMake(0, 0, BNBtnWid, BNBtnHeight) backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] title:@"开始" target:self action:@selector(onClickStartBtn) cornerRadius:(BNBtnHeight / 2)];
    }
    return _startBtn;
}

- (UIButton *)pauseBtn {
    if (!_pauseBtn) {
        _pauseBtn = [BNBuildHelper buildButtonWithFrame:CGRectMake(0, 0, BNBtnWid, BNBtnHeight) backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] title:@"暂停" target:self action:@selector(onClickPauseBtn) cornerRadius:(BNBtnHeight / 2)];
    }
    return _pauseBtn;
}

- (void)onClickStartBtn {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:BNTimderDuration target:self selector:@selector(onTimerCallback) userInfo:nil repeats:YES];;
}

- (void)onClickPauseBtn {
    [self.timer invalidate];
    self.title = nil;
}

- (void)onTimerCallback {
    self.curProgress += BNTimderDuration;
    [self.slider setValue:(self.curProgress / BNTotalProgress) animated:YES];
}

@end
