//
//  EditCommentTableViewCell.h
//  shashou
//
//  Created by 黄佳峰 on 16/7/6.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^commentStarBtnBlock)(NSUInteger);



@interface EditCommentTableViewCell : UITableViewCell


@property (nonatomic,copy)commentStarBtnBlock starCount;




@end
