//
//  CategoryViewController.h
//  weimao
//
//  Created by 黄佳峰 on 16/2/26.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChinaSuperMarketViewController.h"

@protocol CategoryViewControllerDelegate <NSObject>

-(void)touchCategory:(NSIndexPath*)indexPath;

@end

@interface CategoryViewController : UIViewController
@property(nonatomic,strong)ChinaSuperMarketViewController*ChinaSM;
@property(nonatomic,strong)NSArray*allDatas;
@property(nonatomic,assign)id<CategoryViewControllerDelegate>delegate;

@property(nonatomic,assign)int xcolor;   //颜色 0黑色man    1红色yoohoo   2蓝色男孩
@end
