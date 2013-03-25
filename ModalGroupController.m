//
//  ModalGroupController.m
//  ModalGroupContacts
//
//  Created by marco on 13-3-12.
//  Copyright (c) 2013年 marco. All rights reserved.
//

#import "ModalGroupController.h"
#import "ICMenuTableDatasource.h"
#import "SelectorTableViewDelegate.h"
#import "ICRecipientPicker.h"
#import "SearchBar.h"
#import "ReciverVo.h"

@interface ModalGroupController ()<ICRecipientPickerDataSource,ICPickerViewDelegate>{
    ICRecipientPicker* _picker;
    SelectorTableViewDelegate* _tbdelegate;
}
@property(nonatomic, retain)ICMenuTableDatasource* tableViewDataSource;
@end

#define DEFAULT_PICKER_TOP 0
#define DEFAULT_PICKER_HEIGHT 44
#define DEFAULT_TABLE_TOP 45

@implementation ModalGroupController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableViewDataSource = [ICMenuTableDatasource createDemoSections:_tableView];
    self.tableView.dataSource = self.tableViewDataSource;
    _tbdelegate = [[SelectorTableViewDelegate alloc] initWithAboveViewOnTable:_picker belowViewOnTable:nil];
    _tbdelegate.ds = _tableViewDataSource;
    _tableView.delegate = _tbdelegate;
    
    self.picker.datasource = self;
    self.picker.pickViewDelegate = self;
    
    _titlBar.titleLabel.text = @"请选择联系人";
}

-(void)dealloc{
    [_tableViewDataSource release];
    [_tbdelegate release];
    [_initParam release];
    [super dealloc];
}

-(void)loadView{
    [super loadView];
    [self tableView];
    [self picker];
    [self titlBar];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view.layer setCornerRadius: 5.0];
    [self.view setClipsToBounds:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(SearchBar*)titlBar{
    if (!_titlBar) {
        _titlBar = [[SearchBar alloc] init];
        _titlBar.superViewController = self;
        [self.view addSubview:_titlBar];
        [_titlBar release];
    }
    return _titlBar;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, DEFAULT_TABLE_TOP, self.view.frame.size.width, self.view.frame.size.height-DEFAULT_TABLE_TOP)
                                                  style:UITableViewStylePlain];
        _tableView.allowsMultipleSelection = YES;
        _tableView.accessibilityLabel = @"reciverTabel";
        [self.view addSubview:_tableView];
        [_tableView release];
    }
    return _tableView;
}

-(ICRecipientPicker*)picker{
    if (!_picker) {
        _picker = [[ICRecipientPicker alloc] initWithFrame:CGRectMake(0, DEFAULT_PICKER_TOP, self.view.frame.size.width, DEFAULT_PICKER_HEIGHT)];
        _picker.alwaysBounceVertical = YES;
        _picker.selectionStyle = ICRecipientPickerSelectionStyleDefault;
        _picker.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:238.0f/255.0f blue:230.9f/255.0f alpha:1.0f];
        [self.view addSubview:_picker];
        [_picker release];
    }
    return _picker;
}

-(NSMutableArray*)selectedRecivers{
    if (!_selectedRecivers) {
        _selectedRecivers = [[NSMutableArray array] retain];
    }
    return _selectedRecivers;
}

#pragma mark - business method

-(BOOL)containReciver:(NSObject*)reciver{
    if ([self.selectedRecivers indexOfObject:reciver]==NSNotFound) {
        return NO;
    }
    return YES;
}

#pragma mark - ICRecipientPickerDataSource

-(ICRecipientPickerItem *)recipientPicker:(ICRecipientPicker*)pickerView itemForIndex:(NSInteger)index{
    Reciver* vo = [self.selectedRecivers objectAtIndex:index];
    ICRecipientPickerItem* item = [[[ICRecipientPickerItem alloc] init] autorelease];
    item.textLabel.text = vo.reciverName;
    item.object = vo;
    return item;
}

-(void)putItem:(NSObject*)item{
    if (![self containReciver:item]) {
        [self.selectedRecivers addObject:item];
        [self.picker insertItemAtIndex:-1 animated:YES];
    }
}

-(NSInteger)numberOfItemsInPikcerView:(ICRecipientPicker *)pickerView{
    return self.selectedRecivers.count;
}

#pragma mark - ICPickerViewDelegate

-(NSArray*)pickerView:(ICRecipientPicker*)view menuItemsForPickerItemAtIndex:(NSInteger)index{
    UIMenuItem *item0 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteSelectedReciver:)];
    NSArray *items = [NSArray arrayWithObjects:item0, nil];
    [item0 release];
    return items;
}

-(BOOL)pickerView:(ICRecipientPicker*)view shouldShowMenuForPickerItemAtIndex:(NSInteger)idx{
    return YES;
}

-(void)pickerView:(ICRecipientPicker*)view didSelectPickerItemAtIndex:(NSInteger)index{
    self.view.userInteractionEnabled = NO;
}

-(void)pickerView:(ICRecipientPicker*)view didHideMenuForPickerItemAtIndex:(NSInteger)index{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - menu controller click handler

-(void)deleteSelectedReciver:(id)sender{
    [self.selectedRecivers removeObjectAtIndex:self.picker.activeItem.index];
    [self.picker removeItemAtIndex:self.picker.activeItem.index animated:YES];
}

-(UIView*)gestureRecognizerTarget{
    return self.titlBar;
}
@end