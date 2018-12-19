//
//  wc.m
//  StockDesk
//
//  Created by 饶首建 on 2018/9/17.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import "wc.h"
#import "Cache.h"
#import "EditVC.h"
#import "Reachability.h"

@interface wc ()


@end

@implementation wc

- (void)windowWillLoad{
    [super windowWillLoad];
    
//    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:kAppLoadTimes]; //测试用
//    [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:notifyKey]; //测试用
    NSInteger appLoadTimes = [[NSUserDefaults standardUserDefaults]integerForKey:kAppLoadTimes];
    if (appLoadTimes == 0) {
        Log(@"app load times:%ld",appLoadTimes);
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kWindowFront];
        [[NSUserDefaults standardUserDefaults]setFloat:1 forKey:kWindowAlpha];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kHideTitleBar];
    }
    [[NSUserDefaults standardUserDefaults]setInteger:appLoadTimes+1 forKey:kAppLoadTimes];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    reach.reachableBlock = ^(Reachability*reach){
                NSLog(@"reachblock-----");
            [[NSNotificationCenter defaultCenter]postNotificationName:keyNotificationUpdateStock object:nil];
    };
    [reach startNotifier];

    
    NSApplication *thisApp = [NSApplication sharedApplication];
    [thisApp activateIgnoringOtherApps:YES];
    
    [self.window center];
    [self.window setMovableByWindowBackground:YES];
    
    //默认窗口最前
    BOOL isFront = [[NSUserDefaults standardUserDefaults]boolForKey:kWindowFront];
    [self.window setLevel:isFront?NSStatusWindowLevel:NSNormalWindowLevel];

    BOOL isHide = [[NSUserDefaults standardUserDefaults]boolForKey:kHideTitleBar];
     self.window.titlebarAppearsTransparent = isHide;
        if (isHide) {
                self.window.styleMask = self.window.styleMask | NSWindowStyleMaskFullSizeContentView;
        }else{
                self.window.styleMask = NSWindowStyleMaskResizable|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskTitled;
        }

    self.window.backgroundColor = NSColorFromHEX(0x000000, 0);
}

@end
