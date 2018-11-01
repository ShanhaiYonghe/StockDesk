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
#import "NotifyVC.h"

@interface EditVC () <NSTableViewDelegate,NSTableViewDataSource,NSUserNotificationCenterDelegate>

@property (weak) IBOutlet NSTableView *tableView;

@property (weak) IBOutlet NSTextField *stockTF;

@property (weak) IBOutlet NSTextField *tipLabel;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;

/** gb_$ndx 纳斯达克100  gb_$inx标普指数 gb_$dji道琼斯 gb_ixic纳斯达克 gb_baba阿里巴巴(小写)
 sz399001 深证成指；sh000001 上证指数 ；sz399006 创业板指 ；hkHSI 恒生指数 rt_hkHSI
 */
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSArray *typeArr;

@property (nonatomic,strong) StockModel *dragStockModel;

@property (weak) IBOutlet NSView *guzhiView;

@property (nonatomic,strong) NSArray *zhishuArray;



@end

@implementation EditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceArray = [NSMutableArray new];
    _type = @"sh";
    [self getData];
    
    [_tableView registerForDraggedTypes:@[NSStringPboardType]];
    _tableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyleGap;
    
    [self updateZhishu];
    
    _zhishuArray = @[@"sh000001",@"sz399001",@"sz399006",@"sz399300",@"sz399005",@"sh000016",@"hkHSI",@"gb_$dji",@"gb_ixic",@"gb_$inx",];
}

- (void)updateZhishu{
    NSArray *btnArray = _guzhiView.subviews;
    for (NSButton *b in btnArray) {
        if ([b.title containsString:@"上证指数"] && [[Cache getStocks] containsObject:@"sh000001"]) {//sh000001
            b.state = NSControlStateValueOn;
            continue;
        }else if ([b.title containsString:@"深证"] && [[Cache getStocks] containsObject:@"sz399001"]) {//sz399001
            b.state = NSControlStateValueOn;
            continue;
        }else if ([b.title containsString:@"创业"] && [[Cache getStocks] containsObject:@"sz399006"]) {//sz399006
            b.state = NSControlStateValueOn;
            continue;
        }else if ([b.title containsString:@"沪深"] && [[Cache getStocks] containsObject:@"sz399300"]) {//sz399300
            b.state = NSControlStateValueOn;
            continue;
        }else if ([b.title containsString:@"中小板"] && [[Cache getStocks] containsObject:@"sz399005"]) {//sz399005
            b.state = NSControlStateValueOn;
            continue;
        }else if ([b.title containsString:@"上证50"] && [[Cache getStocks] containsObject:@"sh000016"]) {//sh000016
            b.state = NSControlStateValueOn;
            continue;
        }else if ([b.title containsString:@"恒生指数"] && [[Cache getStocks] containsObject:@"hkHSI"]) {//hkHSI   800000
            b.state = NSControlStateValueOn;
            continue;
        }
        //    else if ([b.title containsString:@"国企指数"]) {//800100
        //    }else if ([b.title containsString:@"恒指期货"]) {//999010
        //    }
        else if ([b.title containsString:@"道琼斯"] && [[Cache getStocks] containsObject:@"gb_$dji"]) {//gb_$dji
            b.state = NSControlStateValueOn;
            continue;
        }else if ([b.title containsString:@"纳斯达克"] && [[Cache getStocks] containsObject:@"gb_ixic"]) {//gb_ixic
            b.state = NSControlStateValueOn;
            continue;
        }else if ([b.title containsString:@"标普500"] && [[Cache getStocks] containsObject:@"gb_$inx"]) {//gb_$inx
            b.state = NSControlStateValueOn;
            continue;
        }else{
            b.state = NSControlStateValueOff;
        }
    }
}

- (void)getData{
    //gb_$ndx 纳斯达克100  gb_$inx标普指数 gb_$dji道琼斯 gb_ixic纳斯达克 gb_baba阿里巴巴(小写)
    //sz399001 深证成指；sh000001 上证指数 ；sz399006 创业板指 ；hkHSI 恒生指数 rt_hkHSI
    //sz\sh\hk; sh603706 东方环宇 ; sz002371 北方华创 ; sh601606长城军工; hk00700 腾讯控股
    
    if ([Cache getStocks].count) {
        @WeakSelf(self);
        [StockModel getData:^(NSArray *dataList) {
            if (dataList.count) {
                [weakSelf.dataSourceArray removeAllObjects];
                [weakSelf.dataSourceArray addObjectsFromArray:dataList];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    [weakSelf updateZhishu];
                });
            }
        }];
    }else{
        [_dataSourceArray removeAllObjects];
        [_tableView reloadData];
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
    }else if ([b.title isEqualToString:@"深证"]) {
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
        aView.textField.textColor = ThemeDarkGrayColor;
    }else if([strIdt isEqualToString:@"code"]){
        aView.textField.stringValue = sm.codeDes;
        aView.textField.textColor = ThemeGrayColor;
    }else if([strIdt isEqualToString:@"low"]){
        aView.textField.stringValue = [NSString stringWithFormat:@"低%.2f",sm.todayLowPrice];
        aView.textField.textColor = ThemeGrayColor;
    }else if([strIdt isEqualToString:@"percent"]){
        aView.textField.stringValue = [NSString stringWithFormat:@"%.2f%%",sm.percent];
        if (sm.percent>0) {
            aView.textField.textColor = ThemeRedColor;
        }else if(sm.percent==0){
            aView.textField.textColor = ThemeGrayColor;
        }else{
            aView.textField.textColor = ThemeGreenColor;
        }
    }else if([strIdt isEqualToString:@"high"]){
        aView.textField.stringValue = [NSString stringWithFormat:@"高%.2f",sm.todayHighPrice];
        aView.textField.textColor = ThemeGrayColor;
    }else if([strIdt isEqualToString:@"current"]){
        aView.textField.stringValue = [NSString stringWithFormat:@"现%.2f",sm.nowPrice];
        aView.textField.textColor = ThemeGrayColor;
    }else if([strIdt isEqualToString:@"control"]){
        NSButton *btn = [NSButton new];
        btn.bezelStyle = NSBezelStyleRoundRect;
        [btn setTitle:@"删除"];
        btn.tag = row;
        btn.frame = CGRectMake(0, 0, 70, 20);
        [btn setTarget:self];
        [btn setAction:@selector(del:)];
        [aView addSubview:btn];
    }else if([strIdt isEqualToString:@"notify"] && ![_zhishuArray containsObject:sm.code]){
        NSButton *btn = [NSButton new];
        btn.bezelStyle = NSBezelStyleRoundRect;
        [btn setTitle:@"添加通知"];
        btn.tag = row;
        btn.frame = CGRectMake(0, 0, 70, 20);
        [btn setTarget:self];
        [btn setAction:@selector(addNotifi:)];
        [aView addSubview:btn];
    }
    
    return aView;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation{
    if (dropOperation == NSTableViewDropAbove) {
        return NSDragOperationMove;
    }
    return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard{
    [pboard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:self];//定义存在剪切板的哪里，不加这句代码貌似拖拽不起作用
    NSArray *array = [_dataSourceArray objectsAtIndexes:rowIndexes];//拖拽的列表数组
    _dragStockModel = array.firstObject;
    return YES;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation{
    NSInteger idx = [_dataSourceArray indexOfObject:_dragStockModel];//拖动的obj
    BOOL flag = NO;
    if (idx > row) { //下面往上面移动
        StockModel *sm = _dataSourceArray[row];//被替换的obj
        if ( ![sm.code isEqualToString:_dragStockModel.code]) {
            [_dataSourceArray removeObject:_dragStockModel];
            [_dataSourceArray insertObject:_dragStockModel atIndex: row];
            flag = YES;
        }
    }
    if (idx < row) {//上面往下面移动
        StockModel *sm = _dataSourceArray[row-1];//被替换的obj
        if ( ![sm.code isEqualToString:_dragStockModel.code]) {
            [_dataSourceArray removeObject:_dragStockModel];
            [_dataSourceArray insertObject:_dragStockModel atIndex: row-1];
            flag = YES;
        }
    }
    if (flag) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:_dataSourceArray.count];
        for (StockModel *s in _dataSourceArray) {
            [arr addObject:s.code];
        }
        [Cache saveStocks:arr];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateStock" object:nil];
        
        [_tableView reloadData];
        _dragStockModel = nil;
        [_tableView deselectAll:nil];
    }
    return YES;
}

#pragma mark private method

- (void)del:(id)sender{
    NSButton *b = sender;
    [Cache delStock:b.tag];
    [self getData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateStock" object:nil];
}

#pragma mark 添加通知
- (void)addNotifi:(id)sender{
    /**
     
//    NSButton *b = sender;
//    [Cache delStock:b.tag];
//    [self getData];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateStock" object:nil];
    NSUserNotification *localNotify = [[NSUserNotification alloc] init];
    localNotify.title = @"title";//标题
    localNotify.subtitle = @"subtitle";//副标题
//    localNotify.contentImage = [NSImage imageNamed: @"swift"];//显示在弹窗右边的提示。
    localNotify.informativeText = @"body message";
    localNotify.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:localNotify];
    //设置通知的代理
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    */
    
    NSButton *b = sender;
    Log(@"%ld",b.tag);
    StockModel *sm = [_dataSourceArray objectAtIndex:b.tag];
    
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NotifyVC *vc =  [sb instantiateControllerWithIdentifier:@"notifyVC"];
    vc.title = SF(@"%@(%@)",sm.name,sm.codeDes);
    vc.price = sm.nowPrice;
    [self presentViewControllerAsModalWindow:vc];
}

- (IBAction)addZhishuAction:(id)sender {
    NSButton *b = sender;
    NSString *code = @"";
    if ([b.title containsString:@"上证指数"]) {//sh000001
        code = @"sh000001";
    }else if ([b.title containsString:@"深证"]) {//sz399001
        code = @"sz399001";
    }else if ([b.title containsString:@"创业"]) {//sz399006
        code = @"sz399006";
    }else if ([b.title containsString:@"沪深"]) {//sz399300
        code = @"sz399300";
    }else if ([b.title containsString:@"中小板"]) {//sz399005
        code = @"sz399005";
    }else if ([b.title containsString:@"上证50"]) {//sh000016
        code = @"sh000016";
    }else if ([b.title containsString:@"恒生指数"]) {//hkHSI   800000
        code = @"hkHSI";
    }
//    else if ([b.title containsString:@"国企指数"]) {//800100
//        code = @"hk800100";
//    }else if ([b.title containsString:@"恒指期货"]) {//999010
//        code = @"hk999010";
//    }
    else if ([b.title containsString:@"道琼斯"]) {//gb_$dji
        code = @"gb_$dji";
    }else if ([b.title containsString:@"纳斯达克"]) {//gb_ixic
        code = @"gb_ixic";
    }else if ([b.title containsString:@"标普500"]) {//gb_$inx
        code = @"gb_$inx";
    }
    if (code.length && b.state == NSControlStateValueOn) {
        [Cache saveStock:code];
    }else{
        [Cache delStockByCode:code];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateStock" object:nil];
    [self getData];
}

#pragma mark NSUserNotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification{
    Log(@"%@",notification);
//    [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notification];
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification{
    Log(@"%@",notification);
}
//returen YES;强制显示(即不管通知是否过多)
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

@end
