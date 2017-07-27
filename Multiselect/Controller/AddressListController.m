//
//  AddressListController.m
//  baobaotong
//
//  Created by GHZ on 2017/7/11.
//  Copyright © 2017年 zzy. All rights reserved.
//

#import "AddressListController.h"
#import "AddressListCell.h"
#import "AdressListResult.h"
#import "ClientListModel.h"
#import "NameListModel.h"
#import "AdressListResult.h"

static NSString * const cellID = @"cellID";

@interface AddressListController ()<UITableViewDelegate, UITableViewDataSource, cellBtnDelegate>

@property(nonatomic, strong) UITableView *addressBookTableView;
@property(nonatomic, strong) UIButton *selectAllBtn; //全选按钮
@property(nonatomic, strong) UIButton *guideBtn; //导入按钮
@property(nonatomic, strong) NSMutableArray *clientListArr; //模型数组
@property(nonatomic, strong) NSMutableArray *nameListArr; //模型数组
@property(nonatomic, strong) NSMutableArray *contactsArr; //存放选中的联系人
@property(nonatomic, assign) BOOL isSelectedAll; //是否全选

@end

@implementation AddressListController

- (NSMutableArray *)clientListArr {
    
    if (_clientListArr == nil) {
        _clientListArr = [NSMutableArray array];
    }
    return _clientListArr;
}

- (NSMutableArray *)nameListArr {
    
    if (_nameListArr == nil) {
        _nameListArr = [NSMutableArray array];
    }
    return _nameListArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //添加子控件
    [self setupSubviews];
    //请求联系人数据
    [self loadData];
    
    _contactsArr = [NSMutableArray array];
}

- (void)setupSubviews {
    
    // 联系人 tableView
    _addressBookTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    [self.view addSubview:_addressBookTableView];
    _addressBookTableView.contentInset = UIEdgeInsetsMake(50 + 21, 0, 48, 0);
    _addressBookTableView.tableFooterView = [[UIView alloc] init];
    _addressBookTableView.sectionIndexColor = UIColorFromRGB(0x6a7fa5);
    _addressBookTableView.delegate = self;
    _addressBookTableView.dataSource = self;
    [_addressBookTableView registerClass:[AddressListCell class] forCellReuseIdentifier:cellID];
    
    // <-/导入联系人
    CGFloat ddressBookVX = 0;
    CGFloat ddressBookVW = kDeviceWidth;
    CGFloat ddressBookVH = 70;
    CGFloat ddressBookVY = 0;
    UIView *addressBookView = [[UIView alloc] initWithFrame:CGRectMake(ddressBookVX, ddressBookVY, ddressBookVW, ddressBookVH)];
    addressBookView.backgroundColor = KwhiteColor;
    [self.view addSubview:addressBookView];
    
    UILabel *addressBookLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50 * 0.8, kDeviceWidth - 80 * 2, 20)];
    addressBookLabel.text = @"导入联系人";
    addressBookLabel.textAlignment = NSTextAlignmentCenter;
    [addressBookView addSubview:addressBookLabel];
    
    addressBookView.layer.shadowOpacity=0.5;
    addressBookView.layer.shadowRadius=3;
    
    //导入/全选
    CGFloat guideX = 0;
    CGFloat guideW = kDeviceWidth;
    CGFloat guideH = 48;
    CGFloat guideY = KDeviceHeight - guideH;
    UIView *guideView = [[UIView alloc] initWithFrame:CGRectMake(guideX, guideY, guideW, guideH)];
    guideView.backgroundColor = kBackgroundColor;
    [self.view addSubview:guideView];
    
    _guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _guideBtn.frame = CGRectMake(0, (48-44) * 0.5, 80, 44);
    [_guideBtn setTitle:@"导入" forState:UIControlStateNormal];
    [_guideBtn setTitleColor:UIColorFromRGB(0x6a7fa5) forState:UIControlStateNormal];
    _guideBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _guideBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 10, 46);
    _guideBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    [guideView addSubview:_guideBtn];
    [_guideBtn addTarget:self action:@selector(guideBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectAllBtn.frame = CGRectMake(kDeviceWidth - 80 - 10, 3, 80, 44);
    [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllBtn setImage:[UIImage imageNamed:@"disselected"] forState:UIControlStateNormal];
    [_selectAllBtn setTitleColor:kFontColor forState:UIControlStateNormal];
    [_selectAllBtn setTitleColor:UIColorFromRGB(0x6a7fa5) forState:UIControlStateSelected];
    _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _selectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 10, 46);
    _selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
    [guideView addSubview:_selectAllBtn];
    [_selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - loadData
- (void)loadData {
    AdressListResult *adressList = [AdressListResult mj_objectWithFilename:@"Contact.plist"];
    if (adressList.result.clientlist != nil) {
        self.clientListArr = [ClientListModel mj_objectArrayWithKeyValuesArray:adressList.result.clientlist];
        [self createNameListArr];
        [self.addressBookTableView reloadData];
    }else {
        
    }
}

#pragma mark - 返回根控制器
- (void)backToRootVC {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 返回上一界面
- (void)backPreviousVC {
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 导入
- (void)guideBtnClick: (UIButton *)sender {
    
    if (self.contactsArr.count == 0) {
        
        [self tub:NO message:@"您还没有选择联系人"];
    } else {
        
        [self tub:NO message:@"成功导入联系人"];
    }
    
    BBLog(@"contactsArr-----%@", self.contactsArr);
}

#pragma mark - 全选
- (void)selectAllBtnClick: (UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.contactsArr removeAllObjects];
            NSMutableArray *mmArr = [NSMutableArray array];
            
            for (int i = 0; i < self.nameListArr.count; i++) {
                
                NSArray *arr = [NSArray array];
                arr = self.nameListArr[i];
                for (int j = 0; j < arr.count; j++) {
                    
                    [mmArr addObject:arr[j]];
                }
            }
            for (int i = 0; i < mmArr.count; i++) {
                
                NameListModel *model = mmArr[i];
                if (![model.isadd boolValue]) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:model.ID forKey:@"id"];
                    if (model.mobilephone) {
                        [dic setObject:model.mobilephone forKey:@"mobilephone"];
                    }else
                    {
                        [dic setObject:@[] forKey:@"mobilephone"];
                    }
                    [dic setObject:model.backgorund forKey:@"backgorund"];
                    if (model.name) {
                        [dic setObject:model.name forKey:@"name"];
                    }else
                    {
                        [dic setObject:@"" forKey:@"name"];
                    }
                    [_contactsArr addObject:dic];
                }
            }
            [self modelStatus:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_contactsArr.count > 0) {
                    self.isSelectedAll = YES;
                    sender.selected = YES;
                    [self.selectAllBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
                }else
                {
                    self.isSelectedAll = NO;
                    sender.selected = NO;
                }
                [_addressBookTableView reloadData];
            });
        });
    } else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.isSelectedAll = NO;
            [self modelStatus:NO];
            [self.contactsArr removeAllObjects];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.selectAllBtn setImage:[UIImage imageNamed:@"disselected"] forState:UIControlStateNormal];
                [_addressBookTableView reloadData];
            });
        });
    }
}

- (void)modelStatus: (BOOL)isSelected {
    
    for (NSMutableArray *mArr in [self.nameListArr mutableCopy]) {
        
        NSInteger section = [self.nameListArr indexOfObject:mArr];
        for (NameListModel *model in [mArr mutableCopy]) {
            
            NSInteger row = [mArr indexOfObject:model];
            model.isSelected = isSelected;
            self.nameListArr[section][row] = model;
        }
    }
}

#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ClientListModel *clientListModel = _clientListArr[section];
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 0; i < _clientListArr.count; i++) {
        
        NSString *headStr = clientListModel.letter;
        [mArr addObject:headStr];
    }
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    if (section == 28) {
        lab.backgroundColor = UIColorFromRGB(0xf0eff5);
        lab.text = @"   ";
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor darkGrayColor];
        return lab;
    } else {
        
        lab.backgroundColor = UIColorFromRGB(0xf0eff5);
        lab.text = [NSString stringWithFormat:@"   %@",mArr[section]];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor darkGrayColor];
        return lab;
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

#pragma mark - tableView索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    NSMutableArray *sectionIndexArr = [NSMutableArray array];
    for (int i = 0; i < self.clientListArr.count; i++) {
        
        ClientListModel *clientListModel = self.clientListArr[i];
        [sectionIndexArr addObject: clientListModel.letter];
    }
    return sectionIndexArr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _clientListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ClientListModel *clientListModel = self.clientListArr[section];
    return clientListModel.namelist.count;
}

-(void)createNameListArr
{
    self.nameListArr = [NSMutableArray array];
    for (ClientListModel *clientListModel in self.clientListArr) {
        NSMutableArray *nameListArr = [NSMutableArray array];
        NSMutableArray *mArr = [NSMutableArray array];
        for (int i = 0; i < clientListModel.namelist.count; i++) {
            
            NSArray *arr = clientListModel.namelist[i];
            [mArr addObject:arr];
        }
        nameListArr = [NameListModel mj_objectArrayWithKeyValuesArray:mArr];
        [self.nameListArr addObject:nameListArr];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NameListModel  * model = self.nameListArr[indexPath.section][indexPath.row];
    cell.nameListModel = model;
    if (self.isSelectedAll) {
        model.isSelected = YES;
        self.nameListArr[indexPath.section][indexPath.row] = model;
        cell.selectBtn.selected = YES;
    } else {
        if (self.contactsArr.count == 0) {
            model.isSelected = NO;
            self.nameListArr[indexPath.section][indexPath.row] = model;
            cell.nameListModel = model;
            cell.selectBtn.selected = NO;
        } else {
            if (model.isSelected) {
                cell.selectBtn.selected = YES;
            } else {
                cell.selectBtn.selected = NO;
            }
        }
    }
    
    if (cell.nameListModel.isSelected) {
        cell.selectBtn.selected = YES;
    } else {
        cell.selectBtn.selected = NO;
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - cellBtnDelegate
- (void)cellBtnClick:(AddressListCell *)cell {
    
    NameListModel *model = cell.nameListModel;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger count = 0;
        for (NSArray *arr in self.nameListArr) {
            count += arr.count;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:model.ID forKey:@"id"];
            if (model.mobilephone) {
                [dic setObject:model.mobilephone forKey:@"mobilephone"];
            }else
            {
                [dic setObject:@[] forKey:@"mobilephone"];
            }
            [dic setObject:model.backgorund forKey:@"backgorund"];
            if (model.name) {
                [dic setObject:model.name forKey:@"name"];
            }else
            {
                [dic setObject:@"" forKey:@"name"];
            }
            if (!cell.selectBtn.selected) {
                cell.selectBtn.selected = YES;
                model.isSelected = YES;
                [self addContact:model];
                if (self.contactsArr.count == count) {
                    self.isSelectedAll = YES;
                    self.selectAllBtn.selected = YES;
                    [self.selectAllBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
                }
                [self.addressBookTableView reloadData];
            } else {
                cell.selectBtn.selected = NO;
                model.isSelected = NO;
                [self addContact:model];
                if (self.contactsArr.count < count) {
                    self.isSelectedAll = NO;
                    self.selectAllBtn.selected = NO;
                    [self.selectAllBtn setImage:[UIImage imageNamed:@"disselected"] forState:UIControlStateNormal];
                }
                [self.addressBookTableView reloadData];
            }
            self.nameListArr[cell.indexPath.section][cell.indexPath.row] = model;
        });
    });
}

- (void)addContact: (NameListModel *)model {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:model.ID forKey:@"id"];
    if (model.mobilephone) {
        [dic setObject:model.mobilephone forKey:@"mobilephone"];
    }else
    {
        [dic setObject:@[] forKey:@"mobilephone"];
    }
    [dic setObject:model.backgorund forKey:@"backgorund"];
    if (model.name) {
        [dic setObject:model.name forKey:@"name"];
    }else
    {
        [dic setObject:@"" forKey:@"name"];
    }
    if (model.isSelected) {
        
        [_contactsArr addObject:dic];
    } else {
        
        [_contactsArr removeObject:dic];
    }
}

#pragma mark - alert
- (void)tub:(BOOL)tub message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:tub ? @"取消" : @"确定"  otherButtonTitles:tub ? @"确定" : nil, nil];
    [alert show];
}

@end
