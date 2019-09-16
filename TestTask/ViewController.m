//
//  ViewController.m
//  TestTask
//
//  Created by Olga Nesterenko on 16.09.2019.
//  Copyright © 2019 test. All rights reserved.
//

#import "ViewController.h"

@import AVFoundation;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (nonatomic) AVPlayer *audioStreamPlayer;

@end

@implementation ViewController

static NSString * const kStreamUrlString = @"https://vip2.fastcast4u.com/proxy/wsjfholiday?mp=/1";
static NSString * const kScaleAnimationKey = @"kScaleAnimation";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupStreaming];
    [self setupAppStateNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.audioStreamPlayer play];
    [self startAnimation];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)setupStreaming {
    NSError *setCategoryError;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (setCategoryError != nil) {
        NSLog(@"Error setting AVAudioSession category: %@", setCategoryError.localizedDescription);
    }
    
    NSError *setActiveError;
    
    [[AVAudioSession sharedInstance] setActive:YES error:&setActiveError];
    if (setActiveError != nil) {
        NSLog(@"Error setting AVAudioSession active: %@", setActiveError.localizedDescription);
    }
    
    self.audioStreamPlayer = [AVPlayer playerWithURL: [NSURL URLWithString:kStreamUrlString]];
    
}

- (void)setupAppStateNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self startAnimation];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self stopAnimation];
                                                  }];
}

- (void)startAnimation {
    if ([self.contentImageView.layer animationForKey:kScaleAnimationKey] != nil) {
        [self stopAnimation];
    }
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.duration = 5.0;
    scaleAnimation.repeatCount = HUGE_VALF;
    scaleAnimation.fromValue = @1.0;
    scaleAnimation.toValue = @1.5;
    [self.contentImageView.layer addAnimation:scaleAnimation forKey:kScaleAnimationKey];
}

- (void)stopAnimation {
    [self.contentImageView.layer removeAnimationForKey:kScaleAnimationKey];
}

@end
