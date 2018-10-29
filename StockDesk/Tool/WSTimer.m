//
//  WSTimer.m
//  WSKit
//
//  Created by 饶首建 on 2018/9/18.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import "WSTimer.h"

@interface WSTimer ()

@property (nonatomic, strong) NSMutableDictionary *timerArr;

@end

@implementation WSTimer


+(instancetype)sharedInstance{
    static WSTimer *timer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timer = [[WSTimer alloc]init];
    });
    return timer;
}

-(void)scheduledGCDTimer:(NSString *)timerName interval:(double)interval repeat:(BOOL)repeat action:(dispatch_block_t)action queue:(dispatch_queue_t)queue{
    
    if (!queue) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//全局子线程队列
    }
    
    dispatch_source_t timer = [self.timerArr objectForKey:timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerArr setObject:timer forKey:timerName];
    }
    // 设置首次执行事件、执行间隔和精确度(默认为0.1s)
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval*NSEC_PER_SEC), interval*NSEC_PER_SEC, 0.1*NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        action();
        if (!repeat) {
//            __strong typeof(weakSelf) strongSelf = weakSelf;
            [weakSelf cancelTimer:timerName];
        }
    });
}

- (void)cancelTimer:(NSString *)timerName{
    dispatch_source_t timer = [self.timerArr objectForKey:timerName];
    if (timer) {
        [self.timerArr removeObjectForKey:timerName];
        
        dispatch_source_cancel(timer);
    }
}

#pragma mark - getter
- (NSMutableDictionary *)timerArr{
    if (!_timerArr) {
        _timerArr = [NSMutableDictionary new];
    }
    return _timerArr;
}


@end
