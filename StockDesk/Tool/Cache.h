//
//  Cache.h
//  StockDesk
//
//  Created by 饶首建 on 2018/9/20.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject


#pragma mark Stock

+(BOOL)saveStock:(NSString*)code;

+(BOOL)saveStocks:(NSArray*)codeArray;

+(NSArray *)getStocks;

+(void)delStock:(NSInteger)idx;

+(void)delStockByCode:(NSString*)code;

+(void)delAllStocks;

#pragma mark notify

/**
 @[
     @{@"code":@"sh253615",
          @"price":@(float),
          @"PriceType":@(PriceType) //PriceTypeHigh means Above,PriceTypeLow means Below
     },
    ...
]
 */
+(BOOL)saveNotify:(NSDictionary *)dict;

+(BOOL)delNotifyByCode:(NSString*)stockCode;

+(NSDictionary *)getNotifyByCode:(NSString *)stockCode;

@end
