//
//  EditViewController.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/4/11.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface EditViewController : UIViewController

@property (strong, nonatomic) NSArray *urlsArray;
@property (strong, nonatomic) AVAsset *asset;
@property (assign, nonatomic) CGFloat totalDuration;

@end
