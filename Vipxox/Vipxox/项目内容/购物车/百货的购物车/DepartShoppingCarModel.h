//
//  DepartShoppingCarModel.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/9.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DepartShoppingCarModel : NSObject

//name = "\U6d4b\U8bd5\U5546\U54c1";
//pic = "";
//price = "99.00";
//quantity = 1;
//setmeal = "";



@property(nonatomic,strong)NSString*pic;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*setmeal;    //属性和名字拼一起

@property(nonatomic,strong)NSString*num;
@property(nonatomic,strong)NSString*price;

@property(nonatomic,strong)NSString*idd;

@property(nonatomic,assign)BOOL isSelected;   //已经选中

@end
