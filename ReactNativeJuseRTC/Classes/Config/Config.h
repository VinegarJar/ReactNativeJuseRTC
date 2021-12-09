//
//  Config.h
//  Pods
//
//  Created by 888 on 2021/12/8.
//

#ifndef Config_h
#define Config_h

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenBounds [UIScreen mainScreen].bounds


//视频

#define WindowDisplayWidth 100
#define WindowDisplayHeight 100

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
