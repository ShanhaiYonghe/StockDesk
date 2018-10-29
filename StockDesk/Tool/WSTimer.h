//
//  WSTimer.h
//  WSKit
//
//  Created by 饶首建 on 2018/9/18.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSTimer : NSObject

+(instancetype)sharedInstance;

- (void)scheduledGCDTimer:(nonnull NSString *)timerName
                 interval:(double)interval
                   repeat:(BOOL)repeat
                   action:(dispatch_block_t)action queue:(dispatch_queue_t)queue;
- (void)cancelTimer:(NSString*)timerName;


@end
