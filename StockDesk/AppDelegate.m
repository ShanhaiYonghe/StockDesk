//
//  AppDelegate.m
//  StockDesk
//
//  Created by 饶首建 on 2018/9/17.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic ,strong)NSStatusItem *statusItem;
@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    NSInteger appLoadTimes = [[NSUserDefaults standardUserDefaults]integerForKey:kAppLoadTimes];
//    [self addStatusBar];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

- (void)addStatusBar{
    //NSStatusBar
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    self.statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setTitle:@"Stock"];
    //    NSImage *image = [NSImage imageNamed:@"statusBarIcon"];
    //    image.template = YES;
    //    self.statusItem.button.image = image;
    NSStatusBarButton *button = self.statusItem.button;
    button.target = self;
    button.action = @selector(handleButtonClick:);
}

- (void)handleButtonClick:(id)sender{
    Log(@"mmm");
//    EditVC *vc = [[NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateControllerWithIdentifier:@"editVC"];
//    NSViewController *vc = [NSViewController new];
//    NSWindowController *w = [[NSWindowController alloc]init];
//    w.contentViewController = vc;
//    [self showWindow:w];
    //    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
//    [[NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateControllerWithIdentifier:@"editVC"];
    //    [sg performSegueWithIdentifier:@"openEditVC" sender:sender];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
	if (flag) {
		return NO;
	}else{
		NSWindowController *wc = [[NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateControllerWithIdentifier:@"wc"];
		
		[wc.window makeKeyAndOrderFront:self];
	}
	return YES;
}
@end
