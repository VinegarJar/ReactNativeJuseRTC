//
//  RTCButton.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/10.
//

#import "RTCButton.h"

@implementation RTCButton


- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)noHandleImageName
{
    self = [super init];
    if (self) {

        if (title) {
            // button.titleEdgeInsets = UIEdgeInsetsMake(10, 16, 10, 200 - 62);
            [self setTitle:title forState:UIControlStateNormal];
            self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
//            self.titleEdgeInsets = UIEdgeInsetsMake(10, 16, 10, 200 - 62);
        }
        if (noHandleImageName) {
          [self setImage:[UIImage bundleForImage:noHandleImageName] forState:UIControlStateNormal];
//          self.imageEdgeInsets = UIEdgeInsetsMake(27, 200 - 30, 27, 10);
        }
    }
    return self;
}



@end
