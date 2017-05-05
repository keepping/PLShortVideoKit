//
//  PLSFile.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PLSFileSection;

@class PLSFile;
@protocol PLSFileDelegate <NSObject>

/**
 @abstract 输出拼接视频文件的视频数据，用来做滤镜处理
 
 @since      v1.0.0
 */
- (CVPixelBufferRef __nonnull)file:(PLSFile *__nonnull)file didOutputPixelBuffer:(CVPixelBufferRef __nonnull)pixelBuffer;

/**
 @abstract 输出拼接视频文件的进度，progress从0到1
 
 @since      v1.0.0
 */
- (void)file:(PLSFile *__nonnull)file didOutputProgress:(CGFloat)progress;

/**
 @abstract 输出拼接后的视频文件的地址
 
 @since      v1.0.0
 */
- (void)file:(PLSFile *__nonnull)file didFinishMergingToOutputFileAtURL:(NSURL *__nonnull)url;

/**
 @abstract 拼接视频文件失败，输出错误信息
 
 @since      v1.0.0
 */
- (void)file:(PLSFile *__nonnull)file didMergeFailed:(NSError *__nullable)error;

/**
 @abstract 将拼接后的视频文件导入到相册
 
 @since      v1.0.0
 */
- (void)file:(PLSFile *__nonnull)file didExportFileToPhotosAlbum:(NSError *__nullable)error;

@end

@interface PLSFile : NSObject

/**
 @abstract 操作视频段的代理
 
 @since      v1.0.0
 */
@property (weak, nonatomic) __nullable id<PLSFileDelegate> delegate;

/**
 @abstract 保存所有视频段信息的数组
 
 @since      v1.0.0
 */
@property (strong, nonatomic) NSMutableArray<PLSFileSection *> *__nullable filesArray;

/**
 @abstract 当前视频段的地址
 
 @since      v1.0.0
 */
@property (strong, nonatomic) NSURL *__nullable currentFileURL;

/**
 @abstract 当前视频段的时长
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGFloat currentFileDuration;

/**
 @abstract 所有视频段的总时长
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGFloat totalDuration;

/**
 @property   delegateQueue
 @abstract   触发代理对象回调时所在的任务队列。
 
 @discussion 默认情况下该值为 nil，此时代理方法都会通过 main queue 异步执行回调。如果你期望可以所有的回调在自己创建或者其他非主线程调用，
 可以设置改 delegateQueue 属性。
 
 @see        PLSFileDelegate
 @see        delegate
 
 @since      v1.0.0
 */
@property (strong, nonatomic) dispatch_queue_t __nullable delegateQueue;

/**
 *  拼接视频
 *
 *  @param urls 保存的是视频的完整路径
 *  @param filter 使用外部滤镜／不使用滤镜时，设置为 nil；使用 SDK 内部自带的滤镜时，设置为相应的滤镜对象
 
 @since      v1.0.0
 */
- (void)writeMovieWithUrls:(NSArray<NSURL *> *__nonnull)urls filter:(id __nullable)filter;

/**
 *  拼接视频
 *
 *  @param asset AVAsset 对象
 *  @param filter 使用外部滤镜／不使用滤镜时，设置为 nil；使用 SDK 内部自带的滤镜时，设置为相应的滤镜对象
 
 @since      v1.0.0
 */
- (void)writeMovieWithAsset:(AVAsset *__nonnull)asset filter:(id __nullable)filter;

/**
 *  将沙盒中的视频文件导入到相册
 *
 *  @param urls 保存的是视频的完整路径
 
 @since      v1.0.0
 */
- (void)exportMovieToPhotosAlbum:(NSArray<NSURL *> *__nonnull)urls;

/**
 *  开启水印
 *
 *  @param waterMarkImage 水印的图片
 *  @param position       水印的位置
 
 @since      v1.0.0
 */
-(void)setWaterMarkWithImage:(UIImage *__nonnull)waterMarkImage position:(CGPoint)position;


@end
