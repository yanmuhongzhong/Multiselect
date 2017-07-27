//
//  AddressListCell.m
//  baobaotong
//
//  Created by GHZ on 2017/7/11.
//  Copyright © 2017年 zzy. All rights reserved.
//

#import "AddressListCell.h"
#import "NameListModel.h"

@interface AddressListCell()

@end

@implementation AddressListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //添加子控件
        [self addChildView];
        
    }
    return self;
}

- (void)addChildView {
    //图标
    CGFloat imageVX = 10;
    CGFloat imageVH = 43;
    CGFloat imageVW = 43;
    CGFloat imageVY = 10;
    _imageV = [[UIView alloc] initWithFrame:CGRectMake(imageVX, imageVY, imageVW, imageVH)];
    _imageV.layer.cornerRadius = imageVH * 0.5;
    _imageV.clipsToBounds = YES;
    [self.contentView addSubview:_imageV];
    //姓
    CGFloat firstNameLabelX = 10;
    CGFloat firstNameLabelH = 43;
    CGFloat firstNameLabelW = 43;
    CGFloat firstNameLabelY = 10;
    _firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstNameLabelX, firstNameLabelY, firstNameLabelW, firstNameLabelH)];
    _firstNameLabel.text = @"顾";
    _firstNameLabel.textColor = KwhiteColor;
    _firstNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_firstNameLabel];
    //名字
    CGFloat nameLabelX = 10 * 2 + imageVW;
    CGFloat nameLabelY = self.bounds.size.height - 20;
    CGFloat nameLabelW = 160;
    CGFloat nameLabelH = 20;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH)];
    [self.contentView addSubview:_nameLabel];
    //选中
    CGFloat selectBtnX = kDeviceWidth - 40 - 50;
    CGFloat selectBtnY = 6;
    CGFloat selectBtnW = 50;
    CGFloat selectBtnH = 50;
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(selectBtnX, selectBtnY, selectBtnW, selectBtnH);
    _selectBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    [_selectBtn setImage:[UIImage imageNamed:@"disselected"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBtn];
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //已添加
    CGFloat didAddLabelX = kDeviceWidth - 40 - 50;
    CGFloat didAddLabelY = self.bounds.size.height - 16;
    CGFloat didAddLabelW = 50;
    CGFloat didAddLabelH = 16;
    _didAddLabel = [[UILabel alloc] initWithFrame:CGRectMake(didAddLabelX, didAddLabelY, didAddLabelW, didAddLabelH)];
    _didAddLabel.text = @"已添加";
    _didAddLabel.font = [UIFont systemFontOfSize:14];
    _didAddLabel.textColor = UIColorFromRGB(0x6a7fa5);
    [self.contentView addSubview:_didAddLabel];
}

- (void)selectBtnClick: (UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cellBtnClick:)]) {
        
        [self.delegate cellBtnClick:self];
    }
    
}

- (void)setchecked:(BOOL)checked{
    
    _isSelected = checked;
    if(_isSelected){
        
        _selectBtn.selected = YES;
    }else{
        
        _selectBtn.selected = NO;
    }
}

- (void)setNameListModel:(NameListModel *)nameListModel {
    
    _nameListModel = nameListModel;
    _firstNameLabel.text = nameListModel.firstword;
    _nameLabel.text = nameListModel.name;
//    _imageV.backgroundColor = [UIColor colorWithHexString:nameListModel.backgorund];
    if ([nameListModel.isadd isEqualToString:@"0"]) { //未添加
        
        _didAddLabel.hidden = YES;
        _selectBtn.hidden = NO;
    } else {
        
        _didAddLabel.hidden = NO;
        _selectBtn.hidden = YES;
    }
    
//    BBLog(@"%d", nameListModel.isSelected);
}

@end
