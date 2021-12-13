//
//  FloatingWindowUtil.m
//  XXYFloatingWindow
//
//  Created by 888 on 2021/12/8.
//  Copyright © 2021 Jason_Xu. All rights reserved.
//

#import "FloatingWindowUtil.h"
#import "FloatingWindowView.h"
#import "HSNetworkTool.h"
#import "StringToDic.h"

@interface FloatingWindowUtil ()<RTCWindowViewDelegate>

// 通话管理对象
@property (nonatomic, strong)FloatingWindowView *floatWindow;



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


- (void)setDevelopmentUrl:(NSString *)developmentUrl{
  _developmentUrl = developmentUrl;
}


- (void)setSignaUserInfo:(NSDictionary *)signaUserInfo{
    _signaUserInfo = signaUserInfo;
}


-(FloatingWindowView*)floatWindow{
    if (!_floatWindow) {
        [_floatWindow.callRTCView removeFromSuperview];
        _floatWindow = [[FloatingWindowView alloc]init];
    }
    return  _floatWindow;
}


- (void)startSignalingCall:(BOOL)signalingCall{
    
    [self.floatWindow startCallWithSignaling:signalingCall];
    self.floatWindow.callRTCView.frame = [UIScreen mainScreen].bounds;
    self.floatWindow.callRTCView.delegate = self;
    self.floatWindow.callRTCView.alpha = .0f;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.floatWindow.callRTCView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
          self->_floatWindow.callRTCView.transform = CGAffineTransformIdentity;
         [[UIApplication sharedApplication].delegate.window addSubview:self.floatWindow.callRTCView];
        }];
    }];

}


//原生获取数据
- (void)requestToken{

  HSNetworkTool *NetworkTool = [HSNetworkTool shareInstance];

  if([ _developmentUrl isEqual:@"development"]){
    NetworkTool.requestURL = @"https://strong.ylccmp.com/API/user";
  }else if([_developmentUrl isEqual:@"pre-release"]){
    NetworkTool.requestURL = @"https://prem.gooeto120.com/API/user";
  }else{
    NetworkTool.requestURL = @"https://m.gooeto120.com/API/user";
  }

    [NetworkTool requestGET:@"/video/token" params:nil successBlock:^(NSDictionary *responseObject) {

        NSInteger resultRep = [[responseObject objectForKey:@"code"] integerValue];
        if(resultRep  == 200){
            NSDictionary *data = [responseObject objectForKey:@"data"];
            [self->_floatWindow.callRTCView signalingCallinfo:data userInfo:self->_signaUserInfo];
        }else{
            [self->_floatWindow.callRTCView signalingCallinfo:@{} userInfo:self->_signaUserInfo];
        }
        
    } failBlock:^(NSError *error) {
        
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


//接受通话请求
- (void)acceptCallHandle{
    
}

//通话销毁
- (void)destroyCallHandle{
    
}

@end
