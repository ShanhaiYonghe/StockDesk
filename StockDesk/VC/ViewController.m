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
#import "Cache.h"

@interface ViewController()<NSTableViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;

@property (nonatomic,strong)NSScrollView *tableContainerView;
@property (nonatomic,strong)NSMutableArray *dataSourceArray;
@property (nonatomic,strong)NSTextField *scrollTF;
@property (nonatomic,strong)NSButton *deleteBtn;
@property (nonatomic,strong)NSButton *addBtn;

@property (nonatomic,assign)NSInteger selectedRowNum;
@property (nonatomic,strong) NSTableView *tableView1;

@end

static NSString *kStockTimer = @"kStockTimer";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float v = [[NSUserDefaults standardUserDefaults]floatForKey:kWindowAlpha];
    self.view.layer.backgroundColor = NSColorFromHEX(0xDDDDDD, v).CGColor;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData) name:@"updateStock" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBgAlpha) name:@"updateBgAlpha" object:nil];
    
    _dataSourceArray = [NSMutableArray new];
    
    [self updateData];
}

- (void)updateBgAlpha{
    float v = [[NSUserDefaults standardUserDefaults]floatForKey:kWindowAlpha];
    self.view.layer.backgroundColor = NSColorFromHEX(0xDDDDDD, v).CGColor;
}

- (void)updateData{
    [[WSTimer sharedInstance] cancelTimer:kStockTimer];
    
    @WeakSelf(self);
    [[WSTimer sharedInstance]scheduledGCDTimer:kStockTimer interval:1 repeat:NO action:^{
        
        Log(@"timer");
        [StockModel getData:^(NSArray *dataList) {
            if (dataList.count == 0 && weakSelf.dataSourceArray.count == 0) {
                [[WSTimer sharedInstance] cancelTimer:kStockTimer];
            }
            if (dataList.count) {
                [weakSelf.dataSourceArray removeAllObjects];
                [weakSelf.dataSourceArray addObjectsFromArray:dataList];
                
                //处理通知，当某code的price大于或者小于等于 设置的price后，发出通知，并且移除通知，通知设置添加在NSArray中
                
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }];
        
    } queue:nil];
}

#pragma mark - private
- (void)addTable{
    //删除按钮
    _deleteBtn = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
    _deleteBtn.title = @"删除选中行";
    _deleteBtn.wantsLayer = YES;
    _deleteBtn.layer.cornerRadius = 3.0f;
    _deleteBtn.layer.borderColor = [NSColor lightGrayColor].CGColor;
    [_deleteBtn setTarget:self];
//    _deleteBtn.action = @selector(deleteTheSelectedRow);
    [self.view addSubview:_deleteBtn];
    
    //添加按钮
    _addBtn = [[NSButton alloc] initWithFrame:CGRectMake(90, 0, 70, 25)];
    _addBtn.title = @"上面添一行";
    _addBtn.wantsLayer = YES;
    _addBtn.layer.cornerRadius = 3.0f;
    _addBtn.layer.borderColor = [NSColor lightGrayColor].CGColor;
    [_addBtn setTarget:self];
//    _addBtn.action = @selector(addRowUnderTheSelectedRow);
    [self.view addSubview:_addBtn];
    
    //滚动显示的TF
    _scrollTF = [[NSTextField alloc] initWithFrame:CGRectMake(180, 30, 80, 15)];
    _scrollTF.stringValue = @"滚动 0.0";
    _scrollTF.font = [NSFont systemFontOfSize:15.0f];
    _scrollTF.textColor = [NSColor blackColor];
    _scrollTF.drawsBackground = NO;
    _scrollTF.bordered = NO;
    _scrollTF.focusRingType = NSFocusRingTypeNone;
    _scrollTF.editable = NO;
//    [self.view addSubview:_scrollTF];
    
    //tableView
    _tableContainerView = [[NSScrollView alloc] initWithFrame:CGRectMake(0, 30, 440, 200)];
    _tableView1 = [[NSTableView alloc] initWithFrame:CGRectMake(0, 0,
                                                               _tableContainerView.frame.size.width-20,
                                                               _tableContainerView.frame.size.height)];
    [_tableView1 setBackgroundColor:[NSColor colorWithCalibratedRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0]];
    _tableView1.focusRingType = NSFocusRingTypeNone;                             //tableview获得焦点时的风格
    _tableView1.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;//行高亮的风格
    _tableView1.headerView.frame = NSZeroRect;                                   //表头
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    
    // 第一列
    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
    [column1 setWidth:200];
    [_tableView1 addTableColumn:column1];//第一列
    
    // 第二列
    NSTableColumn * column2 = [[NSTableColumn alloc] initWithIdentifier:@"secondColumn"];
    [column2 setWidth:200];
    [_tableView1 addTableColumn:column2];//第二列
    
    [_tableContainerView setDocumentView:_tableView1];
    [_tableContainerView setDrawsBackground:NO];        //不画背景（背景默认画成白色）
    [_tableContainerView setHasVerticalScroller:YES];   //有垂直滚动条
    [_tableContainerView setHasHorizontalScroller:YES];   //有水平滚动条
    _tableContainerView.autohidesScrollers = YES;       //自动隐藏滚动条（滚动的时候出现）
    [self.view addSubview:_tableContainerView];
    
    //监测tableview滚动
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(tableviewDidScroll:)
                                                name:NSViewBoundsDidChangeNotification
                                              object:[[_tableView1 enclosingScrollView] contentView]];
    
}

- (void)windowDidResize:(NSNotification *)notification {
    //NSLog(@"notification %@",notification.object);
//    NSWindow *window = notification.object;
    //    [_tableView reloadData];
//    NSLog(@"window %@",NSStringFromRect(window.frame));
}

#pragma mark - tableView
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
        aView.textField.stringValue = SF(@"现%.2f",sm.nowPrice);
        aView.textField.textColor = ThemeGrayColor;
    }else if([strIdt isEqualToString:@"low"]){
        aView.textField.stringValue = SF(@"低%.2f",sm.todayLowPrice);
        aView.textField.textColor = ThemeGrayColor;
    }else if([strIdt isEqualToString:@"high"]){
        aView.textField.stringValue = SF(@"高%.2f",sm.todayHighPrice);
        aView.textField.textColor = ThemeGrayColor;
    }
    
    return aView;
}

//-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    NSTextFieldCell *textcell = cell;
//    [textcell setTitle:@"fuck"];
//}

//- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
//    _selectedRowNum = row;
//    return YES;
//}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    NSLog(@"%@", tableColumn.dataCell);
}

#pragma mark - tableview滚动处理
-(void)tableviewDidScroll:(NSNotification *)notification{
    NSClipView *contentView = [notification object];
    CGFloat scrollY = contentView.visibleRect.origin.y-20;//这里减去20是因为tableHeader的20高度
    _scrollTF.stringValue = [NSString stringWithFormat:@"滚动 %.1f",scrollY];
}

#pragma mark - 删除&&添加某一行
//-(void)deleteTheSelectedRow{
//    if (_selectedRowNum == -1) {NSLog(@"请先选择要删除的行"); return;}
//    [_tableView beginUpdates];
//    [_dataSourceArray removeObjectAtIndex:_selectedRowNum];
//    [_tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:_selectedRowNum] withAnimation:NSTableViewAnimationSlideUp];
//    [_tableView endUpdates];
//    _selectedRowNum = -1;
//}
//
//-(void)addRowUnderTheSelectedRow{
//    if (_selectedRowNum == -1) {NSLog(@"请先选择要哪行上面添一行"); return;}
//    NSString *seletedDataObject = [_dataSourceArray objectAtIndex:_selectedRowNum];
//    NSString *addObject = [NSString stringWithFormat:@"%@+",seletedDataObject];
//
//    [_tableView beginUpdates];
//    [_dataSourceArray insertObject:addObject atIndex:_selectedRowNum];
//    [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:_selectedRowNum] withAnimation:NSTableViewAnimationSlideDown];
//    [_tableView endUpdates];
//    _selectedRowNum++;
//}

// 选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification* )notification{
    self.tableView = notification.object;
//    NSLog(@"-----%ld", (long)self.tableView.selectedRow);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
