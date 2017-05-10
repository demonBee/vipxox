//
//  RealChooseViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RealChooseViewControllerDelegate <NSObject>

-(void)backGoods:(NSString*)mainGoods subGoods:(NSString*)subgoods andTag:(NSInteger)tag;


@end

@interface RealChooseViewController : UIViewController
@property(nonatomic,strong)NSArray*allDatas;   //所有的内容
@property(nonatomic,strong)NSArray*subAllDatas;  //当有子页面的时候  创建第二个tableView；


@property(nonatomic,weak)id<RealChooseViewControllerDelegate>delegate;
@end
