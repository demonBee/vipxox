//
//  OldChooseTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OldChooseTableViewCell : UITableViewCell
@property(nonatomic,strong)NSMutableArray*allDatas;

@property(nonatomic,copy)void(^chooseBlock)(NSString*value,NSString*key);
-(CGFloat)getHeight;
@end
