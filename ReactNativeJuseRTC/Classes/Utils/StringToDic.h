//
//  StringToDic.h
//  hospitalUser
//
//  Created by 橘色科技 on 2020/9/18.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StringToDic : NSObject

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
