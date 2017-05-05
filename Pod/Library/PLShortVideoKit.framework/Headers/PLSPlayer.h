//
//  PLSPlayer.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/7.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import "PLSTypeDefines.h"

@class PLSPlayer;

@protocol PLSPlayerDelegate <NSObject>

@optional
/**
 @abstract  pixelBuffer 格式为 kCVPixelFormatType_32BGRA
 
 @since      v1.0.0
 */
- (CVPixelBufferRef __nonnull)player:(PLSPlayer *__nonnull)player didGetOriginPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer;

/**
 @abstract  从 currentTime 处播放，loopsCount 为循环次数
 @since      v1.0.0
 */
- (void)player:(PLSPlayer *__nonnull)player didPlay:(CMTime)currentTime loopsCount:(NSInteger)loopsCount;

/**
 @abstract  item 变化了的回调
 
 @since      v1.0.0
 */
- (void)player:(PLSPlayer *__nonnull)player didChangeItem:(AVPlayerItem *__nullable)item;

/**
 @abstract  item 结束了的回调
 
 @since      v1.0.0
 */
- (void)player:(PLSPlayer *__nonnull)player didReachEndForItem:(AVPlayerItem *__nonnull)item;

/**
 @abstract  item 准备播放的回调
 
 @since      v1.0.0
 */
- (void)player:(PLSPlayer *__nonnull)player itemReadyToPlay:(AVPlayerItem *__nonnull)item;

/**
 @abstract  设置播放器预览视图的回调
 
 @since      v1.0.0
 */
- (void)player:(PLSPlayer *__nonnull)player didSetupPlayerView:(UIView *__nonnull)playerView;

/**
 @abstract  item 更新了 timeRange
 
 @since      v1.0.0
 */
- (void)player:(PLSPlayer *__nonnull)player didUpdateLoadedTimeRanges:(CMTimeRange)timeRange;

/**
 @abstract  当 item 的 playback buffer 为空时的回调
 
 @since      v1.0.0
 */
- (void)player:(PLSPlayer *__nonnull)player itemPlaybackBufferIsEmpty:(AVPlayerItem *__nullable)item;

@end


@interface PLSPlayer : AVPlayer

/**
 @abstract 播放器的代理
 
 @since      v1.0.0
 */
@property (weak, nonatomic) __nullable id<PLSPlayerDelegate> delegate;

/**
 @abstract 循环播放
 
 @since      v1.0.0
 */
@property (assign, nonatomic) BOOL loopEnabled;

/**
 @abstract Whether this instance is currently playing
 
 @since      v1.0.0
 */
@property (readonly, nonatomic) BOOL isPlaying;

/**
 @abstract 播放器的渲染视图
 
 @since      v1.0.0
 */
@property (assign, nonatomic) UIView *__nullable playerView;

/**
 @abstract 播放器的渲染视图中视频的填充模式
 
 @since      v1.0.0
 */
@property (assign, nonatomic) PLSVideoFillModeType fillMode;

/**
 @abstract 是否开启内部集成的滤镜，默认为 NO
 
 @since      v1.0.0
 */
@property (assign, nonatomic) BOOL filterModeOn;

/**
 @abstract NSDictionary 中 Key 为 filterName, filterImagePath
 
 @since      v1.0.0
 */
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *__nullable filters;

/**
 @abstract 播放时，选中的内部滤镜类型
 
 @since      v1.0.0
 */
@property (assign, nonatomic) NSInteger filterType;

/**
 @abstract 选中的内部滤镜类型对应的滤镜对象。当 currentFilter 为 nil 时，不会添加内部滤镜效果到视频帧上。
 
 @since      v1.0.0
 */
@property (strong, nonatomic) id __nullable currentFilter;

+ (PLSPlayer *__nonnull)player;

/**
 @abstract 播放 stringPath
 
 @since      v1.0.0
 */
- (void)setItemByStringPath:(NSString *__nullable)stringPath;

/**
 @abstract 播放 url
 
 @since      v1.0.0
 */
- (void)setItemByUrl:(NSURL *__nullable)url;

/**
 @abstract 播放 asset
 
 @since      v1.0.0
 */
- (void)setItemByAsset:(AVAsset *__nullable)asset;

/**
 @abstract 播放 item
 
 @since      v1.0.0
 */
- (void)setItem:(AVPlayerItem *__nullable)item;

/**
 @abstract 播放
 
 @since      v1.0.0
 */
- (void)play;

/**
 @abstract 暂停
 
 @since      v1.0.0
 */
- (void)pause;

/**
 *  开启水印
 *
 *  @param waterMarkImage 水印的图片
 *  @param position       水印的位置
 
 @since      v1.0.0
 */
-(void)setWaterMarkWithImage:(UIImage *__nonnull)waterMarkImage position:(CGPoint)position;

/**
 *  移除水印
 
 @since      v1.0.0
 */
-(void)clearWaterMark;

@end
