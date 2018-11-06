//
//  NotifyVC.m
//  StockDesk
//
//  Created by 饶首建 on 2018/11/1.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import "NotifyVC.h"
#import "NotifyCache.h"

@interface NotifyVC ()

@property (weak) IBOutlet NSTextField *priceTf;
@property (nonatomic,assign) PriceType priceType;
@property (nonatomic,assign) double newPrice;

@end

@implementation NotifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SF(@"%@(%@)",_sm.name,_sm.codeDes);
    _priceTf.stringValue = SF(@"%.2f",_sm.nowPrice);
    _newPrice = _sm.nowPrice;
    
}

- (IBAction)radioAction:(id)sender {
    NSButton *b = sender;
    if ([b.title containsString:@"高"]) {
        _priceType = PriceTypeHigh;
    }else if ([b.title containsString:@"低"]) {
        _priceType = PriceTypeLow;
    }
}

/**
 添加通知服务
 */
- (IBAction)addAction:(id)sender {
    double p = [_priceTf.stringValue doubleValue];
    
    BOOL result = [NotifyCache saveNotify:@{
                                keyNotifyCode           :   _sm.code?:@"",
                                keyNotifyCodeDes    :   _sm.codeDes?:@"",
                                keyNotifyName          :   _sm.name?:@"",
                                keyNotifyPrice           :   @(p),
                                keyNotifyPriceType   :   @(_priceType)
                        }];
    
    NSAlert *alert = [[NSAlert alloc]init];
    if (result) {
        alert.messageText = @"添加成功";
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            [self dismissController:self];
        }];
    }else{
        alert.messageText = @"已添加相同的通知";
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            
        }];
    }
}

- (IBAction)plusAction:(id)sender {
    _newPrice = _newPrice + 0.1;
    _priceTf.stringValue = SF(@"%.2f",_newPrice);
}

- (IBAction)minusAction:(id)sender {
    if (_newPrice > 0.1) {
        _newPrice = _newPrice - 0.1;
    }
    _priceTf.stringValue = SF(@"%.2f",_newPrice);
}

@end
