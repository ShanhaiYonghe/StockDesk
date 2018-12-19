//
//  ViewController.m
//  StockDesk
//
//  Created by 饶首建 on 2018/9/17.
//  Copyright © 2018年 com.wings. All rights reserved.
//

#import "ViewController.h"

#import "WSTimer.h"
#import "StockModel.h"
#import "StockCache.h"
#import "NotifyCache.h"

@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource,NSUserNotificationCenterDelegate>

@property (weak) IBOutlet NSTableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataSourceArray;
@property (nonatomic,strong) StockModel *dragStockModel;

@property (nonatomic,assign) BOOL repeat;

@property (weak) IBOutlet NSButton *addNewStockBtn;

@end

static NSString *kStockTimer = @"kStockTimer";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float v = [[NSUserDefaults standardUserDefaults]floatForKey:kWindowAlpha];
    self.view.layer.backgroundColor = NSColorFromHEX(0xDDDDDD, v).CGColor;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData) name:keyNotificationUpdateStock object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBgAlpha) name:@"updateBgAlpha" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideBar) name:@"hideBar" object:nil];
    
    _dataSourceArray = [NSMutableArray new];
    
    [_tableView registerForDraggedTypes:@[NSStringPboardType]];
    _tableView.draggingDestinationFeedbackStyle = NSTableViewDraggingDestinationFeedbackStyleGap;
    
    [self updateData];
    
}

- (void)hideBar{
        BOOL isHide = [[NSUserDefaults standardUserDefaults]boolForKey:kHideTitleBar];
        self.view.window.titlebarAppearsTransparent = isHide;
        if (isHide) {
                self.view.window.styleMask = self.view.window.styleMask | NSWindowStyleMaskFullSizeContentView;
        }else{
                self.view.window.styleMask = NSWindowStyleMaskResizable|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskTitled;
        }
}

- (void)updateBgAlpha{
    float v = [[NSUserDefaults standardUserDefaults]floatForKey:kWindowAlpha];
    self.view.layer.backgroundColor = NSColorFromHEX(0xDDDDDD, v).CGColor;
}

- (void)updateData{
    [[WSTimer sharedInstance] cancelTimer:kStockTimer];
    @WeakSelf(self);
    [[WSTimer sharedInstance]scheduledGCDTimer:kStockTimer interval:1 repeat:YES action:^{
//        Log(@"kStockTimer");
        [StockModel getData:^(NSArray *dataList) {
            if (dataList.count) {
                [weakSelf.dataSourceArray removeAllObjects];
                [weakSelf.dataSourceArray addObjectsFromArray:dataList];
                //处理通知，当某code的price大于或者小于等于 设置的price后，发出通知，并且移除通知，通知设置添加在NSArray中
                for (StockModel *sm in dataList) {
                    NSArray *arr = [NotifyCache getNotifyByCode:sm.code];
                    for (NSDictionary *dic in arr) {
                        double price = [dic[keyNotifyPrice] doubleValue];
                        double priceType = [dic[keyNotifyPriceType] integerValue];
                        if (priceType == PriceTypeHigh && sm.nowPrice >= price) {
                            [NotifyCache delNotify:dic];
                            [NotifyCache sendNotifyTitle:sm.name subtitle:sm.codeDes informativeText:SF(@"价格已经高于%.2f",price) delegate:weakSelf];
                        }else if (priceType == PriceTypeLow && sm.nowPrice <= price){
                            [NotifyCache delNotify:dic];
                            [NotifyCache sendNotifyTitle:sm.name subtitle:sm.codeDes informativeText:SF(@"价格已经低于%.2f",price) delegate:weakSelf];
                        }
                    }
                }
            }
            if (dataList.count == 0) {
                [weakSelf.dataSourceArray removeAllObjects];
                [[WSTimer sharedInstance] cancelTimer:kStockTimer];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }];
        
    } queue:nil];
}

#pragma mark - tableView
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    _addNewStockBtn.hidden = _dataSourceArray.count>0?YES:NO;
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
    aView.textField.stringValue = @"";
    StockModel *sm = [_dataSourceArray objectAtIndex:row];
    if ([strIdt isEqualToString:@"name"]) {
        aView.textField.stringValue = sm.name;
        aView.textField.textColor = ThemeDarkGrayColor;
    }else if([strIdt isEqualToString:@"percent"]){
        aView.textField.stringValue = SF(@"%.2f%%",sm.percent);
        if (sm.percent>0) {
            aView.textField.textColor = ThemeRedColor;
        }else if(sm.percent==0){
            aView.textField.textColor = ThemeGrayColor;
        }else{
            aView.textField.textColor = ThemeGreenColor;
        }
    }else if([strIdt isEqualToString:@"pricedelta"]){
        float delta = sm.nowPrice-sm.yesEndPrice;
        if (delta>0) {
            aView.textField.stringValue = SF(@"+%.2f",delta);
            aView.textField.textColor = ThemeRedColor;
        }else if(sm.percent==0){
            aView.textField.stringValue = @"0.00";
            aView.textField.textColor = ThemeGrayColor;
        }else{
            aView.textField.stringValue = SF(@"%.2f",delta);
            aView.textField.textColor = ThemeGreenColor;
        }
    }else if([strIdt isEqualToString:@"now"]){
        float delta = sm.nowPrice-sm.yesEndPrice;
        if (delta>0) {
            aView.textField.stringValue = SF(@"%.2f",sm.nowPrice);
            aView.textField.textColor = ThemeRedColor;
        }else if(sm.percent==0){
            aView.textField.stringValue = SF(@"%.2f",sm.nowPrice);
            aView.textField.textColor = ThemeGrayColor;
        }else{
            aView.textField.stringValue = SF(@"%.2f",sm.nowPrice);
            aView.textField.textColor = ThemeGreenColor;
        }
    }else if([strIdt isEqualToString:@"low"]){
        aView.textField.stringValue = SF(@"低%.2f",sm.todayLowPrice);
        aView.textField.textColor = ThemeGrayColor;
    }else if([strIdt isEqualToString:@"high"]){
        aView.textField.stringValue = SF(@"高%.2f",sm.todayHighPrice);
        aView.textField.textColor = ThemeGrayColor;
    }
    
    return aView;
}

#pragma mark - drag & drop

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation{
    if (dropOperation == NSTableViewDropAbove) {
        [[WSTimer sharedInstance] cancelTimer:kStockTimer];//拖动的时候取消timer
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
    if (!_dragStockModel) {
        return NO;
    }
    NSInteger idx = 0;
    for (NSInteger i=0; i<_dataSourceArray.count; i++) {
        StockModel *sm = _dataSourceArray[i];
        if ([_dragStockModel.code isEqual:sm.code]) {
            idx = i;
            break;
        }
    }
    
    BOOL flag = NO;
    
    if (idx < row) {//上->下
        StockModel *sm = _dataSourceArray[row-1];//被替换的obj
        if ( ![sm.code isEqualToString:_dragStockModel.code]) {
            Log(@"1 - remove0:%ld",_dataSourceArray.count);
            StockModel *rsm;
            for (StockModel *sm in _dataSourceArray) {
                if ([sm.code isEqual:_dragStockModel.code]) {
                    rsm = sm;
                    break;
                }
            }
            [_dataSourceArray removeObject:rsm];
            Log(@"1 - remove1:%ld",_dataSourceArray.count);
            [_dataSourceArray insertObject:_dragStockModel atIndex: row-1];
            flag = YES;
        }
    }
    if (idx > row) { //下->上
        StockModel *sm = _dataSourceArray[row];//被替换的obj
        if ( ![sm.code isEqualToString:_dragStockModel.code]) {
            
            Log(@"2 - remove0:%ld",_dataSourceArray.count);
            StockModel *rsm;
            for (StockModel *sm in _dataSourceArray) {
                if ([sm.code isEqual:_dragStockModel.code]) {
                    rsm = sm;
                    break;
                }
            }
            [_dataSourceArray removeObject:rsm];
            Log(@"2 - remove1:%ld",_dataSourceArray.count);
            [_dataSourceArray insertObject:_dragStockModel atIndex: row];
            flag = YES;
        }
    }
    if (flag) { //拖动换位了才做修改
        NSMutableArray *arr = [NSMutableArray new];
        for (StockModel *s in _dataSourceArray) {
            [arr addObject:s.code];
        }
        [StockCache delAllStocks];
        [StockCache saveStocks:arr];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateEditStock" object:nil];
        
        [_tableView reloadData];
        _dragStockModel = nil;
        [_tableView deselectAll:nil];
    }
    
    [self updateData]; //拖动完继续timer
    
    return YES;
}


#pragma mark - NSUserNotificationCenterDelegate
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;//强制弹框
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
