//
//  StockCache.m
//  StockDesk
//
//  Created by 饶首建 on 2018/11/5.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import "StockCache.h"

@implementation StockCache
+(BOOL)saveStock:(NSString *)code{
    if (!code) {
        return NO;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:stockKey]];
    if (![arr containsObject:code]) {
        [arr addObject:code];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:stockKey];
        Log(@"save stock:%@",code);
        return YES;
    }
    Log(@"stock:%@ exist",code);
    return NO;
}

+ (BOOL)saveStocks:(NSArray *)codeArray{
    if (!codeArray.count) {
        return NO;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:stockKey]];
    [arr addObjectsFromArray:codeArray];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:stockKey];
    return YES;
}

+(NSArray *)getStocks{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:stockKey];
}

+(BOOL)delStockByCode:(NSString*)code{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:stockKey]];
    if ([arr containsObject:code]) {
        [arr removeObject:code];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:stockKey];
        return YES;
    }
    return NO;
}

+(void)delAllStocks{
    [[NSUserDefaults standardUserDefaults] setObject:@[ ] forKey:stockKey];
}

@end
