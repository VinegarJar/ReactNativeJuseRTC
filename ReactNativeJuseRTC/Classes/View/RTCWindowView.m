//
//  RTCWindowView.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import "RTCWindowView.h"
#import "Reachability.h"
#import "RTCAlertView.h"
#import "RTCButtonView.h"
#import "NTESDemoUserModel.h"
#import "HSNetworkTool.h"
#import "WHToast.h"


@interface  RTCWindowView ()<UIGestureRecognizerDelegate,RTCAlertViewDelegate,NERtcEngineDelegateEx>
@property (nonatomic, strong) UIButton *smallScreenButton;

/** 本地canvas */
@property (strong, nonatomic)NERtcVideoCanvas *localVideoCanvas;
/** 远端canvasr */
@property (strong, nonatomic) NERtcVideoCanvas *remoteVideoCanvas;


@property (nonatomic, strong) NTESDemoUserModel *localCanvas;  //本地
@property (nonatomic, strong) NTESDemoUserModel *remoteCanvas; //远端

//被呼叫or呼叫
@property (assign, nonatomic) BOOL  signalingCall;

/** 底部按钮容器视图 */
@property (strong, nonatomic) RTCButtonView *btnContainerView;
//振动计时器
@property (nonatomic,strong) NSTimer *vibrationTimer;
//呼叫未应答
@property (strong, nonatomic)NSTimer *controlTimer;
/** 对方昵称 */
@property (strong, nonatomic) UILabel *nickNameLabel;
/** 对方头像图片 */
@property (strong, nonatomic)UIImageView *toHeadImage;
/** 连接状态，如等待对方接听...、对方已拒绝、语音电话、视频电话 */
@property (strong, nonatomic) UILabel  *connectLabel;

/**自己的视频画面(本地渲染视图) */
@property (strong, nonatomic) UIView *localRender;
/** 对方的视频画面(远端渲染视图) */
@property (strong, nonatomic) UIView *remoteRender;

/** 呼叫房间ID */
@property (copy, nonatomic) NSString *roomID;
/** 本人uid */
@property (copy, nonatomic) NSString *userID;

@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *fromHeadUrl;
@property (copy, nonatomic) NSString *fromUserName;
@property (copy, nonatomic) NSString *toHeadUrl;
@property (copy, nonatomic) NSString *toUserName;
//视频通话有效时间
@property (assign, nonatomic)int duration;



@end



@implementation RTCWindowView

// GCD倒计时
- (void)startCoundown{
    __block int timeout =_duration + 1; //倒计时时间 + 1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout == 60) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WHToast showMessage:@"您的通话时长还有一分钟结束" duration:2 finishHandler:^{}];
            });
          
        }
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hangupClick];
                
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //format of minute
                NSString *str_minute = [NSString stringWithFormat:@"%02d",(timeout%3600)/60];
                  //format of second
                NSString *str_second = [NSString stringWithFormat:@"%02d",timeout%60];
                //format of time
                self->_connectLabel.text = [NSString stringWithFormat:@"%@%@:%@",@"00:",str_minute,str_second];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (UIView *)remoteRender
{
    if (!_remoteRender) {
        _remoteRender = [[UIView alloc]initWithFrame:ScreenBounds];
        _remoteRender.backgroundColor =  [UIColor blackColor];
        _remoteRender.alpha = 0.5;
        [self addSubview:_remoteRender];
    }
    return _remoteRender;
}

-(UIImageView*)toHeadImage{
    if (!_toHeadImage) {
        _toHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW-kMicVideoW-20, 50, kMicVideoW, kMicVideoH)];
        [_toHeadImage setContentMode: UIViewContentModeScaleToFill];
        [_toHeadImage setBackgroundColor: [UIColor clearColor]];
        [self addSubview:_toHeadImage];
    }
    return _toHeadImage;
}

- (UILabel*)nickNameLabel{
    if (!_nickNameLabel) {
        CGFloat paddingX = (ScreenW-kMicVideoW-30-NickWidth);
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX, 50, NickWidth, NickHeight)];
        _nickNameLabel.font = [UIFont systemFontOfSize:17.0f];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_nickNameLabel];
    }
    return _nickNameLabel;
}

- (UILabel*)connectLabel{
    if (!_connectLabel) {
        CGFloat paddingX = (ScreenW-kMicVideoW-30-NickWidth);
        _connectLabel = [[UILabel alloc]initWithFrame:CGRectMake(paddingX,50+NickHeight, NickWidth, NickHeight)];
        if (_signalingCall) {
            _connectLabel.text = @"视频通话";
        }else{
           _connectLabel.text = @"正在等待对接受邀请";
        }
        _connectLabel.font = [UIFont systemFontOfSize:15.0f];
        _connectLabel.textColor = [UIColor whiteColor];
        _connectLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_connectLabel];
    }
    return _connectLabel;
}

-(UIButton*)smallScreenButton{
    if (!_smallScreenButton) {
        _smallScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_smallScreenButton addTarget:self action:@selector(floatingWindowButtonWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _smallScreenButton.imageView.contentMode  = UIViewContentModeScaleToFill;
        [_smallScreenButton setImage:[UIImage bundleForImage:@"cut_normal"] forState:UIControlStateNormal];
        _smallScreenButton.frame = CGRectMake(30, 50, 40 , 40);
        [self addSubview:_smallScreenButton];
        _smallScreenButton.hidden = YES;
    }
    return _smallScreenButton;
}


//建立本地canvas模型，表示已经接通/开启本地预览(显示对方头像)
- (NERtcVideoCanvas *)setupLocalCanvas {
    [_audioPlayer stop];
    if(_localCanvas == nil){
      _localCanvas = [[NTESDemoUserModel alloc] init];
    }
    _localCanvas.uid = [_userID intValue];
    _localCanvas.renderContainer = self.toHeadImage;
    return [_localCanvas setupCanvas];
}

//建立远端canvas模型
- (NERtcVideoCanvas *)setupRemoteCanvasWithUid:(uint64_t)uid {
    _remoteCanvas = [[NTESDemoUserModel alloc] init];
    _remoteCanvas.uid = uid;
    _remoteCanvas.renderContainer = self.remoteRender;
    return [_remoteCanvas setupCanvas];
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


#pragma mark- SDK回调（含义请参考NERtcEngineDelegateEx定义）
- (void)onNERtcEngineUserDidJoinWithUserID:(uint64_t)userID
                                  userName:(NSString *)userName {
    
    //如果已经setup了一个远端的canvas，则不需要再建立了
    if (_remoteCanvas != nil) {
        return;
    }
    //建立远端canvas，用来渲染远端画面
    _remoteVideoCanvas = [self setupRemoteCanvasWithUid:userID];
    [NERtcEngine.sharedEngine setupRemoteVideoCanvas:_remoteVideoCanvas
                                           forUserID:userID];
    
}

- (void)onNERtcEngineUserVideoDidStartWithUserID:(uint64_t)userID
                                    videoProfile:(NERtcVideoProfileType)profile {
    //如果已经订阅过远端视频流，则不需要再订阅了
    if (_remoteCanvas.subscribedVideo) {
        return;
    }
    //订阅远端视频流
    _remoteCanvas.subscribedVideo = YES;
    [NERtcEngine.sharedEngine subscribeRemoteVideo:YES
                                         forUserID:userID
                                        streamType:kNERtcRemoteVideoStreamTypeHigh];
}

- (void)onNERtcEngineUserVideoDidStop:(uint64_t)userID {

}

- (void)onNERtcEngineUserDidLeaveWithUserID:(uint64_t)userID
                                     reason:(NERtcSessionLeaveReason)reason {
    //如果远端的人离开了，重置远端模型和UI
    if (userID == _remoteCanvas.uid) {
        [_remoteCanvas resetCanvas];
        _remoteCanvas = nil;
    }
}



- (instancetype)initWithRTCWindowViewSignalingCall:(BOOL)signalingCall{
    self = [super init];
    if (self) {
        _signalingCall = signalingCall;
        [self initWithsubviewsfloatingWindow];
    }
    return self;
}


//添加基本手势
- (void)addGestureToWindowView{
    //视图点击手势
    UITapGestureRecognizer * callViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callViewTapHandle:)];
    [self addGestureRecognizer:callViewTap];
    //视图右拖动手势
    UIPanGestureRecognizer *callPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipePanGestureHandle:)];
   callPanGesture.delegate = self;
    [self addGestureRecognizer:callPanGesture];

}



-(void)initWithsubviewsfloatingWindow{
    self.backgroundColor =  [UIColor blackColor];
    [self remoteRender];
    [self addSubviews];
    [self addGestureToWindowView];
    if (!_signalingCall) {//自己呼叫对方
        [self performSelector:@selector(noAnswer) withObject:nil afterDelay:30.0];
    }
}


- (void)addSubviews{

    [self toHeadImage];
    [self nickNameLabel];
    [self connectLabel];
    [self smallScreenButton];
    
    if (_signalingCall) { // 视频通话时,被对方呼叫UI初始化
        //呼叫声音初始化调用
        [self.audioPlayer play];
        if ([self internetStatus]) {
            RTCAlertView *alertVie = [[ RTCAlertView alloc]initWithAlertView];
            alertVie.delegate = self;
            [self addSubview:alertVie];
        }
      
        _vibrationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playkSystemSound) userInfo:nil repeats:YES];

        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.35 animations:^{
              self->_btnContainerView.transform = CGAffineTransformIdentity;
            [self addSubview:self.btnContainerView];
            }];
        }];
    }else{ // 视频通话时,呼叫对方UI初始化
        [self addSubview:self.btnContainerView];
    }
    
    

}


//小窗口全部视图隐藏
-(void)hide{
    self.btnContainerView.hidden = YES;
    self.smallScreenButton.hidden = YES;
    self.toHeadImage.hidden = YES;
    self.nickNameLabel.hidden = YES;
    self.connectLabel.hidden = YES;
}

-(void)show{
    self.btnContainerView.hidden = NO;
    self.smallScreenButton.hidden = NO;
    self.toHeadImage.hidden = NO;
    self.nickNameLabel.hidden = NO;
    self.connectLabel.hidden = NO;
    
}


//底部按钮视图区域
- (RTCButtonView *)btnContainerView{
    if (!_btnContainerView) {
        _btnContainerView = [[RTCButtonView alloc]initWithFrame:CGRectMake(0, ScreenH-ContainerH, ScreenW, ContainerH) signaCall:_signalingCall];
        [_btnContainerView.swichBtn.button addTarget:self action:@selector(switchClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnContainerView.hangupBtn.button addTarget:self action:@selector(hangupClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnContainerView.answerBtn.button addTarget:self action:@selector(answerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnContainerView;
}


#pragma mark -- RTCButton点击事件
// 切换前后摄像头
- (void)switchClick{
     [NERtcEngine.sharedEngine switchCamera];
}

//挂断视频通话或者拒接
- (void)hangupClick{

    NSString *title =_btnContainerView.hangupBtn.title.text;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(endCallButtonHandle:)]) {
        [self.delegate endCallButtonHandle:title];
    }
    [self dismiss];
}

//无应答
-(void)noAnswer{
    
    [WHToast showMessage:@"对方无应答" duration:2 finishHandler:^{}];
    [self hangupClick];
}
  

//接听视频通话操作
- (void)answerClick{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(acceptCallHandle)]) {
        [self.delegate acceptCallHandle];
    }
    
    [self stopShakeSound];
    [self joinChannelWithRoom];
    

}


- (void)joinChannelWithRoom{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_smallScreenButton setHidden:NO];
        [self->_btnContainerView  removeAnswerButton];
        [UIView animateWithDuration:0.25 animations:^{
            [self->_btnContainerView replaceHangupButtonframe];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
              self->_btnContainerView.hangupBtn.transform = CGAffineTransformIdentity;
            }];
        }];
        [self->_btnContainerView startTimers];
        [self stopShakeSound];
        self->_nickNameLabel.text = @"有效视频时长";
        [self startCoundown];
    });
    [self joinChannelWithRoomId:self->_roomID userId:self->_userID token:self->_token];
}



//网易云通信加入房间
- (void)joinChannelWithRoomId:(NSString *)roomId
         userId:(NSString *)userId token:(NSString *)token {

    __weak typeof(self) weakSelf = self;
    
    int ivalue = [userId intValue];
    [NERtcEngine.sharedEngine joinChannelWithToken:token
                                        channelName:roomId
                                             myUid:ivalue
                                        completion:^(NSError * _Nullable error, uint64_t channelId, uint64_t elapesd) {
        if (error) {
            
            //加入失败了，弹框之后退出当前页面
            NSString *msg = [NSString stringWithFormat:@"join channel fail.code:%@", @(error.code)];
            NSLog(@"%@", msg);
        } else {
            [self->_audioPlayer stop];
    
            //加入成功，建立本地canvas渲染本地视图
            //加入成功，建立本地canvas渲染本地视图
            self->_localVideoCanvas = [weakSelf setupLocalCanvas];
            [NERtcEngine.sharedEngine setupLocalVideoCanvas:self->_localVideoCanvas];
            
            
        }
    }];

}



- (void)signalingNotifyJoinWithEventType:(NSString *)eventType{
    
    if([eventType isEqualToString:@"REJECT"]){
        //被对方拒接
        [WHToast showMessage:@"对方拒接" duration:2 finishHandler:^{}];
        [self hangupClick];
     }else if([eventType isEqualToString:@"ACCEPT"]){
         //接受邀请
         
     }else if([eventType isEqualToString:@"ROOM_JOIN"]){
         [self joinChannelWithRoom];
    
     }else if([eventType isEqualToString:@"LEAVE"]){
         //离开房间
         [self hangupClick];
     }else if([eventType isEqualToString:@"ROOM_CLOSE"]){
         //关闭房间
       [self hangupClick];
     }else if([eventType isEqualToString:@"finishVideo"]){
       //离开频道，结束或退出通话
       [self hangupClick];
     }else if([eventType isEqualToString:@"CONTROL"]){
         _controlTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
         [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hangupClick) userInfo:nil repeats:NO];
     }else if([eventType isEqualToString:@"CANCEL_INVITE"]){
         //关闭房间
       [self hangupClick];
     }else  if([eventType isEqual: @"INVITE"]){//在线
       [self answerClick];
    }
    
}

-(void)delayMethod{
    
    [WHToast showMessage:@"对方正忙" duration:2 finishHandler:^{}];
}

#pragma  mark -点击缩小窗口
- (void)floatingWindowButtonWithSender:(UIButton *)sender{

    [UIView animateWithDuration:0.3 animations:^{
        [self hide];
        self.frame = CGRectMake(ScreenW-WindowDisplayWidth-20, 20, WindowDisplayWidth, WindowDisplayHeight);
        self->_remoteRender.frame = CGRectMake(0, 0,WindowDisplayWidth, WindowDisplayHeight);
    }completion:^(BOOL finished) {
        self->_state = RTCWindowFloatingWindow;
       
    }];
}


#pragma mark --切换视图全屏或小窗口
- (void)callViewTapHandle:(UITapGestureRecognizer *)callViewTap{
    if (self->_state==RTCWindowFloatingWindow) {
        [UIView animateWithDuration:.3f animations:^{
            self.frame = ScreenBounds;
            self->_remoteRender.frame = ScreenBounds;
        } completion:^(BOOL finished) {
            //点击屏幕 全屏状态 设置小窗口操作按钮
            [self show];
            self->_state =  RTCWindowDefault;
        }];
    }else{
        
    }
}


#pragma mark --拖动视图
- (void)swipePanGestureHandle:(UIPanGestureRecognizer *)recognizer{
    
    if (self->_state==RTCWindowFloatingWindow) {
        switch (recognizer.state) {
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled :{
                [self endPanPlayerViewWhenWindow];
            }
            break;
            case UIGestureRecognizerStateChanged:{
                CGPoint translation = [recognizer translationInView:self];
                CGPoint center = CGPointMake(recognizer.view.center.x+ translation.x,
                             recognizer.view.center.y + translation.y);
               //限制屏幕范围：
                center.y = MAX(recognizer.view.frame.size.height/2, center.y);
                center.y = MIN([UIApplication sharedApplication].delegate.window.size.height - recognizer.view.frame.size.height/2, center.y);
                center.x = MAX(recognizer.view.frame.size.width/2, center.x);
                center.x = MIN([UIApplication sharedApplication].delegate.window.size.width - recognizer.view.frame.size.width/2,center.x);
                recognizer.view.center = center;
                [recognizer setTranslation:CGPointZero inView:[UIApplication sharedApplication].delegate.window];
            }
            break;
            default:
            break;
        }
    }else{
        NSLog(@"------全屏幕窗口-------");
    }
      
}


- (void)endPanPlayerViewWhenWindow{
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint center = self.center;
        self.center = center;
    }];
}


-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        // 1. 获取资源URL
        // 2. 根据资源URL, 创建 AVAudioPlayer 对象
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL bundleForMusic:@"avchat_ring"] error:nil];
        _audioPlayer.numberOfLoops = -1;
        //3. 准备播放(音乐播放的内存空间的开辟等功能)  不写这行代码直接播放也会默认调用prepareToPlay
        [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}


//呼叫信息设置显示
-(void)signalingCallinfo:(NSDictionary *)callinfo userInfo:(NSDictionary *)userInfo{
    
    
    NSDictionary *dic = [StringToDic dictionaryWithJsonString:[userInfo objectForKey:@"ext"]];
    
    
    _roomID = [dic objectForKey:@"orderId"];
    _toUserName = [dic objectForKey:@"toUserName"];
    _toHeadUrl = [dic objectForKey:@"toHeadUrl"];
    _fromUserName = [dic objectForKey:@"fromUserName"];
    _fromHeadUrl = [dic objectForKey:@"fromHeadUrl"];
    _token = [callinfo objectForKey:@"token"];
    _userID = [callinfo objectForKey:@"id"];
    

    
    NSNumber* duration = [dic objectForKey:@"duration"];
    NSLog(@"获取传递时间---->>>>>%@",duration);
    
    //务必在主线程中执行UI刷新
   dispatch_async(dispatch_get_main_queue(), ^{
     
       self->_duration = 600;
 
       if (self->_signalingCall) {
           NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self->_fromHeadUrl]];
           self.toHeadImage.image = [UIImage imageWithData:imgData];
           self.nickNameLabel.text = self->_fromUserName?:@"";
       }else{
          
           NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self->_toHeadUrl]];
           self.toHeadImage.image = [UIImage imageWithData:imgData];
           self.nickNameLabel.text = self->_toUserName?:@"";
       }
       
   });
    

}


//获取网络状态
-(BOOL)internetStatus {
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    BOOL net = YES;
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = NO;
            break;
            
        case ReachableViaWWAN:
             net = YES;
            //net = [self getNetType ];   //判断具体类型
            break;
            
        case NotReachable:
            net = YES;
        default:
            break;
    }
 
    return net;
    
}

//提示框上取消视频通话功能
-(void)cancelCallHandle{
    [self hangupClick];
}


//释放资源
- (void)dismiss{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(destroyCallHandle)]) {
        [self.delegate destroyCallHandle];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NERtcEngine.sharedEngine leaveChannel];
        [NERtcEngine destroyEngine];
    });

    [_controlTimer invalidate];
    _controlTimer = nil;
    [_vibrationTimer invalidate];
    _vibrationTimer = nil;
    
    [_audioPlayer stop];
    _audioPlayer = nil;
    
    [self.vibrationTimer invalidate];
    [self.btnContainerView.myTimer invalidate];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
    [self dismiss];
}


//振动
 - (void)playkSystemSound{
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//停止振动
 -(void)stopShakeSound{

    [_vibrationTimer invalidate];
}

- (void)signalingMutilClientSyncNotify{
    [WHToast showMessage:@"多设备同步" duration:2 finishHandler:^{ }];
    [self hangupClick];
}

@end
