//
//  GoodsBuyOnBehalfViewController.h
//  Vipxox
//
//  Created by Brady on 16/3/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsBuyOnBehalfViewControllerDelegate <NSObject>
@end

@interface GoodsBuyOnBehalfViewController : UIViewController
@property(nonatomic,strong)NSString *url;

@property(nonatomic,strong)NSDictionary*thisDatas;  //所有该页的信息  然而知识要id

@end
