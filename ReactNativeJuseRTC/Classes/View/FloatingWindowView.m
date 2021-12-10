//
//  FloatingWindowView.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import "FloatingWindowView.h"


@interface FloatingWindowView ()<NERtcEngineDelegateEx>

@end


@implementation FloatingWindowView




- (instancetype)initWithSignalingCall:(BOOL)signalingCall{
    self = [super init];
    if (self) {
        self.callRTCView = [[RTCWindowView alloc] initWithRTCWindowViewSignalingCall:signalingCall];
        
    }
    return self;
}


#pragma mark - 通话视屏初始化SDK
- (void)setupRTCEngine{
    
    NERtcEngine *coreEngine = [NERtcEngine sharedEngine];
    NERtcEngineContext *context = [[NERtcEngineContext alloc] init];
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    context.logSetting.logDir = documentDirectory;
    context.engineDelegate = self;
    context.appKey = @"2a7643456d3a3c65ee66f8bd2d4a6a0c";
    [coreEngine setParameters:@{
      @"kNERtcKeyRecordType":@(0),
      @"kNERtcKeyRecordAudioEnabled":@(YES),
      @"kNERtcKeyRecordVideoEnabled":@(YES),

    }];
    [coreEngine setupEngineWithContext:context];
    [coreEngine enableLocalAudio:YES];
    [coreEngine enableLocalVideo:YES];
    NERtcVideoEncodeConfiguration *config = [[NERtcVideoEncodeConfiguration alloc] init];
    config.maxProfile = kNERtcVideoProfileHD720P;
    [coreEngine setLocalVideoConfig:config];
}



#pragma mark - SDK回调（含义请参考NERtcEngineDelegateEx定义）
- (void)onNERtcEngineUserDidJoinWithUserID:(uint64_t)userID
                                  userName:(NSString *)userName {
//  [self.presentView onNERtcEngineUserDidJoinWithUserID:userID userName:userName];
}

- (void)onNERtcEngineUserVideoDidStartWithUserID:(uint64_t)userID
                                    videoProfile:(NERtcVideoProfileType)profile {
//  [self.presentView onNERtcEngineUserVideoDidStartWithUserID:userID videoProfile:profile];
}

- (void)onNERtcEngineUserVideoDidStop:(uint64_t)userID {

}

- (void)onNERtcEngineUserDidLeaveWithUserID:(uint64_t)userID
                                     reason:(NERtcSessionLeaveReason)reason {

//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setObject:@"0" forKey:@"isInitSDK"];
//
//    //如果远端的人离开了，离开房间后挂断
//    [NERtcEngine.sharedEngine leaveChannel];
//    [self.presentView dismiss];
}


@end
