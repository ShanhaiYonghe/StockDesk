//
//  Notify.h
//  StockDesk
//
//  Created by 饶首建 on 2018/11/5.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Notify : NSObject

#pragma mark notify

/**
 @[
     @{
         @"code":@"sh253615",
         @"price":@(float),
         @"PriceType":@(PriceType)
     },
     ...
 ]
 */
+(BOOL)saveNotify:(NSDictionary *)dict;

+(BOOL)delNotify:(NSDictionary *)notify;

+(NSArray *)getNotifyByCode:(NSString *)stockCode;

//发送本地通知
+ (void)sendNotifyTitle:(NSString *)title subtitle:(NSString*)subtitle informativeText:(NSString *)informativeText delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
