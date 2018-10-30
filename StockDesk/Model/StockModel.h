//
//  StockModel.h
//  StockDesk
//
//  Created by 饶首建 on 2018/9/19.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(NSArray *);
typedef void(^SuccessBlock)(BOOL);

@interface StockModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *codeDes;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) double todayStartPrice;
@property (nonatomic,assign) double yesEndPrice;

@property (nonatomic,assign) double nowPrice;

@property (nonatomic,assign) double todayHighPrice;
@property (nonatomic,assign) double todayLowPrice;

@property (nonatomic,copy) NSString *dateStr;
@property (nonatomic,copy) NSString *timeStr;

@property (nonatomic,assign) double percent;//涨跌百分比

- (instancetype)initWith:(NSArray*)dataArr type:(NSString*)type;

+ (void)getData:(ResultBlock)resultBlock;
+ (void)addStock:(NSString *)type code:(NSString *)code return:(SuccessBlock)successBlock;

@end
