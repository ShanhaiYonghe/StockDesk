//
//  StockCache.h
//  StockDesk
//
//  Created by 饶首建 on 2018/11/5.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StockCache : NSObject

#pragma mark Stock

+(BOOL)saveStock:(NSString*)code;

+(BOOL)saveStocks:(NSArray*)codeArray;

+(NSArray *)getStocks;

+(BOOL)delStockByCode:(NSString*)code;

+(void)delAllStocks;

@end

NS_ASSUME_NONNULL_END
