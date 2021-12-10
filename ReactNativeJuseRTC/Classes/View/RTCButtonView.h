//
//  RTCButtonView.h
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/10.
//

#import <UIKit/UIKit.h>
#import "RTCButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTCButtonView : UIView
/** 前置、后置摄像头切换按钮 */
@property (strong, nonatomic)RTCButton *swichBtn;
/** 挂断按钮 */
@property (strong, nonatomic)RTCButton *hangupBtn;
/** 接听按钮 */
@property (strong, nonatomic)RTCButton *answerBtn;
//被呼叫or呼叫
@property (assign, nonatomic) BOOL  signaCall;

- (instancetype)initWithFrame:(CGRect)frame signaCall:(BOOL)signaCall;
-(void)setHangupBtnframe;
@end

NS_ASSUME_NONNULL_END
