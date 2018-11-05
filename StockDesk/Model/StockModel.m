//
//  StockModel.m
//  StockDesk
//
//  Created by 饶首建 on 2018/9/19.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import "StockModel.h"

#import "StockCache.h"

@interface StockModel()

@end

@implementation StockModel

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWith:(NSArray *)dataArr type:(NSString*)type{
    if (dataArr.count<5) {
        return nil;
    }
    StockModel *sm = [StockModel new];
    if ([type isEqualToString:@"sh"]||[type isEqualToString:@"sz"]) {
        sm.name = dataArr[0];
        sm.todayStartPrice = [dataArr[1]doubleValue];
        sm.yesEndPrice = [dataArr[2]doubleValue];
        sm.nowPrice = [dataArr[3] doubleValue];
        sm.todayHighPrice = [dataArr[4]doubleValue];
        sm.todayLowPrice = [dataArr[5] doubleValue];
        sm.dateStr = dataArr[30];
        sm.timeStr = dataArr[31];
    }else if ([type isEqualToString:@"hk"]){
        sm.name = dataArr[1];
        sm.todayStartPrice = [dataArr[2]doubleValue];
        sm.yesEndPrice = [dataArr[3]doubleValue];
        sm.nowPrice = [dataArr[6] doubleValue];
        sm.todayHighPrice = [dataArr[4]doubleValue];
        sm.todayLowPrice = [dataArr[5] doubleValue];
        sm.dateStr = dataArr[17];
        sm.timeStr = dataArr[18];
    }else if([type isEqualToString:@"gb"]){
        sm.name = dataArr[0];
        sm.todayStartPrice = [dataArr[5]doubleValue];
        sm.yesEndPrice = [dataArr[26]doubleValue];
        sm.nowPrice = [dataArr[1] doubleValue];
        sm.todayHighPrice = [dataArr[6]doubleValue];
        sm.todayLowPrice = [dataArr[7] doubleValue];
        sm.dateStr = dataArr[3];
        sm.timeStr = dataArr[3];
    }
    sm.percent = (sm.nowPrice/sm.yesEndPrice - 1)*100;
    return sm;
}

+ (void)getData:(ResultBlock)resultBlock{
    NSString *stockListStr = [[StockCache getStocks] componentsJoinedByString:@","];
    //限制时间段 ***区分第一次和循环获取 TODO
    Log(@"%@",stockListStr);
    
    if (stockListStr.length<4) {
        resultBlock(nil);
    }
    
    NSString *url = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=%@",stockListStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *gbkNSString = [[NSString alloc]initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        NSMutableArray *stockArr = [NSMutableArray arrayWithArray:[gbkNSString componentsSeparatedByString:@";"]];
        if (stockArr.count) {
            [stockArr removeLastObject];
        }
        NSMutableArray *mArr = [NSMutableArray new];
        for (NSString *stock in stockArr) {
            NSString *tmp;
            NSRange range = [stock rangeOfString:@"\""];
            tmp = [stock substringFromIndex:range.location];
            tmp = [tmp stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSArray *arr = [tmp componentsSeparatedByString:@","];
            
            NSRange range1 = [stock rangeOfString:@"str"];
            NSRange range2 = NSMakeRange(range1.location+4,2);
            NSString *type = [stock substringWithRange:range2];
            
            StockModel *sm = [[StockModel alloc]initWith:arr type:type];
            NSString * code = [[StockCache getStocks] objectAtIndex:[stockArr indexOfObject:stock]];
            sm.code = code;

            NSString *codeDes = [code copy];
            if ([codeDes rangeOfString:@"gb_"].location == 0){
                codeDes = [codeDes substringFromIndex:3];
                if ([codeDes containsString:@"$"]){
                    codeDes = [codeDes substringFromIndex:1];
                }
            }else if([codeDes isEqualToString:@"hkHSI"]){
                codeDes = @"800000";
            }
            codeDes = [codeDes uppercaseString];
            sm.codeDes = codeDes;
            
            [mArr addObject:sm];
        }
        
        if (mArr.count) {
            resultBlock(mArr);
        }
    }];
    [task resume];
}

+(void)addStock:(NSString*)type code:(NSString *)code return:(SuccessBlock)successBlock{
    NSString *url = [NSString stringWithFormat:@"http://hq.sinajs.cn/list=%@%@",type,code];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *gbkNSString = [[NSString alloc]initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        if (gbkNSString.length > 50) {
            //添加成功
            [StockCache saveStock:[NSString stringWithFormat:@"%@%@",type,code]];
            successBlock(YES);
        }else{
            //添加失败
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(NO);
            });
        }
    }];
    [task resume];
}

@end
