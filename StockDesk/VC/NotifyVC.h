//
//  NotifyVC.h
//  StockDesk
//
//  Created by 饶首建 on 2018/11/1.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "StockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotifyVC : NSViewController

@property (nonatomic,assign) double price;
@property (nonatomic,strong) StockModel *sm;
@end

NS_ASSUME_NONNULL_END
