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


@interface  RTCWindowView ()<UIGestureRecognizerDelegate,RTCAlertViewDelegate,NERtcEngineDelegateEx>
@property (nonatomic, strong) UIButton *smallScreenButton;

@property (nonatomic, strong) NTESDemoUserModel *localCanvas;  //本地
@property (nonatomic, strong) NTESDemoUserModel *remoteCanvas; //远端


//被呼叫or呼叫
@property (assign, nonatomic) BOOL  signalingCall;
/** 未接通时背景视图 */
@property (strong, nonatomic)UIImageView  *bgImageView;
/** 对方头像图片 */
@property (strong, nonatomic)UIImageView *avaImage;
/** 底部按钮容器视图 */
@property (strong, nonatomic) RTCButtonView *btnContainerView;
//振动计时器
@property (nonatomic,strong) NSTimer *vibrationTimer;

/** 对方的视频画面 */
@property (strong, nonatomic)UIView  *adverseImageView;

@end


@implementation RTCWindowView


//建立本地canvas模型，表示已经接通
- (NERtcVideoCanvas *)setupLocalCanvas {
    [_audioPlayer stop];
    if(_localCanvas == nil){
      _localCanvas = [[NTESDemoUserModel alloc] init];
    }
    _localCanvas.uid = [_userID intValue];
    _localCanvas.renderContainer = self.adverseImageView;
    return [_localCanvas setupCanvas];
}

//开启本地预览
- (NERtcVideoCanvas *)startVideoPreview {
  if(_localCanvas == nil){
    _localCanvas = [[NTESDemoUserModel alloc] init];
  }
  _localCanvas.uid = [_userID intValue];
  _localCanvas.renderContainer = self.adverseImageView;
  return [_localCanvas setupCanvas];
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
    
}

- (void)onNERtcEngineUserVideoDidStartWithUserID:(uint64_t)userID
                                    videoProfile:(NERtcVideoProfileType)profile {

}

- (void)onNERtcEngineUserVideoDidStop:(uint64_t)userID {

}

- (void)onNERtcEngineUserDidLeaveWithUserID:(uint64_t)userID
                                     reason:(NERtcSessionLeaveReason)reason {

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
    self.backgroundColor = kRGBA(0, 0, 0, .8);
    [self addSubviews];
    [self addGestureToWindowView];
}



- (void)addSubviews{

    //切换button
    self.smallScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.smallScreenButton.backgroundColor = [UIColor clearColor];
    [self.smallScreenButton addTarget:self action:@selector(floatingWindowButtonWithSender:) forControlEvents:UIControlEventTouchUpInside];
    [self.smallScreenButton setImage:[UIImage bundleForImage:@"cut_normal"] forState:UIControlStateNormal];
    self.smallScreenButton.tag = 10000;
    self.smallScreenButton.frame = CGRectMake(50, 30, 50 , 50);
    [self addSubview:self.smallScreenButton];
    

    
    
    if (_signalingCall) { // 视频通话时,被对方呼叫UI初始化
        if ([self internetStatus]) {
            RTCAlertView *alertVie = [[ RTCAlertView alloc]initWithAlertView];
            alertVie.delegate = self;
            [self addSubview:alertVie];
        }
      
        _vibrationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playkSystemSound) userInfo:nil repeats:YES];
        
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = CGRectMake(50, 300, 100, 100);
//        [self addSubview:effectView];
        
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
}

-(void)show{
    self.btnContainerView.hidden = NO;
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(endCallButtonHandle)]) {
        [self.delegate endCallButtonHandle];
    }
    
    [self dismiss];
}


//接听视频通话操作
- (void)answerClick{
    
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
}



#pragma  mark -点击缩小窗口
- (void)floatingWindowButtonWithSender:(UIButton *)sender{

    [UIView animateWithDuration:0.3 animations:^{
        [self hide];
        self.frame = CGRectMake(ScreenW-WindowDisplayWidth-20, 20, WindowDisplayWidth, WindowDisplayHeight);
    }completion:^(BOOL finished) {
        self->_state = RTCWindowFloatingWindow;
    }];
}

#pragma mark --切换视图全屏或小窗口
- (void)callViewTapHandle:(UITapGestureRecognizer *)callViewTap{
    if (self->_state==RTCWindowFloatingWindow) {
 
        [UIView animateWithDuration:.3f animations:^{
            self.frame = ScreenBounds;
        } completion:^(BOOL finished) {
            //点击屏幕 全屏状态 设置小窗口操作按钮
            [self show];
            self->_state =  RTCWindowDefault;
        }];
    }else{
        NSLog(@"什么时候触发---------->>>>>进去全屏幕,,,我在屏幕上勒");
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
-(void)signalingCallinfor:(NSDictionary *)data{
    
    
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
    
    [_audioPlayer stop];
    _audioPlayer = nil;
    
    [self.vibrationTimer invalidate];
    [self.btnContainerView.myTimer invalidate];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [NERtcEngine destroyEngine];
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



@end
