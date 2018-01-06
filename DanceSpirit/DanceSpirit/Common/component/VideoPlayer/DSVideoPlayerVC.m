//
//  DSVideoPlayerVC.m
//  DanceSpirit
//
//  Created by 张迪涵 on 2017/12/27.
//  Copyright © 2017年 zj－db0737. All rights reserved.
//

#import "DSVideoPlayerVC.h"
#import "DSVideoPlayerView.h"
#import "DanceSpiritDef.h"

#import <AVFoundation/AVFoundation.h>

static const CGFloat kVideoPlayerAnimationTimeInterval = 0.3f;

@interface DSVideoPlayerVC ()

@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong) DSVideoPlayerView *videoPlayerView;
@property (nonatomic, strong) AVPlayerLayer *playLayer;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) AVPlayerItemStatus avPlayerItemStatus;

@end

@implementation DSVideoPlayerVC

- (instancetype)initWithFrame:(CGRect)frame playFormURL:(NSURL *)playFormURL {
    self = [super init];
    if (self) {
        // 设置自定义View的frame
        self.view.backgroundColor = [UIColor blackColor];
        self.view.bounds = frame;
        _avPlayerItem = [[AVPlayerItem alloc] initWithURL:playFormURL];
        self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:_avPlayerItem];
        self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
        [self.view.layer addSublayer:self.playLayer];
        self.playLayer.frame = self.view.bounds;
        self.videoPlayerView.frame = self.view.bounds;
        [self configClickEvents];
        [self.view addSubview:self.videoPlayerView];
        CGFloat duration = floor(CMTimeGetSeconds(self.avPlayerItem.asset.duration));
        // 设置最大最小值
        self.videoPlayerView.progressSlider.minimumValue = 0.f;
        self.videoPlayerView.progressSlider.maximumValue = floor(duration);
        
        // 默认值: 非全屏
        self.isFullscreenMode = NO;
        
        // 设置监听
        [self configObserver];
        
        self.videoPlayerView.playButton.hidden = YES;
        self.videoPlayerView.pauseButton.hidden = NO;
    }
    return self;
}

- (DSVideoPlayerView *)videoPlayerView {
    if (_videoPlayerView == nil) {
        _videoPlayerView = [[DSVideoPlayerView alloc] init];
    }
    return _videoPlayerView;
}

- (void)videoPlay {
    [self.avPlayer play];
}

- (void)videoPause {
    [self.avPlayer pause];
}

- (void)showInWindow {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (keyWindow == nil) {
        keyWindow = [[UIApplication sharedApplication] windows].firstObject;
    }
    [keyWindow addSubview:self.view];
    
    self.view.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerAnimationTimeInterval animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)configClickEvents {
    [self.videoPlayerView.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoPlayerView.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoPlayerView.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoPlayerView.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoPlayerView.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.videoPlayerView.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoPlayerView.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.videoPlayerView.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoPlayerView.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    
}

- (void)playButtonClick {
    [self videoPlay];
    self.videoPlayerView.playButton.hidden = YES;
    self.videoPlayerView.pauseButton.hidden = NO;
}

- (void)pauseButtonClick {
    [self videoPause];
    self.videoPlayerView.pauseButton.hidden = YES;
    self.videoPlayerView.playButton.hidden = NO;
}

- (void)progressSliderTouchBegan:(UISlider *)slider {
    // 停止播放
    [self videoPause];
    [self stopDurationTimer];
    [self.videoPlayerView cancelAutoFadeOutControlBar];
    
}

- (void)progressSliderTouchEnded:(UISlider *)slider {
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(slider.value, self.avPlayerItem.currentTime.timescale)];
    [self.videoPlayerView autoFadeOutControlBar];
    [self stopDurationTimer];
    [self videoPlay];
    // 如果暂停按钮的隐藏属性是 NO, 那么调整按钮显隐性
    if (_videoPlayerView.playButton.hidden == NO) {
        _videoPlayerView.playButton.hidden = NO;
        _videoPlayerView.pauseButton.hidden = YES;
        [self videoPause];
    }
}

#pragma mark - slider Value Changed
- (void)progressSliderValueChanged:(UISlider *)slider {
    [self videoPause];
    [self stopDurationTimer];
    double currentTime = floor(slider.value);
    double totalTime = floor(CMTimeGetSeconds(self.avPlayerItem.asset.duration));
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalTime / 60.0);;
    double secondsRemaining = floor(fmod(totalTime, 60.0));;
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    
    self.videoPlayerView.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString];
}

#pragma mark - slider value set
- (void)startDurationTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)monitorVideoPlayback {
    // @field timescale The timescale of the CMTime. value/timescale = seconds.
    double currentTime = floor(self.avPlayerItem.currentTime.value / self.avPlayerItem.currentTime.timescale);
    double totalTime = CMTimeGetSeconds(self.avPlayerItem.asset.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    self.videoPlayerView.progressSlider.value = currentTime;
}

- (void)stopDurationTimer {
    [self.timer invalidate];
}

#pragma mark - 设置监听
- (void)configObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inAVPlayerItemTimeJumpedNotification) name:AVPlayerItemTimeJumpedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inAVPlayerItemDidPlayToEndTimeNotification) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    // AVPlayerItemStatusReadyToPlay
    // KVO
    [self.avPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)inAVPlayerItemTimeJumpedNotification {
    [self startDurationTimer];
    [self.videoPlayerView.indicatorView stopAnimating];
    [self.videoPlayerView autoFadeOutControlBar];
}

- (void)inAVPlayerItemDidPlayToEndTimeNotification {
    // 播放结束之后暂停
    [self videoPause];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.avPlayerItem.status) {
            case AVPlayerItemStatusReadyToPlay: {
                [self stopDurationTimer];
                [self.videoPlayerView.indicatorView startAnimating];
            }
                break;
            case AVPlayerItemStatusFailed:{
                [self.videoPlayerView.indicatorView startAnimating];
            }
            default:
                break;
        }
    }
}

#pragma mark - 关闭
- (void)closeButtonClick {
    [self stopDurationTimer];
    [self videoPause];
    [UIView animateWithDuration:kVideoPlayerAnimationTimeInterval animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (self.dismissCompleteBlock) {
            self.dismissCompleteBlock();
        }
    }];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - 全屏处理
- (void)fullScreenButtonClick {
    if (self.isFullscreenMode) {
        return;
    }
    self.originFrame = self.view.frame;
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = frame;
        self.playLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    } completion:^(BOOL finished) {
        self.isFullscreenMode = YES;
        self.videoPlayerView.fullScreenButton.hidden = YES;
        self.videoPlayerView.shrinkScreenButton.hidden = NO;
    }];
}

- (void)shrinkScreenButtonClick {
    if (!self.isFullscreenMode) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setTransform:CGAffineTransformIdentity];
        self.frame = self.originFrame;
        self.playLayer.frame = self.originFrame;
    } completion:^(BOOL finished) {
        self.isFullscreenMode = NO;
        self.videoPlayerView.fullScreenButton.hidden = NO;
        self.videoPlayerView.shrinkScreenButton.hidden = YES;
    }];
}

- (void)setFrame:(CGRect)frame {
    [self.view setFrame:frame];
    [self.videoPlayerView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.videoPlayerView setNeedsLayout];
    [self.videoPlayerView layoutIfNeeded];
}

@end
