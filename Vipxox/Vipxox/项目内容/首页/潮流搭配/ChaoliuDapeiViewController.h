//
//  ChaoliuDapeiViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ChaoliuDapeiViewControllerDelegate <NSObject>

-(void)DelegateForCellSendDatas:(NSArray*)array;

@end
@interface ChaoliuDapeiViewController : UIViewController
@property(nonatomic,strong)NSDictionary*dict;
@property(nonatomic,weak)id<ChaoliuDapeiViewControllerDelegate>delegate;
@end
