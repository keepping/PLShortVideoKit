//
//  PlayViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Qiniu/QiniuSDK.h>

#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

static NSString *const kUploadToken = @"MqF35-H32j1PH8igh-am7aEkduP511g-5-F7j47Z:0gzBOkhm3KsFGbGk2HdKfA4jZp4=:eyJzY29wZSI6InNob3J0LXZpZGVvIiwiZGVhZGxpbmUiOjE2NTA3MTExMDcsInVwaG9zdHMiOlsiaHR0cDovL3VwLXoyLnFpbml1LmNvbSIsImh0dHA6Ly91cGxvYWQtejIucWluaXUuY29tIiwiLUggdXAtejIucWluaXUuY29tIGh0dHA6Ly8xODMuNjAuMjE0LjE5OCJdfQ==";
static NSString *const kURLPrefix = @"http://oowtvx1xy.bkt.clouddn.com";

@interface PlayViewController ()

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVAsset *movieAsset;

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *processerToolboxView;

@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupToolboxUI];
    
    [self initPlayLayer];
    
    self.playButton = [[UIButton alloc] initWithFrame:_playerLayer.frame];
    [self.playButton setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(pressPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.playButton belowSubview:self.baseToolboxView];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.progress = 0.0;
    self.progressView.hidden = YES;
    self.progressView.trackTintColor = [UIColor blackColor];
    self.progressView.progressTintColor = [UIColor whiteColor];
    self.progressView.center = self.view.center;
    [self.view addSubview:self.progressView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_player pause];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)initPlayLayer {
    if (!_url) {
        return;
    }
    
    self.movieAsset = [AVURLAsset URLAssetWithURL:_url options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:_movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    self.playerLayer.frame = CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT);
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    UIView *playerView = [[UIView alloc] initWithFrame:self.playerLayer.frame];
    [playerView.layer addSublayer:self.playerLayer];
    [self.view insertSubview:playerView belowSubview:self.baseToolboxView];
}

- (void)setupToolboxUI {
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, 64)];
    self.baseToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseToolboxView];
    
    //关闭按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_a"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_b"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(0, 0, 80, 64);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    self.uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.uploadButton setTitle:@"上传" forState:UIControlStateNormal];
    [self.uploadButton setTitle:@"取消" forState:UIControlStateSelected];
    [self.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.uploadButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    self.uploadButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 0, 80, 64);
    self.uploadButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.uploadButton addTarget:self action:@selector(uploadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:self.uploadButton];
}

- (void)pressPlayButton:(UIButton *)button {
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    _playButton.alpha = 0.0f;
}

- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadButtonClick:(id)sender {
    self.uploadButton.selected = !self.uploadButton.selected;
    if (!self.uploadButton.selected) {
        return;
    }
    
    NSString *filePath = _url.path;
    self.progressView.hidden = NO;
    self.progressView.progress = 0;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *key = [NSString stringWithFormat:@"short_video_%@.mp4", [formatter stringFromDate:[NSDate date]]];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone2];
    }];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = percent;
        });
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:^BOOL{
                                                         return !self.uploadButton.isSelected;
                                                     }];
    [[QNUploadManager sharedInstanceWithConfiguration:config] putFile:filePath key:key token:kUploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        self.uploadButton.selected = NO;
        self.progressView.hidden = YES;
        NSLog(@"resp = %@",resp);
        NSLog(@"info = %@",info);
        if(info.error){
            [self showAlertWithMessage:[NSString stringWithFormat:@"上传失败，error: %@", info.error]];
            return ;
        }
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", kURLPrefix, key];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = urlString;
        [self showAlertWithMessage:[NSString stringWithFormat:@"上传成功，地址：%@ 已复制到系统剪贴板", urlString]];
    } option:uploadOption];
}

- (void)showAlertWithMessage:(NSString *)message {
    NSLog(@"alert message: %@", message);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - PlayEndNotification
- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification {
    if ((AVPlayerItem *)notification.object != _playerItem) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _playButton.alpha = 1.0f;
    }];
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _player = nil;
    _playerLayer = nil;
    _playerItem = nil;
    _movieAsset = nil;
    
    _baseToolboxView = nil;
}

@end
