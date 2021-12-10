//
//  RTCAlertView.h
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/10.
//  

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RTCAlertViewDelegate <NSObject>

@required
- (void)cancelCallHandle;

@end

@interface RTCAlertView : UIView
@property (nonatomic, weak) id<RTCAlertViewDelegate>delegate;
- (instancetype)initWithAlertView;
@end

NS_ASSUME_NONNULL_END
