//
//  ChinaSuperMarketViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChinaSuperMarketViewControllerDelegate <NSObject>

-(void)dismissThisVC;   //移除这个控制器
//-(void)touchGuangjie:(NSInteger)row;   //逛街

@end
@interface ChinaSuperMarketViewController : UIViewController
@property(nonatomic,assign)BOOL isSuperMark;   //是否是超市
@property(nonatomic,assign)id<ChinaSuperMarketViewControllerDelegate>delegate;

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIButton*backButton;
@property(nonatomic,strong)UIView*topView;

@property(nonatomic,strong)UIImageView*spImageView;  //华人超市图片

@property(nonatomic,assign)int xcolor;   //颜色 0黑色man    1红色yoohoo   2蓝色男孩
@end
