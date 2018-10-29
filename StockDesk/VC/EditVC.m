//
//  EditVC.m
//  StockDesk
//
//  Created by 饶首建 on 2018/9/20.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import "EditVC.h"
#import "StockModel.h"
#import "Cache.h"

@interface EditVC () <NSTableViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;

@property (weak) IBOutlet NSTextField *stockTF;

@property (weak) IBOutlet NSTextField *tipLabel;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

/** gb_$ndx 纳斯达克100  gb_$inx标普指数 gb_$dji道琼斯 gb_ixic纳斯达克 gb_baba阿里巴巴(小写)
 sz399001 深证成指；sh000001 上证指数 ；sz399006 创业板指 ；hkHSI 恒生指数 rt_hkHSI
 */
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSArray *typeArr;

@end

@implementation EditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceArray = [NSMutableArray new];
    _type = @"sh";
    [self getData];
}

- (void)getData{
    //gb_$ndx 纳斯达克100  gb_$inx标普指数 gb_$dji道琼斯 gb_ixic纳斯达克 gb_baba阿里巴巴(小写)
    //sz399001 深证成指；sh000001 上证指数 ；sz399006 创业板指 ；hkHSI 恒生指数 rt_hkHSI
    //sz\sh\hk; sh603706 东方环宇 ; sz002371 北方华创 ; sh601606长城军工
    if ([Cache getStocks].count) {
        @WeakSelf(self);
        [StockModel getData:^(NSArray *dataList) {
            if (dataList.count) {
                [weakSelf.dataSourceArray removeAllObjects];
                [weakSelf.dataSourceArray addObjectsFromArray:dataList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
    }
}

- (IBAction)addClick:(id)sender {
    //添加
    NSString *code = [_stockTF.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (code.length == 0) {
        _tipLabel.stringValue = @"请填写股票代码";
        _tipLabel.textColor = [NSColor redColor];
        return;
    }else{
        _tipLabel.stringValue = @"";
        code = [code lowercaseString];
        @WeakSelf(self);
        [StockModel addStock:_type code:code return:^(BOOL flag) {
            if (flag) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateStock" object:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.tipLabel.stringValue = @"添加成功！";
                    [weakSelf getData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.tipLabel.stringValue = @"添加失败，请确认股票代码。";
                });
            }
        }];
    }
}

- (IBAction)radioButtonAction:(id)sender{
    NSButton *b = sender;
    if ([b.title isEqualToString:@"上证"]) {
        _type = @"sh";
    }else if ([b.title isEqualToString:@"深证"]||[b.title isEqualToString:@"创业板"]) {
        _type = @"sz";
    }else if ([b.title isEqualToString:@"港股"]) {
        _type = @"hk";
    }else if ([b.title isEqualToString:@"美股"]) {
        _type = @"gb_";
    }
}

#pragma mark - NSTableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return _dataSourceArray.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 20;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString *strIdt=[tableColumn identifier];
    
    NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!aView){
        aView = [[NSTableCellView alloc]initWithFrame:CGRectMake(0, 0, tableColumn.width, 20)];
    }
    
    StockModel *sm = [_dataSourceArray objectAtIndex:row];
    if ([strIdt isEqualToString:@"name"]) {
        aView.textField.stringValue = sm.name;
        aView.textField.textColor = [NSColor darkGrayColor];
    }else if([strIdt isEqualToString:@"low"]){
        aView.textField.stringValue = [NSString stringWithFormat:@"低%.2f",sm.todayLowPrice];
        aView.textField.textColor = [NSColor grayColor];
    }else if([strIdt isEqualToString:@"percent"]){
        aView.textField.stringValue = [NSString stringWithFormat:@"%.2f%%",sm.percent];
        if (sm.percent>0) {
            aView.textField.textColor = [NSColor redColor];
        }else if(sm.percent==0){
            aView.textField.textColor = [NSColor grayColor];
        }else{
            aView.textField.textColor = NSColorFromHEX(0x3CB371,1);
        }
    }else if([strIdt isEqualToString:@"high"]){
        aView.textField.stringValue = [NSString stringWithFormat:@"高%.2f",sm.todayHighPrice];
        aView.textField.textColor = [NSColor grayColor];
    }else if([strIdt isEqualToString:@"current"]){
        aView.textField.stringValue = [NSString stringWithFormat:@"现%.2f",sm.nowPrice];
        aView.textField.textColor = [NSColor grayColor];
    }else if([strIdt isEqualToString:@"control"]){
        NSButton *btn = [NSButton new];
        [btn setTitle:@"删除"];
        btn.tag = row;
        btn.frame = CGRectMake(0, 0, 70, 20);
        [btn setTarget:self];
        [btn setAction:@selector(del:)];
        [aView addSubview:btn];
    }
    
    return aView;
}

//移动行
- (void)moveRowAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex NS_AVAILABLE_MAC(10_7){
    
}

- (void)del:(id)sender{
    NSButton *b = sender;
    [Cache delStock:b.tag];
    [self getData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateStock" object:nil];
}

@end
