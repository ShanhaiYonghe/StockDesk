//
//  wc.m
//  StockDesk
//
//  Created by 饶首建 on 2018/9/17.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import "wc.h"

@interface wc ()

@end

@implementation wc

- (void)windowDidLoad {
    [super windowDidLoad];
    NSApplication *thisApp = [NSApplication sharedApplication];
    [thisApp activateIgnoringOtherApps:YES];
    [self.window orderFront:self];
        
    self.window.backgroundColor = NSColorFromHEX(0x000000, 0);
    CGRect screen = [NSScreen mainScreen].frame;
    [self.window setFrame:CGRectMake(0, 0, 300, 200) display:YES];
    [self.window setFrameOrigin:CGPointMake(screen.size.width/2, screen.size.height/2)];
    
    
    [self.window setLevel:NSStatusWindowLevel];
//    self.window.styleMask = NSTexturedBackgroundWindowMask;

}

@end