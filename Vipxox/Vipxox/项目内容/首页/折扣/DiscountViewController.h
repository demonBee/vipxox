//
//  DiscountViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,categroy){
    isZhekou=0,
    isfenlei=1,    //24个分类
    isPingpai=2,
    isChaoliu=3,
   
//    thisIsShaixuan=4,   //筛选
    thisIsGrobalSend
    
};

@protocol DiscountViewControllerDelegate <NSObject>

-(void)DelegateForTitle:(NSString*)title;   //委托主控制器 改变title
-(void)DelegateMainControllerPush:(NSDictionary*)dict;

@end

@interface DiscountViewController : UIViewController

@property(nonatomic,assign)categroy cate;

@property(nonatomic,strong)NSDictionary*allDatas;  //保存所有的数据
@property(nonatomic,strong)NSString*titleName;  //就单单保存首页的名字

@property(nonatomic,assign)id<DiscountViewControllerDelegate>delegate;
@end
