//
//  ChooseViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseViewControllerDelegate <NSObject>

-(void)chooseWhichRow:(NSIndexPath*)indexPath;

//-(void)delegateForShaixuan:(NSMutableArray*)array;    // 点了确定按钮 之后通知底部控制器 偏移到 0 0 位置  之后再刷新
@end
@interface ChooseViewController : UIViewController
@property(nonatomic,weak)id<ChooseViewControllerDelegate>delegate;

@end
