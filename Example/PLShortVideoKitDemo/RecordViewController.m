//
//  RecordViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "RecordViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "PLSProgressBar.h"
#import "PLSDeleteButton.h"
#import "EditViewController.h"

#define PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG 10001
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define PLS_RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

@interface RecordViewController () <PLShortVideoSessionDelegate>

@property (strong, nonatomic) PLShortVideoSession *shortVideoSession;
@property (nonatomic, strong) PLSProgressBar *progressBar;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) PLSDeleteButton *deleteButton;
@property (strong, nonatomic) UIButton *endButton;

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *recordToolboxView;
@property (strong, nonatomic) UIImageView *indicator;
@property (strong, nonatomic) UIButton *squareRecordButton;
@property (strong, nonatomic) UILabel *durationLabel;
@property (strong, nonatomic) UIAlertView *alertView;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    // --------------------------
    // 短视频录制核心类设置
    [self setupShortVideoSession];
    
    // --------------------------
    [self setupBaseToolboxView];
    [self setupRecordToolboxView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.shortVideoSession startCaptureSession];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.shortVideoSession stopCaptureSession];
}

// 短视频录制核心类设置
- (void)setupShortVideoSession {
    // SDK 的版本信息
    NSLog(@"PLShortVideoSession versionInfo: %@", [PLShortVideoSession versionInfo]);
    
    PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
    videoConfiguration.position = AVCaptureDevicePositionFront;
    videoConfiguration.videoSize = CGSizeMake(480, 854);
    videoConfiguration.videoFrameRate = 25;
    videoConfiguration.averageVideoBitRate = 1024*1000;
    
    PLSAudioConfiguration *audioConfiguration = [PLSAudioConfiguration defaultConfiguration];
    
    self.shortVideoSession = [[PLShortVideoSession alloc] initWithVideoConfiguration:videoConfiguration audioConfiguration:audioConfiguration];
    
    self.shortVideoSession.previewView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT);
    [self.view addSubview:self.shortVideoSession.previewView];
    
    self.shortVideoSession.delegate = self;
    
    self.shortVideoSession.maxDuration = 60.0f; // 设置最长录制时长
}

- (void)setupBaseToolboxView {
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_BaseToolboxView_HEIGHT)];
    self.baseToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseToolboxView];
    
    // 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 10, 35, 35);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_camera_cancel_a"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_camera_cancel_b"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    // 全屏／正方形录制模式
    self.squareRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.squareRecordButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 210, 10, 35, 35);
    [self.squareRecordButton setTitle:@"1:1" forState:UIControlStateNormal];
    [self.squareRecordButton setTitle:@"全屏" forState:UIControlStateSelected];
    self.squareRecordButton.selected = NO;
    [self.squareRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.squareRecordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.squareRecordButton addTarget:self action:@selector(squareRecordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.squareRecordButton];
    
    // 闪光灯
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flashButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 155, 10, 35, 35);
    [flashButton setBackgroundImage:[UIImage imageNamed:@"flash_close"] forState:UIControlStateNormal];
    [flashButton setBackgroundImage:[UIImage imageNamed:@"flash_open"] forState:UIControlStateSelected];
    [flashButton addTarget:self action:@selector(flashButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:flashButton];
    
    // 美颜
    UIButton *beautyFaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    beautyFaceButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 100, 12, 30, 30);
    [beautyFaceButton setTitle:@"美颜" forState:UIControlStateNormal];
    [beautyFaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    beautyFaceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [beautyFaceButton addTarget:self action:@selector(beautyFaceButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:beautyFaceButton];
    
    // 切换摄像头
    UIButton *toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toggleCameraButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 45, 10, 35, 35);
    [toggleCameraButton setBackgroundImage:[UIImage imageNamed:@"toggle_camera"] forState:UIControlStateNormal];
    [toggleCameraButton addTarget:self action:@selector(toggleCameraButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:toggleCameraButton];
}

- (void)setupRecordToolboxView {
    CGFloat y = self.baseToolboxView.frame.origin.y + self.baseToolboxView.frame.size.height + PLS_SCREEN_WIDTH;
    self.recordToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, y, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT- y)];
    self.recordToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.recordToolboxView];
    
    // 录制视频的操作按钮
    CGFloat buttonWidth = 80.0f;
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
    self.recordButton.center = CGPointMake(PLS_SCREEN_WIDTH / 2, self.recordToolboxView.frame.size.height - 80);
    [self.recordButton setImage:[UIImage imageNamed:@"btn_record_a"] forState:UIControlStateNormal];
    [self.recordButton addTarget:self action:@selector(recordButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordToolboxView addSubview:self.recordButton];
    
    // 删除视频片段的按钮
    CGPoint center = self.recordButton.center;
    center.x = 40;
    self.deleteButton = [PLSDeleteButton getInstance];
    self.deleteButton.style = PLSDeleteButtonStyleNormal;
    self.deleteButton.frame = CGRectMake(15, PLS_SCREEN_HEIGHT - 80, 50, 50);
    self.deleteButton.center = center;
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_del_a"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordToolboxView addSubview:self.deleteButton];
    self.deleteButton.hidden = YES;
    
    // 结束录制的按钮
    center = self.recordButton.center;
    center.x = CGRectGetWidth([UIScreen mainScreen].bounds) - 60;
    self.endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.endButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 60, PLS_SCREEN_HEIGHT - 80, 50, 50);
    self.endButton.center = center;
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"end_normal"] forState:UIControlStateNormal];
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"end_disable"] forState:UIControlStateDisabled];
    [self.endButton addTarget:self action:@selector(endButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.endButton.enabled = NO;
    [self.recordToolboxView addSubview:self.endButton];
    self.endButton.hidden = YES;
    
    // 视频录制进度条
    self.progressBar = [[PLSProgressBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.recordToolboxView.frame) - 10, PLS_SCREEN_WIDTH, 10)];
    [self.recordToolboxView addSubview:self.progressBar];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(PLS_SCREEN_WIDTH - 150, CGRectGetHeight(self.recordToolboxView.frame) - 45, 130, 40)];
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.text = @"0.00s";
    self.durationLabel.textAlignment = NSTextAlignmentRight;
    [self.recordToolboxView addSubview:self.durationLabel];
}

#pragma mark -- Button event
// 返回上一层
- (void)backButtonEvent:(id)sender {
    if ([_shortVideoSession getFilesCount] > 0) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"放弃这个视频(共%ld个视频段)?", (long)[_shortVideoSession getFilesCount]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.alertView.tag = PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG;
        [self.alertView show];
    } else {
        [self discardRecord];
    }
}

// 全屏录制／正方形录制
- (void)squareRecordButtonEvent:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        
        PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
        videoConfiguration.videoSize = CGSizeMake(480, 480);
        [_shortVideoSession reloadvideoConfiguration:videoConfiguration];
        
        self.shortVideoSession.maxDuration = 10.0f;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shortVideoSession.previewView.frame = CGRectMake(0, PLS_BaseToolboxView_HEIGHT, PLS_SCREEN_WIDTH, PLS_SCREEN_WIDTH);
            self.progressBar.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, 10);
            
        });
        
    } else {
        PLSVideoConfiguration *videoConfiguration = [PLSVideoConfiguration defaultConfiguration];
        videoConfiguration.videoSize = CGSizeMake(480, 854);
        [_shortVideoSession reloadvideoConfiguration:videoConfiguration];
        
        self.shortVideoSession.maxDuration = 60.0f;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _shortVideoSession.previewView.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT);
            self.progressBar.frame = CGRectMake(0, CGRectGetHeight(self.recordToolboxView.frame) - 10, PLS_SCREEN_WIDTH, 10);
        });
    }
}

// 打开／关闭闪光灯
- (void)flashButtonEvent:(id)sender {
    if (_shortVideoSession.torchOn) {
        _shortVideoSession.torchOn = NO;
    } else {
        _shortVideoSession.torchOn = YES;
    }
}

// 打开／关闭美颜
- (void)beautyFaceButtonEvent:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    [_shortVideoSession setBeautifyModeOn:!button.selected];
    
    button.selected = !button.selected;
}

// 切换前后置摄像头
- (void)toggleCameraButtonEvent:(id)sender {
    [_shortVideoSession toggleCamera];
}

// 删除上一段视频
- (void)deleteButtonEvent:(id)sender {
    if (_deleteButton.style == PLSDeleteButtonStyleNormal) {
        
        [_progressBar setLastProgressToStyle:PLSProgressBarProgressStyleDelete];
        _deleteButton.style = PLSDeleteButtonStyleDelete;
        
    } else if (_deleteButton.style == PLSDeleteButtonStyleDelete) {
        
        [_shortVideoSession deleteLastFile];
        
        [_progressBar deleteLastProgress];
        
        _deleteButton.style = PLSDeleteButtonStyleNormal;
    }
}

// 录制视频
- (void)recordButtonEvent:(id)sender {
    if (_shortVideoSession.isRecording) {
        [_shortVideoSession stopRecording];
    } else {
        [_shortVideoSession startRecording];
    }
}

// 结束录制
- (void)endButtonEvent:(id)sender {
    AVAsset *asset = _shortVideoSession.assetRepresentingAllFiles;
    [self playEvent:asset];
}

// 取消录制
- (void)discardRecord {
    [_shortVideoSession cancelRecording];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case PLS_CLOSE_CONTROLLER_ALERTVIEW_TAG:
        {
            switch (buttonIndex) {
                case 0:
                    
                    break;
                case 1:
                {
                    [self discardRecord];
                }
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- PLShortVideoSessionDelegate
#pragma mark - 视频数据回调
/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致帧率下降
- (CVPixelBufferRef)shortVideoSession:(PLShortVideoSession *)session cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    //此处可以做美颜/滤镜等处理

    return pixelBuffer;
}

#pragma mark -- PLShortVideoSessionDelegate 视频录制回调
// 开始录制一段视频时
- (void)shortVideoSession:(PLShortVideoSession *)shortVideoSession didStartRecordingToOutputFileAtURL:(NSURL *)fileURL {
    NSLog(@"start recording fileURL: %@", fileURL);

    [self.progressBar addProgressView];
    [_progressBar startShining];
}

// 正在录制的过程中
- (void)shortVideoSession:(PLShortVideoSession *)shortVideoSession didRecordingToOutputFileAtURL:(NSURL *)outputFileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    [_progressBar setLastProgressToWidth:fileDuration / _shortVideoSession.maxDuration * _progressBar.frame.size.width];
    
    self.endButton.enabled = (totalDuration >= _shortVideoSession.minDuration);
    
    self.squareRecordButton.hidden = YES; // 录制过程中不允许切换分辨率（1:1 <--> 全屏）
    self.deleteButton.hidden = YES;
    self.endButton.hidden = YES;
    
    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 删除了某一段视频
- (void)shortVideoSession:(PLShortVideoSession *)shortVideoSession didDeleteFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    
    NSLog(@"delete fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);

    self.endButton.enabled = totalDuration >= _shortVideoSession.minDuration;

    if (totalDuration <= 0.0000001f) {
        self.squareRecordButton.hidden = NO;
        self.deleteButton.hidden = YES;
        self.endButton.hidden = YES;
    }

    self.durationLabel.text = [NSString stringWithFormat:@"%.2fs", totalDuration];
}

// 完成一段视频的录制时
- (void)shortVideoSession:(PLShortVideoSession *)shortVideoSession didFinishRecordingToOutputFileAtURL:(NSURL *)fileURL fileDuration:(CGFloat)fileDuration totalDuration:(CGFloat)totalDuration {
    NSLog(@"finish recording fileURL: %@, fileDuration: %f, totalDuration: %f", fileURL, fileDuration, totalDuration);
    
    [_progressBar stopShining];

    self.deleteButton.hidden = NO;
    self.endButton.hidden = NO;

    
    if (totalDuration >= _shortVideoSession.maxDuration) {
        [self endButtonEvent:nil];
    }
}

// 在达到指定的视频录制时间 maxDuration 后，如果再调用 [PLShortVideoSession startRecording]，直接执行该回调
- (void)shortVideoSession:(PLShortVideoSession *)shortVideoSession didFinishRecordingMaxDuration:(CGFloat)maxDuration {
    NSLog(@"finish recording maxDuration: %f", maxDuration);

    AVAsset *asset = _shortVideoSession.assetRepresentingAllFiles;
    [self playEvent:asset];
}

- (void)playEvent:(AVAsset *)asset {
    // 获取当前会话的所有的视频段文件
    NSArray *filesURLArray = [_shortVideoSession getAllFilesURL];
    NSLog(@"filesURLArray:%@", filesURLArray);
    
    EditViewController *videoEditViewController = [[EditViewController alloc] init];
    videoEditViewController.urlsArray = filesURLArray;
    videoEditViewController.asset = asset;
    videoEditViewController.totalDuration = [_shortVideoSession getTotalDuration];
    [self presentViewController:videoEditViewController animated:YES completion:nil];
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- dealloc
- (void)dealloc {
    self.shortVideoSession.delegate = nil;
    self.shortVideoSession = nil;
    
    self.alertView = nil;
}

@end

