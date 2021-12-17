//
//  FloatingWindowUtil.m
//  XXYFloatingWindow
//
//  Created by 888 on 2021/12/8.
//  Copyright © 2021 Jason_Xu. All rights reserved.

#import "FloatingWindowUtil.h"
#import "FloatingWindowView.h"
#import "HSNetworkTool.h"
#import "StringToDic.h"
#import "Safety.h"

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

- (void)setSignaDoctor:(BOOL)signaDoctor{
    _signaDoctor = signaDoctor;
    //存储是否是医生端signaDoctor到userdefaults
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:signaDoctor] forKey:@"signaDoctor"];
    [userDefault synchronize];
}


- (void)setDevelopmentUrl:(NSString *)developmentUrl{
  _developmentUrl = developmentUrl;
}

- (void)setSignaUserInfo:(NSDictionary *)signaUserInfo{
    //存储token数据到userdefaults
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *token = [signaUserInfo objectForKey:@"token"];
    [userDefault setObject:token forKey:@"token"];
    [userDefault synchronize];
    _signaUserInfo = signaUserInfo;
}


-(FloatingWindowView*)floatWindow{
    if (!_floatWindow) {
        [_floatWindow.callRTCView removeFromSuperview];
        _floatWindow = [[FloatingWindowView alloc]init];
    }
    return  _floatWindow;
}

//主动呼叫
- (void)signalingCall{
    [self.floatWindow startCallWithSignaling:NO];
    [self showCallRTCView];
    [self requestToken];
}

//被呼叫
- (void)signalingNotify{
    
    NSString *eventType = [ _signaUserInfo objectForKey:@"eventType"];
    if([eventType isEqual: @"INVITE"]){
        [self.floatWindow startCallWithSignaling:YES];
        [self requestToken];
        [self showCallRTCView];
    }else{
      [self.floatWindow.callRTCView signalingNotifyJoinWithEventType:eventType];
    }
}

- (void)showCallRTCView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_floatWindow.callRTCView signalingUserInfo:self->_signaUserInfo];
         self.floatWindow.callRTCView.frame = [UIScreen mainScreen].bounds;
         self.floatWindow.callRTCView.delegate = self;
         self.floatWindow.callRTCView.alpha = .0f;
         [UIView animateWithDuration:0.25 animations:^{
             self.floatWindow.callRTCView.alpha = 1.0f;
         } completion:^(BOOL finished) {
             self->_floatWindow.callRTCView.transform = CGAffineTransformIdentity;
             [[UIApplication sharedApplication].delegate.window addSubview:self.floatWindow.callRTCView];
         }];
  });
}

//悬浮窗口消失
- (void)dismissCurrentFloatView{
    
    if (self.floatWindow) {
        [UIView animateWithDuration:.3f animations:^{
            self.floatWindow.callRTCView.alpha = .0f;
        } completion:^(BOOL finished) {
            [self.floatWindow.callRTCView removeFromSuperview];
            self.floatWindow = nil;
        }];
    }
}

#pragma mark - CallManagerDelegate
//结束通话操作
- (void)endCallButtonHandle:(NSString *)titleLabel{
    if([titleLabel  isEqual: @"取消"]){
        _callType = RTCCANCEL;
        [self sendEmitEvent];
    }else if([titleLabel  isEqual: @"挂断"]){
        _callType = RTCCLOSE;
        [self sendEmitEvent];
    }else if([titleLabel  isEqual: @"拒绝"]){
        _callType = RTCREJECT;
        [self sendEmitEvent];
    }
    [self dismissCurrentFloatView];
}

//接受通话请求
- (void)acceptCallHandle{
    _callType = RTCACCEPT;
    [self sendEmitEvent];
}

//通话销毁
- (void)destroyCallHandle{
    _callType = RTCDESTORY;
    [self dismissCurrentFloatView];
    [self sendEmitEvent];
}

//无应答
-(void)noAnswerCallHandle{
    _callType = RTCCANCEL;
    [self sendEmitEvent];
}

// 对方正忙
- (void)delayMethodCallHandle{
    [self sendVideoStatus:5];
}

//通过Notification将送消息到发送到RN端
-(void)postNotification:(NSDictionary*)payload{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"event-emitted" object:self userInfo:payload];
}


/**
@ 发送视频状态到后端,音视频状态（1:已支付未开始 2：视频中 ，3：已取消  4：对方无应答 5：对方忙线中 6：对方已拒绝,7视频通话完成
*/
- (void) requestUpdateVideoStatus:(NSDictionary *) params{
    [[HSNetworkTool shareInstance] requestPOST:@"/updateVideoStatus"
          params:params
    successBlock:^(NSDictionary * _Nonnull responseObject) {
        NSInteger resultRep = [[responseObject objectForKey:@"code"] integerValue];
        if(resultRep  == 200){
            NSLog(@"发送视频状态到后端-->%@",responseObject);
        }
    }
    failBlock:^(NSError * _Nonnull error) {}];
}


//获取呼叫token和userId
- (void)requestToken{
  HSNetworkTool *NetworkTool = [HSNetworkTool shareInstance];
  NetworkTool.requestURL = [self matchingAppServerUrl];
  [NetworkTool requestGET:@"/video/token" params:nil successBlock:^(NSDictionary *responseObject) {
        NSInteger resultRep = [[responseObject objectForKey:@"code"] integerValue];
        if(resultRep  == 200){
            NSDictionary *data = [responseObject objectForKey:@"data"];
            [self->_floatWindow.callRTCView setCallinfoToken:data];
        }
    } failBlock:^(NSError *error) {
        
    }];
}


- (NSString *)matchingAppServerUrl{
  
    NSString *baseUrl;
    if (_signaDoctor) {
        if([_developmentUrl isEqual:@"development"]){
            baseUrl = @"https://ihtest.gooeto.com/API/doctor";
        }else if([_developmentUrl isEqual:@"pre-release"]){
            baseUrl = @"https://prem.gooeto120.com/API/doctor";
        }else{
            baseUrl = @"https://m.gooeto120.com/API/doctor";
        }
    }else{
        if([ _developmentUrl isEqual:@"development"]){
            baseUrl = @"https://strong.ylccmp.com/API/user";
        }else if([_developmentUrl isEqual:@"pre-release"]){
            baseUrl = @"https://prem.gooeto120.com/API/user";
        }else{
           baseUrl = @"https://m.gooeto120.com/API/user";
        }
    }
    return baseUrl;
}







//组装发送消息到RN端dict参数
- (void)sendEmitEvent{
    //解析rn端传过来的数据字典
    NSDictionary *ext = [StringToDic dictionaryWithJsonString: [_signaUserInfo  objectForKey:@"ext"]];
    NSString *channelId = [_signaUserInfo objectForKey:@"channelId"];
    NSString *requestId = [_signaUserInfo objectForKey:@"requestId"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict SafetySetObject:channelId  forKey:@"channelId"];
    [dict SafetySetObject:requestId  forKey:@"requestId"];
    [dict SafetySetObject:[ext objectForKey:@"orderId"]  forKey:@"orderId"];
  
    switch (_callType) {
      case RTCACCEPT:{
          [dict SafetySetObject:@"ACCEPT"  forKey:@"eventType"];
          [dict SafetySetObject:[_signaUserInfo objectForKey:@"creator"]  forKey:@"account"];
          [self postNotification:dict];
      }break;
       
      case RTCCANCEL:{
          [dict SafetySetObject:@"CANCEL"  forKey:@"eventType"];
          [dict SafetySetObject:[_signaUserInfo objectForKey:@"account"]  forKey:@"account"];
          [self postNotification:dict];
          [self sendVideoStatus:4];
      }break;
          
      case RTCCLOSE:{
          [dict SafetySetObject:@"CLOSE"  forKey:@"eventType"];
          [dict SafetySetObject:[_signaUserInfo objectForKey:@"account"]  forKey:@"account"];
          [self postNotification:dict];
          [self sendVideoStatus:7];
      }break;
      
      case RTCREJECT:{
          [dict SafetySetObject:@"REJECT"  forKey:@"eventType"];
          [dict SafetySetObject:[_signaUserInfo objectForKey:@"creator"]  forKey:@"account"];
          [self postNotification:dict];
          [self sendVideoStatus:6];
      }break;
      
      case RTCDESTORY:{
          [dict SafetySetObject:@"DESTORY"  forKey:@"eventType"];
          [self postNotification:dict];
      }break;
          
      case RTCVIDEOSTATUS:{
          [dict SafetySetObject:@"VIDEO_STATUS"  forKey:@"eventType"];
      }break;
          
      default:
          break;
  }
}


//组装发送到后端的dict请求参数
- (void)sendVideoStatus:(int)status{
    
    //解析rn端传过来的数据字典
    NSDictionary *ext = [StringToDic dictionaryWithJsonString: [_signaUserInfo  objectForKey:@"ext"]];
    NSString *channelId = [_signaUserInfo objectForKey:@"channelId"];
    NSString *requestId = [_signaUserInfo objectForKey:@"requestId"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict SafetySetObject:channelId  forKey:@"channelId"];
    [dict SafetySetObject:requestId  forKey:@"requestId"];
    [dict SafetySetObject:[ext objectForKey:@"orderId"]  forKey:@"orderId"];
    [dict SafetySetObject:@"VIDEO_STATUS"  forKey:@"eventType"];
    [dict SafetySetObject:[ext objectForKey:@"initiator"]?[ext objectForKey:@"initiator"]:[NSNull new]  forKey:@"initiator"];
    [dict SafetySetObject:[ext objectForKey:@"videoType"]?[ext objectForKey:@"videoType"]:[NSNull new]  forKey:@"videoType"];
    [dict SafetySetObject:[NSNumber numberWithInt:status]  forKey:@"videoStatus"];
    
    if (status == 6) {
        [dict SafetySetObject:[_signaUserInfo objectForKey:@"creator"]  forKey:@"account"];
    }else if(status == 7){
        //通话时长传递给后端
        int seconds = self.floatWindow.callRTCView.btnContainerView.seconds;
        [dict SafetySetObject:[NSNumber numberWithInt:seconds]  forKey:@"duration"];
    }else{
        [dict SafetySetObject:[_signaUserInfo objectForKey:@"account"]  forKey:@"account"];
    }
    
  //发送消息到RN端
  [self postNotification:dict];
  //调用接口请求发送视频状态到后端
  if([[ext objectForKey:@"videoType"] isEqual:@"consultant"]){
   }else {
     [self requestUpdateVideoStatus:dict];
  }
    
}

- (void)signalingMutilClientSyncNotify{
    [self.floatWindow.callRTCView signalingMutilClientSyncNotify];
}

@end
