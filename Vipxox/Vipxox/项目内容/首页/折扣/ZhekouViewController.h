//
//  ZhekouViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountViewController.h"
//#import "GoodsTailsViewController.h"
#import "NewGoodDetailViewController.h"

@protocol ZhekouViewControllerDelegate <NSObject>

-(void)delegateForClear;
-(void)delegateForSendOK;


@end

@interface ZhekouViewController : UIViewController

@property(nonatomic,assign)id<ZhekouViewControllerDelegate>delegate;

@property(nonatomic,strong)DiscountViewController*disCount;        //主显示图

@property(nonatomic,assign)int xColor;  //3种颜色

@end
