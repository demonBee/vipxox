//
//  SectionOneTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionOneTableViewCellDelegate <NSObject>

-(void)touchSectionOne:(UIButton*)sender;    //点击事件


@end
@interface SectionOneTableViewCell : UITableViewCell

@property(nonatomic,weak)id<SectionOneTableViewCellDelegate>delegate;
@property(nonatomic,strong)NSArray*allDatas;


@end
