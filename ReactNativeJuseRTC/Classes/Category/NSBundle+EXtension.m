//
//  NSBundle+EXtension.m
//  ReactNativeJuseRTC
//
//  Created by 888 on 2021/12/11.
//

#import "NSBundle+EXtension.h"

@implementation NSBundle (EXtension)

+(NSBundle*)getBundleResource{
    
    //直接读取ReactNativeJuseRTC
    NSURL *associateBundleURL = [[NSBundle mainBundle]URLForResource:@"ReactNativeJuseRTC"  withExtension:@"bundle"];
    if (associateBundleURL) {
        associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"RCTResource" withExtension:@"bundle"];
        return [NSBundle bundleWithURL:associateBundleURL];
    }

    //第二种方式读取

    
//    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath                           stringByAppendingPathComponent:@"/ReactNativeJuseRTC.bundle"];
    
    NSString *bundlePath = [NSBundle bundleForClass:[self class]].resourcePath;
    bundlePath = [bundlePath stringByAppendingPathComponent:@"ReactNativeJuseRTC.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    

    NSLog(@"获取bundle---%@",bundle);
    
    
    NSURL *URL = [[NSBundle mainBundle]URLForResource:@"Frameworks"  withExtension:nil];
    URL = [[URL URLByAppendingPathComponent:@"ReactNativeJuseRTC"] URLByAppendingPathExtension:@"framework"];
    URL = [[NSBundle bundleWithURL:URL] URLForResource:@"ReactNativeJuseRTC" withExtension:@"bundle"];
    URL = [[NSBundle bundleWithURL:URL] URLForResource:@"RCTResource" withExtension:@"bundle"];
    NSBundle *bundleS = [NSBundle bundleWithURL:URL];
    
    NSLog(@"获取bundleSS---%@",bundleS);
    
    
//    NSLog(@"获取image---%@",image);
//
//    NSURL *url = [NSURL URLWithString:path];
//    NSLog(@"获取url---%@",url);
//    url = [[NSBundle bundleWithURL:url] URLForResource:@"RCTResource" withExtension:@"bundle"];
//    NSLog(@"获取url222---%@",url);
//    NSBundle *date  =  [NSBundle bundleWithURL:url];
//    NSLog(@"获取bundle---date%@",date);
    
    
//    NSString *bundlePath = [[NSBundle bundleWithPath:path]pathForResource:@"RCTResource" ofType:@"bundle"];
    NSAssert(bundlePath, @"取不到关联bundle");
    return bundlePath?[NSBundle bundleWithPath:bundlePath]:nil;
}



+(NSBundle*)getBundleResourceURL{
    NSURL *associateBundleURL = [[NSBundle mainBundle]URLForResource:@"Frameworks"  withExtension:nil];
    associateBundleURL = [[associateBundleURL URLByAppendingPathComponent:@"ReactNativeJuseRTC"] URLByAppendingPathExtension:@"framework"];
    associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"ReactNativeJuseRTC" withExtension:@"bundle"];
   associateBundleURL = [[NSBundle bundleWithURL:associateBundleURL] URLForResource:@"RCTResource" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:associateBundleURL];
}


@end
