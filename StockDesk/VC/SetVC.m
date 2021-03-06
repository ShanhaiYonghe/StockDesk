//
//  SetVC.m
//  StockDesk
//
//  Created by 饶首建 on 2018/10/22.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import "SetVC.h"

@interface SetVC ()
@property (weak) IBOutlet NSSlider *slider;
@property (weak) IBOutlet NSButton *isFrontBtn;
@property (weak) IBOutlet NSButton *isHideBtn;

@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    float v = [[NSUserDefaults standardUserDefaults] floatForKey:kWindowAlpha];
    Log(@"alpha:%f",v);
    _slider.stringValue = SF(@"%f",v*100);
    
    BOOL isFront = [[NSUserDefaults standardUserDefaults]boolForKey:kWindowFront];
    _isFrontBtn.state = isFront;
    
    BOOL isHide = [[NSUserDefaults standardUserDefaults]boolForKey:kHideTitleBar];
    _isHideBtn.state = isHide;
    
}

- (IBAction)sliderAction:(id)sender {
    NSSlider *slider = sender;
    float v = [slider.stringValue floatValue]/100;
    [[NSUserDefaults standardUserDefaults]setFloat:v forKey: kWindowAlpha];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateBgAlpha" object:nil];
}
- (IBAction)hideTitleBar:(id)sender {
        NSButton *btn = sender;
        if (btn.state == 1) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kHideTitleBar];
        }else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kHideTitleBar];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideBar" object:nil];
}

- (IBAction)isFront:(id)sender {
    NSButton *btn = sender;
    NSWindow *w = [NSApplication sharedApplication].windows.firstObject;
    if (btn.state == 1) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kWindowFront];
        [w setLevel:NSStatusWindowLevel];
    }else{
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:kWindowFront];
        [w setLevel:NSNormalWindowLevel];
    }
}


@end
