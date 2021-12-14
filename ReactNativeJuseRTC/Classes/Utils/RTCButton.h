//
//  RTCButton.h
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/10.
// 

#import <UIKit/UIKit.h>
#import "UIImage+TExtension.h"
#import "FloatConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface RTCButton : UIView
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)noHandleImageName;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel * title;
@end

NS_ASSUME_NONNULL_END
