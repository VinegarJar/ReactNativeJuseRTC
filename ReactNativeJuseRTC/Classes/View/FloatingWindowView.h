//
//  FloatingWindowView.h
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/8.
//

#import <Foundation/Foundation.h>
#import "RTCWindowView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FloatingWindowViewDelegate <NSObject>

/**
 结束通话
 */
- (void)xxy_endCallButtonOperation;

@end

@interface FloatingWindowView : NSObject

//通话视图管理view
@property (nonatomic, strong) RTCWindowView *callManagerView;

@property (nonatomic, weak) id <FloatingWindowViewDelegate> delegate;

- (instancetype)initWithSignalingCall:(NSDictionary*)data;

/**
 开始通话
 */
- (void)xxy_startCallManagerWithNumbers;
@end

NS_ASSUME_NONNULL_END
