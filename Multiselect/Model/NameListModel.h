//
//  NameListModel.h
//  baobaotong
//
//  Created by GHZ on 2017/7/18.
//  Copyright © 2017年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NameListModel : NSObject

@property (nonatomic, strong) NSString *backgorund; //名字第一个字对应的背景
@property (nonatomic, strong) NSString *firstword; //名字第一个字
@property (nonatomic, strong) NSString *idField;
@property (nonatomic, strong) NSString *isadd; //是否添加过
@property (nonatomic, strong) NSArray *mobilephone; //电话
@property (nonatomic, strong) NSString *name; //名字
@property (nonatomic, strong) NSString *ID; //id


@property(nonatomic, assign) BOOL isSelected;

@end
