//
//  Safety.h
//  hospitalUser
//
//  Created by 888 on 2021/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * NSArray
 */
@interface NSArray (Safety)
- (id)SafetyObjectAtIndex:(NSUInteger)index;
@end


/*
 * NSMutableArray
 */
@interface NSMutableArray (Safety)
- (BOOL)SafetyAddObject:(id)anObject;
- (BOOL)SafetyInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (BOOL)SafetyRemoveObject:(id)anObject;
- (BOOL)SafetyRemoveObjectAtIndex:(NSUInteger)index;
- (BOOL)SafetyReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
@end

/*
 * NSMutableDictionary
 */
@interface NSMutableDictionary (Safety)
- (void)SafetySetObject:(id)anObject forKey:(id <NSCopying>)aKey;
@end

@interface NSCalendar(Safety)
- (NSDate *)safeDateFromComponents:(NSDateComponents *)comps;
- (NSDateComponents *)safeComponents:(NSCalendarUnit)unitFlags fromDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
