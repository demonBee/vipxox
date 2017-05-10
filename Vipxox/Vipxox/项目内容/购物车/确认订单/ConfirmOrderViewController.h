//
//  ConfirmOrderViewController.h
//  Vipxox
//
//  Created by Brady on 16/3/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmOrderViewController : UIViewController

@property(nonatomic,strong)NSArray*allDatas;   //所有数据
@property(nonatomic,assign)CGFloat allMoney;   //所有金额
@property(nonatomic,assign)CGFloat allTrans;  //所有运费
@property(nonatomic,strong)NSDictionary*dizhi;   //地址

#pragma mark----立即购买所需要的东西    //我就不懂了   MB
@property(nonatomic,assign)BOOL immeToBuy;
//@property(nonatomic,strong)NSArray*saveThreeParams;    //保存3个参数

@property(nonatomic,strong)NSString*attr;  //组织好的属性
@property(nonatomic,strong)NSString*num;  //数量
@property(nonatomic,strong)NSString*idd;  //商品id

@end
