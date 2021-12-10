//
//  ReactNativeJuseRTC.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/9.
//

#import "ReactNativeJuseRTC.h"

@implementation ReactNativeJuseRTC

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()


//设置网络环境
RCT_EXPORT_METHOD(setEnv:(NSString*)isDev){

    

}

//主动呼叫
RCT_EXPORT_METHOD(signalingCall:(NSDictionary*)data){

    
    
}

//传入音视频的token
RCT_EXPORT_METHOD(getAvchatToken:(NSDictionary*)data){

    
    
}

//被动呼叫
RCT_EXPORT_METHOD(signalingNotify:(NSDictionary*)data){
    
    
    
}

//多设备同步
RCT_EXPORT_METHOD(signalingMutilClientSyncNotify:(NSDictionary*)data){
 
    
   
}

//用户同步
RCT_EXPORT_METHOD(signalingMembersSyncNotify:(NSDictionary*)data){

    
}

//未读消息
RCT_EXPORT_METHOD(signalingUnreadMessageSyncNotify:(NSDictionary*)data){

    
}


//存储rn端传过来的数据到userdefaults
-(void)writeToUserDefaultSignalingCall:(NSDictionary*)data{
    
    // 线程锁,防止多处调用产生并发问题
    __weak ReactNativeJuseRTC *weakSelf = self;
       @synchronized (weakSelf) {
           if (data) {
               NSString *token = [data objectForKey:@"token"];
               NSString *ext = [data objectForKey:@"ext"];
               NSString *account = [data objectForKey:@"account"];
               NSString *channelId = [data objectForKey:@"channelId"];
               NSString *requestId = [data objectForKey:@"requestId"];
               
               NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
               [userDefault setObject:data forKey:@"data"];
               [userDefault setObject:ext forKey:@"ext"];
               [userDefault setObject:token forKey:@"token"];
               [userDefault setObject:account forKey:@"account"];
               [userDefault setObject:channelId forKey:@"channelId"];
               [userDefault setObject:requestId forKey:@"requestId"];
               [userDefault synchronize];
           }
       }
}



@end
