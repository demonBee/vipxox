//
//  ThreePartLoginViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreePartLoginViewController : UIViewController

@property(nonatomic,strong)NSString*aPhoto;
@property(nonatomic,strong)NSString*aname;

@property(nonatomic,strong)NSString*aplatformName;
@property(nonatomic,strong)NSString*ausid;


@property(nonatomic,strong)NSString*cid;   //4个参数通过他获取

@property(nonatomic,strong)NSDictionary*params;   //这个参数传递到下一个界面 用于实现自动登录
@end
