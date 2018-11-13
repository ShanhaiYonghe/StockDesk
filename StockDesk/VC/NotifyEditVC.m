//
//  NotifyEditVC.m
//  StockDesk
//
//  Created by 饶首建 on 2018/11/6.
//  Copyright © 2018 com.wings. All rights reserved.
//

#import "NotifyEditVC.h"

#import "NotifyCache.h"

@interface NotifyEditVC () <NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

@end

@implementation NotifyEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceArray = [NSMutableArray new];    
}

- (void)viewWillAppear{
    [super viewWillAppear];
    [self loadData];
}

- (void)loadData{
    NSArray *arr = [NotifyCache getAllNotify];
    [_dataSourceArray removeAllObjects];
    [_dataSourceArray addObjectsFromArray:arr?:@[]];
    [_tableView reloadData];
}

#pragma mark - NSTableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return _dataSourceArray.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 20;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *strIdt = [tableColumn identifier];
    
    NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!aView){
        aView = [[NSTableCellView alloc]initWithFrame:CGRectMake(0, 0, tableColumn.width, 20)];
    }
    
    NSDictionary *dic = [_dataSourceArray objectAtIndex:row];
    if ([strIdt isEqualToString:@"name"]) {
        aView.textField.stringValue = dic[keyNotifyName]?:@"";
    }else if([strIdt isEqualToString:@"code"]){
        aView.textField.stringValue = dic[keyNotifyCodeDes]?:@"";
    }else if([strIdt isEqualToString:@"price"]){
        PriceType type = [dic[keyNotifyPriceType] integerValue];
        aView.textField.stringValue = SF(@"%@%.2f",type == PriceTypeHigh?@"高于":@"低于", [dic[keyNotifyPrice] doubleValue]);
    }else if([strIdt isEqualToString:@"del"]){
        NSButton *btn = [NSButton new];
        btn.bezelStyle = NSBezelStyleRoundRect;
        [btn setTitle:@"删除"];
        btn.tag = row;
        btn.frame = CGRectMake(0, 0, 40, 20);
        [btn setTarget:self];
        [btn setAction:@selector(del:)];
        [aView addSubview:btn];
    }
    
    return aView;
}

#pragma mark private method
- (void)del:(id)sender{
    NSButton *b = sender;
    NSDictionary *dic = [_dataSourceArray objectAtIndex:b.tag];
    [NotifyCache delNotify:dic];
    [self loadData];
}

@end
