//
//  NotifyCache.m
//  StockDesk
//
//  Created by 饶首建 on 2018/11/6.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import "NotifyCache.h"
#import "StockModel.h"

@implementation NotifyCache

+(BOOL)saveNotify:(NSDictionary *)notify{
    if (!notify) {
        return NO;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:notifyKey]];
    
    if (arr.count) {
        BOOL isExist = NO;
        for (NSDictionary *dic in arr) {
            if ([dic[keyNotifyCode] isEqual:notify[keyNotifyCode]] && [dic[keyNotifyPrice] isEqual:notify[keyNotifyPrice]] && [dic[keyNotifyPriceType] isEqual:notify[keyNotifyPriceType]]) {
                Log(@"same notify exist");
                isExist = YES;
                break;
            }
        }
        if(!isExist){
            [arr addObject:notify];
            [[NSUserDefaults standardUserDefaults]setObject:arr forKey:notifyKey];
            Log(@"save notify %@",notify);
            return YES;
        }
    }else{
        [arr addObject:notify];
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:notifyKey];
        Log(@"save notify %@",notify);
        return YES;
    }
    
    return NO;
}

+(BOOL)delNotify:(NSDictionary *)notify{
    if (!notify) {
        return NO;
    }
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:notifyKey]];
    NSDictionary *removeDic = @{};
    for (NSDictionary *dic in mutableArr) {
        if ([dic[keyNotifyCode] isEqual:notify[keyNotifyCode]] && [dic[keyNotifyPrice] isEqual:notify[keyNotifyPrice]] && [dic[keyNotifyPriceType] isEqual:notify[keyNotifyPriceType]]) {
            removeDic = dic;
            break;
        }
    }
    [mutableArr removeObject:removeDic];
    [[NSUserDefaults standardUserDefaults]setObject:mutableArr forKey:notifyKey];
    return YES;
}

+(NSArray *)getNotifyByCode:(NSString *)stockCode{
    if (!stockCode.length) {
        return nil;
    }
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:notifyKey]];
    NSMutableArray *tmpArr = [NSMutableArray new];
    for (NSDictionary *dic in mutableArr) {
        if ([dic[keyNotifyCode] isEqual:stockCode]) {
            [tmpArr addObject:dic];
        }
    }
    return tmpArr;
}

+(NSArray *)getAllNotify{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:notifyKey];
}

+ (void)sendNotifyTitle:(NSString *)title subtitle:(NSString*)subtitle informativeText:(NSString *)informativeText delegate:(id)delegate{
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = title; //标题
    localNotify.subtitle = subtitle; //副标题
    //    localNotify.contentImage = [NSImage imageNamed: @"swift"];//显示在弹窗右边的提示。
    localNotify.informativeText = informativeText;
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:localNotify];
    //设置通知的代理
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:delegate];
}

@end
