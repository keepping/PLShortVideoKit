//
//  PLSFileSection.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PLSFileSection : NSObject

/**
 @abstract 视频段的地址
 
 @since      v1.0.0
 */
@property (strong, nonatomic) NSURL *fileURL;

/**
 @abstract 视频段的时长
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGFloat duration;

@end
