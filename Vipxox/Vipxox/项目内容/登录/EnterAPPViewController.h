//
//  EnterAPPViewController.h
//  Vipxox
//
//  Created by Brady on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EnterAPPViewControllerDelegate <NSObject>

-(void)delegateForGetDatas;   //购物车得到数据

@end
@interface EnterAPPViewController : UIViewController
@property(nonatomic,assign)id<EnterAPPViewControllerDelegate>delegate;

-(void)autoLogin;
@end
