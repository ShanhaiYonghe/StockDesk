//
//  AboutVC.m
//  StockDesk
//
//  Created by 饶首建 on 2018/12/19.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
- (IBAction)open:(id)sender {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/wingsrao"]];
}

@end
