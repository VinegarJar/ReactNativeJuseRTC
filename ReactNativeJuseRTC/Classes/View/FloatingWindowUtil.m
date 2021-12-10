//
//  FloatingWindowUtil.m
//  XXYFloatingWindow
//
//  Created by 888 on 2021/12/8.
//  Copyright © 2021 Jason_Xu. All rights reserved.
//

#import "FloatingWindowUtil.h"
#import "FloatingWindowView.h"


@interface FloatingWindowUtil ()<RTCWindowViewDelegate>

// 通话管理对象
@property (nonatomic, strong)FloatingWindowView *floatWindow;



@end

@implementation FloatingWindowUtil

- (instancetype)init{
    self = [super init];
    if (self) {
        //通话视屏初始化SDK
        [self.floatWindow setupRTCEngine];
    }
    return self;
}

+ (instancetype)shareInstance{
    static FloatingWindowUtil *floatViewUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatViewUtil = [[FloatingWindowUtil alloc] init];
    });
    return floatViewUtil;
}



-(FloatingWindowView*)floatWindow{
    if (!_floatWindow) {
        [_floatWindow.callRTCView removeFromSuperview];
        _floatWindow = [[FloatingWindowView alloc] initWithSignalingCall:YES];
        _floatWindow.callRTCView.frame = [UIScreen mainScreen].bounds;
        _floatWindow.callRTCView.delegate = self;
        _floatWindow.callRTCView.alpha = .0f;
    }
    return  _floatWindow;
}



- (void)startSignalingCall:(BOOL)signalingCall{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.floatWindow.callRTCView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
          self->_floatWindow.callRTCView.transform = CGAffineTransformIdentity;
         [[UIApplication sharedApplication].delegate.window addSubview:self.floatWindow.callRTCView];
        }];
       
    }];
}


//悬浮窗口消失
- (void)dismissCurrentFloatView{
    [UIView animateWithDuration:.3f animations:^{
        self.floatWindow.callRTCView.alpha = .0f;
    } completion:^(BOOL finished) {
        [self.floatWindow.callRTCView removeFromSuperview];
        self.floatWindow = nil;
    }];
}

#pragma mark - CallManagerDelegate
//结束通话操作
- (void)endCallButtonHandle{
    [self dismissCurrentFloatView];
}


@end
