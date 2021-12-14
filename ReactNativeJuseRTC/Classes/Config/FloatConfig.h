//
//  Config.h
//  Pods
//
//  Created by 888 on 2021/12/8.
//

#ifndef  FloatConfig_h
#define  FloatConfig_h

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenBounds [UIScreen mainScreen].bounds

//视频
#define WindowDisplayWidth 100
#define WindowDisplayHeight 100

#define RTCRate     ([UIScreen mainScreen].bounds.size.width / 320.0)

// 底部按钮
#define RTCBtnWidth 60
#define RTCTextHeight 20
#define RTCViewWidth 60
#define RTCViewHeight 80
// 底部按钮容器的高度
#define ContainerH  150

// 视频聊天时，小窗口的宽
#define kMicVideoW   (100 * RTCRate)
// 视频聊天时，小窗口的高
#define kMicVideoH   (120 * RTCRate)

// 视频聊天时，昵称的宽
#define NickWidth   (120 * RTCRate)
// 视频聊天时，昵称的高
#define NickHeight (20 * RTCRate)


// 设置颜色RGB值
#define kRGBColor(a,b,c) [UIColor colorWithRed:(a/255.0) green:(b/255.0) blue:(c/255.0) alpha:1.0]
// 设置颜色RGB值+透明度
#define kRGBA(a,b,c,d) [UIColor colorWithRed:(a/255.0) green:(b/255.0) blue:(c/255.0) alpha:d]
// 设置随机颜色
#define kLRRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]


#ifndef    weakify
#if __has_feature(objc_arc)
#define weakify(object) __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) __block __typeof__(object) block##_##object = object;
#endif
#endif

#ifndef    strongify
#if __has_feature(objc_arc)
#define strongify(object) __typeof__(object) strong##_##object = weak##_##object;
#else
#define strongify(object) __typeof__(object) strong##_##object = block##_##object;
#endif
#endif

#endif /* Config_h */
