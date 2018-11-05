//
//  Notify.m
//  StockDesk
//
//  Created by 饶首建 on 2018/11/5.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import "Notify.h"
#import "StockModel.h"

@implementation Notify

+(BOOL)saveNotify:(NSDictionary *)notify{
    if (!notify) {
        return NO;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:notifyKey]];

    if (arr.count) {
        for (NSDictionary *dic in arr) {
            if ([dic[@"code"] isEqual:notify[@"code"]] && [dic[@"price"] isEqual:notify[@"price"]] && [dic[@"priceType"] isEqual:notify[@"priceType"]]) {
                Log(@"same notify exist");
                break;
            }else{
                [arr addObject:notify];
                [[NSUserDefaults standardUserDefaults]setObject:arr forKey:notifyKey];
                Log(@"save notify %@",notify);
                break;
            }
        }
    }else{
        [arr addObject:notify];
        [[NSUserDefaults standardUserDefaults]setObject:arr forKey:notifyKey];
        Log(@"save notify %@",notify);
    }
    
    return YES;
}

+(BOOL)delNotify:(NSDictionary *)notify{
    if (!notify) {
        return NO;
    }
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:notifyKey]];
    NSDictionary *removeDic = @{};
    for (NSDictionary *dic in mutableArr) {
        if ([dic[@"code"] isEqual:notify[@"code"]] && [dic[@"price"] isEqual:notify[@"price"]] && [dic[@"priceType"] isEqual:notify[@"priceType"]]) {
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
        if ([dic[@"code"] isEqual:stockCode]) {
            [tmpArr addObject:dic];
        }
    }
    return tmpArr;
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
