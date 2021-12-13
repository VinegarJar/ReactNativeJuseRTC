//
//  StringToDic.m
//  hospitalUser
//
//  Created by 橘色科技 on 2020/9/18.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "StringToDic.h"

@implementation StringToDic

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
