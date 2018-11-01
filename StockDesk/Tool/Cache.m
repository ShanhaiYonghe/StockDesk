//
//  Cache.m
//  StockDesk
//
//  Created by 饶首建 on 2018/9/20.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import "Cache.h"

static NSString *stockKey = @"stockKey";
static NSString *notifyKey = @"notifyKey";

@interface Cache()

@property (nonatomic, strong) NSMutableDictionary *notifyDict;

@end

@implementation Cache

+(BOOL)saveStock:(NSString *)code{
    if (!code) {
        return NO;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:stockKey]];
    if (![arr containsObject:code]) {
        [arr addObject:code];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:stockKey];
        NSLog(@"save stock:%@",code);
        return YES;
    }
    return NO;
}

+ (BOOL)saveStocks:(NSArray *)codeArray{
    if (!codeArray.count) {
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:codeArray forKey:stockKey];
    return YES;
}

+(NSArray *)getStocks{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:stockKey];
    return arr;
}

+(void)delStock:(NSInteger)idx{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:stockKey]];
    [arr removeObjectAtIndex:idx];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:stockKey];
}

+(void)delStockByCode:(NSString*)code{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:stockKey]];
    [arr removeObject:code];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:stockKey];
}

+(void)delAllStocks{
    [[NSUserDefaults standardUserDefaults] setObject:@[ ] forKey:stockKey];
}


+(BOOL)saveNotify:(NSDictionary *)dict{
    if (!dict) {
        return NO;
    }
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:notifyKey]];
    [mutableDict addEntriesFromDictionary:dict];
    [[NSUserDefaults standardUserDefaults]setObject:mutableDict forKey:notifyKey];
    return YES;
}

+(BOOL)delNotifyByCode:(NSString *)stockCode{
    if (!stockCode.length) {
        return NO;
    }
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:notifyKey]];
    [mutableDict removeObjectForKey:stockCode];
    [[NSUserDefaults standardUserDefaults]setObject:mutableDict forKey:notifyKey];
    return YES;
}

+(id)getPriceByCode:(NSString *)stockCode{
    if (!stockCode.length) {
        return nil;
    }
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:notifyKey];
    return [dict objectForKey:stockCode];
}

@end
