//
//  AdressListResult.h
//  baobaotong
//
//  Created by lk on 2017/7/20.
//  Copyright © 2017年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdressListInfo.h"
@interface AdressListResult : NSObject
@property (nonatomic, strong) NSString * javaClass;
@property (nonatomic, strong) AdressListInfo * result;
@property (nonatomic, strong) NSString * resultdesc;
@property (nonatomic, assign) NSInteger resultstate;
@end
