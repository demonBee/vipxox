//
//  scrollTwoTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol scrollTwoTableViewCellDelegate <NSObject>

-(void)touchSectionZero:(UIButton*)sender;

@end
@interface scrollTwoTableViewCell : UITableViewCell<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView*scroll;
@property(nonatomic,strong)UIPageControl*pageControl;

@property(nonatomic,weak)id<scrollTwoTableViewCellDelegate>delegate;
@property(nonatomic,strong)NSArray*allDatas;
@property(nonatomic,strong)NSMutableArray*saveAllButtons;
@end
