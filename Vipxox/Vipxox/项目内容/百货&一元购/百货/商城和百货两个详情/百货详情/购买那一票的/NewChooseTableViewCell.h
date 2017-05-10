//
//  ChooseTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewChooseTableViewCell : UITableViewCell

@property(nonatomic,strong)NSDictionary*dict;   //所有的数据
@property(nonatomic,strong)NSDictionary*canChoose;   //能够选中的  和  所有的数据作对比

//
@property(nonatomic,copy)void(^chooseBlock)(NSString*str,NSString*key);
@end






