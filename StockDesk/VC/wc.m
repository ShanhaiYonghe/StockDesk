//
//  wc.m
//  StockDesk
//
//  Created by 饶首建 on 2018/9/17.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import "wc.h"
#import "Cache.h"

@interface wc ()

@end

@implementation wc

- (void)windowWillLoad{
    [super windowWillLoad];
    
    [[NSUserDefaults standardUserDefaults]setFloat:0 forKey:kAppLoadTimes];
    NSInteger appLoadTimes = [[NSUserDefaults standardUserDefaults]integerForKey:kAppLoadTimes];
    if (appLoadTimes == 0) {
        Log(@"app load times:%ld",appLoadTimes);
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kWindowFront];
        [[NSUserDefaults standardUserDefaults]setFloat:0.8 forKey:kWindowAlpha];
    }
    [[NSUserDefaults standardUserDefaults]setInteger:appLoadTimes+1 forKey:kAppLoadTimes];
    
//    [Cache delAllStocks];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    NSApplication *thisApp = [NSApplication sharedApplication];
    [thisApp activateIgnoringOtherApps:YES];
    
    [self.window center];
    [self.window setMovableByWindowBackground:YES];
    
    //默认窗口最前
    BOOL isFront = [[NSUserDefaults standardUserDefaults]boolForKey:kWindowFront];
    [self.window setLevel:isFront?NSStatusWindowLevel:NSNormalWindowLevel];

    self.window.backgroundColor = NSColorFromHEX(0x000000, 0);
    
//    CGRect screen = [NSScreen mainScreen].frame;
//    [self.window setFrame:CGRectMake(0, 0, 300, 200) display:YES];
//    [self.window setFrameOrigin:CGPointMake(screen.size.width/2, screen.size.height/2)];
//    [self.window setLevel:NSStatusWindowLevel];
//    self.window.styleMask = NSTexturedBackgroundWindowMask;
}

@end
