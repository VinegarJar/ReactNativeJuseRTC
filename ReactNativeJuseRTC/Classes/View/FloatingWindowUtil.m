//
//  FloatingWindowUtil.m
//  XXYFloatingWindow
//
//  Created by 888 on 2021/12/8.
//  Copyright © 2021 Jason_Xu. All rights reserved.
//

#import "FloatingWindowUtil.h"
#import "FloatingWindowView.h"


@interface FloatingWindowUtil ()<FloatingWindowViewDelegate>

// 通话管理对象
@property (nonatomic, strong)FloatingWindowView *currentCallManager;



@end

@implementation FloatingWindowUtil



+ (instancetype)shareInstance{
    static FloatingWindowUtil *floatViewUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        floatViewUtil = [[FloatingWindowUtil alloc] init];
    });
    return floatViewUtil;
}



//单例操作

- (void)xxy_startCallWithNumbers{
    
    [self.currentCallManager.callManagerView removeFromSuperview];
    // 1.初始化通话管理
    self.currentCallManager = [[FloatingWindowView alloc] initWithSignalingCall:@{}];
    
    
    
    self.currentCallManager.callManagerView.frame = [UIScreen mainScreen].bounds;
    // 2.设置代理
    self.currentCallManager.delegate = self;
    self.currentCallManager.callManagerView.alpha = .0f;
    

    
    [UIView animateWithDuration:.3f animations:^{
        [[UIApplication sharedApplication].delegate.window addSubview:self.currentCallManager.callManagerView];
        self.currentCallManager.callManagerView.alpha = 1.0f;
    } completion:^(BOOL finished) {

        // 10.开始通话或视频
        [self.currentCallManager xxy_startCallManagerWithNumbers];
    }];
}


//悬浮窗口消失
- (void)xxy_dismissCurrentFloatView{
    [UIView animateWithDuration:.3f animations:^{
        self.currentCallManager.callManagerView.alpha = .0f;
    } completion:^(BOOL finished) {
        [self.currentCallManager.callManagerView removeFromSuperview];
        self.currentCallManager = nil;
    }];
}

#pragma mark - CallManagerDelegate
//结束通话操作
- (void)xxy_endCallButtonOperation{
    [self xxy_dismissCurrentFloatView];
}


@end
