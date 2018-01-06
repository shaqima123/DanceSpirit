//
//  DSVideoPlayerVC.h
//  DanceSpirit
//
//  Created by 张迪涵 on 2017/12/27.
//  Copyright © 2017年 zj－db0737. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dismissCompleteBlock)(void);

@interface DSVideoPlayerVC : UIViewController

@property (nonatomic, copy) dismissCompleteBlock dismissCompleteBlock;

/**
 *      初始化方法
 *      frame           : 视频播放控件的大小
 *      playFromURL     : URL
 */
- (instancetype)initWithFrame:(CGRect)frame playFormURL:(NSURL *)playFormURL;
/**
 *      播放视频的方法
 */
- (void)videoPlay;
/**
 *      暂停视频的方法
 */
- (void)videoPause;
/**
 *      展示在KeyWindow
 */
- (void)showInWindow;

@end
