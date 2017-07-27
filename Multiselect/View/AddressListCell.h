//
//  AddressListCell.h
//  baobaotong
//
//  Created by GHZ on 2017/7/11.
//  Copyright © 2017年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressListCell, NameListModel;
@protocol cellBtnDelegate <NSObject>

- (void)cellBtnClick: (AddressListCell *)cell;

@end

@interface AddressListCell : UITableViewCell

@property(nonatomic, strong) UIView *imageV;
@property(nonatomic, strong) UILabel *firstNameLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) UILabel *didAddLabel;
@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, assign) BOOL isSelected;
//代理属性
@property(nonatomic,weak) id<cellBtnDelegate> delegate;

@property(nonatomic, strong) NameListModel *nameListModel;

- (void)setchecked:(BOOL)checked;

//@property(nonatomic, copy) void (^cellBtnClickCallbackBlock)(AddressListCell *cell); //cell按钮点击回调block

@end
