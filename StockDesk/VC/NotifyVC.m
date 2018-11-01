//
//  NotifyVC.m
//  StockDesk
//
//  Created by 饶首建 on 2018/11/1.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import "NotifyVC.h"

typedef enum : NSUInteger {
    PriceTypeHigh = 0,
    PriceTypeLow,
} PriceType;

@interface NotifyVC ()

@property (weak) IBOutlet NSTextField *priceTf;
@property (nonatomic,assign) PriceType priceType;
@property (nonatomic,assign) double newPrice;

@end

@implementation NotifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _priceTf.stringValue = SF(@"%.2f",_price);
    _newPrice = _price;
    
}

- (IBAction)radioAction:(id)sender {
    NSButton *b = sender;
    if ([b.title containsString:@"高"]) {
        _priceType = PriceTypeHigh;
    }else if ([b.title containsString:@"低"]) {
        _priceType = PriceTypeLow;
    }
}

- (IBAction)addAction:(id)sender {
    
    [self dismissController:self];
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
