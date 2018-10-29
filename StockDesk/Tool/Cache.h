//
//  Cache.h
//  StockDesk
//
//  Created by 饶首建 on 2018/9/20.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject

+(BOOL)saveStock:(NSString*)code;

+(NSArray *)getStocks;

+(void)delStock:(NSInteger)idx;

@end
