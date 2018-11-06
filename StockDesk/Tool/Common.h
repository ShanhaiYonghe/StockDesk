//
//  Common.h
//  StockDesk
//
//  Created by 饶首建 on 2018/11/5.
//  Copyright © 2018 com.wings. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef Common_h
#define Common_h

typedef enum : NSUInteger {
    PriceTypeHigh = 0,
    PriceTypeLow,
} PriceType;

static NSString *stockKey = @"stockKey";

//notify keys
static NSString *notifyKey = @"notifyKey";

static NSString *keyNotifyName = @"keyNotifyName";
static NSString *keyNotifyCode = @"keyNotifyCode";
static NSString *keyNotifyCodeDes = @"keyNotifyCodeDes";
static NSString *keyNotifyPrice = @"keyNotifyPrice";
static NSString *keyNotifyPriceType = @"keyNotifyPriceType";

//notifications
static NSString *keyNotificationUpdateStock = @"keyNotificationUpdateStock";//更新显示桌面股票

#endif /* Common_h */
