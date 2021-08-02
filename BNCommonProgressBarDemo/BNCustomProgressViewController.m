//
//  BNCustomProgressViewController.m
//  BNCommonProgressBarDemo
//
//  Created by binbinwang on 2021/8/2.
//

#import "BNCustomProgressViewController.h"
#import "UIView+Extend.h"
#import "BNBuildHelper.h"
#import "BNToolHelper.h"
#import "BNButton.h"
#import "BNCommonProgressBar.h"

#define BNSliderLeftRightMargin 64
#define BNSliderHeight 20

#define BNBtnWid 132
#define BNBtnHeight 42
#define BNTimderDuration 0.3
#define BNTotalProgress 10

@interface BNCustomProgressViewController ()

@property (nonatomic, strong) BNCommonProgressBar *progressBar;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *pauseBtn;
@property (nonatomic, strong) UIButton *resumeBtn;
@property (nonatomic, assign) CGFloat curProgress;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BNCustomProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithTitle:@"返回" style: UIBarButtonItemStylePlain target:self action:@selector(onClickBackAction)];
    self.navigationItem.leftBarButtonItem = leftButon;

    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.progressBar];
    
    [self.view addSubview:self.startBtn];
    self.startBtn.center = CGPointMake(self.view.center.x, self.progressBar.bottom + 64);
    
    [self.view addSubview:self.pauseBtn];
    self.pauseBtn.center = CGPointMake(self.view.center.x, self.startBtn.bottom + 64);
    
    [self.view addSubview:self.resumeBtn];
    self.resumeBtn.center = CGPointMake(self.view.center.x, self.pauseBtn.bottom + 64);
}

- (void)onClickBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BNCommonProgressBar *)progressBar {
    if (!_progressBar) {
        _progressBar = [[BNCommonProgressBar alloc] initWithFrame:CGRectMake(BNSliderLeftRightMargin, self.view.height / 2 - 164, self.view.width - 2 * BNSliderLeftRightMargin, BNSliderHeight) barHeight:1.5 dotHeight:15 defaultColor:[UIColor colorWithWhite:1 alpha:0.1] inProgressColor:[UIColor whiteColor] dragColor:[UIColor whiteColor] cornerRadius:0.5 progressBarIconImage:nil enablePanProgressIcon:YES];
        _progressBar.delegate = self;
    }
    return _progressBar;
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

-(UIButton *)resumeBtn {
    if (!_resumeBtn) {
        _resumeBtn = [BNBuildHelper buildButtonWithFrame:CGRectMake(0, 0, BNBtnWid, BNBtnHeight) backgroundColor:[UIColor orangeColor] titleColor:[UIColor whiteColor] title:@"恢复" target:self action:@selector(onClickResumeBtn) cornerRadius:(BNBtnHeight / 2)];
    }
    return _resumeBtn;
}

- (void)onClickStartBtn {
    [self _startTimer];
}

- (void)_startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:BNTimderDuration target:self selector:@selector(onTimerCallback) userInfo:nil repeats:YES];;
}

- (void)_stopTimer {
    [self.timer invalidate];
    self.title = nil;
}

- (void)onClickPauseBtn {
    [self _stopTimer];
    [self.progressBar pauseAnimation];
}

- (void)onClickResumeBtn {
    [self _startTimer];
    [self.progressBar resumeAnimation];
}

- (void)onTimerCallback {
    self.curProgress += BNTimderDuration;

    [self.progressBar setValue:(self.curProgress / BNTotalProgress) animateWithDuration:1.0f time:self.curProgress];
    self.progressBar.showLargeBar = YES;
    self.progressBar.showAnchorPoint = YES;
}

@end
