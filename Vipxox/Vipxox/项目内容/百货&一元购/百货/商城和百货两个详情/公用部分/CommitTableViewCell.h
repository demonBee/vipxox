//
//  CommitTableViewCell.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCommitModel.h"

typedef NS_ENUM(NSInteger,whichInterface){
    isShoppingDetail=0,
    isCommitList=1,
    
    isOldDetail=2,
    isOldCommitList
    
};

@interface CommitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;  //底部的线

@property (weak, nonatomic) IBOutlet UIButton *zanButton;   //赞和属性 只有一个存在
@property (weak, nonatomic) IBOutlet UILabel *attruLabel;

@property(nonatomic,assign)whichInterface interface;  //两个界面用到

@property(nonatomic,strong)DetailCommitModel*entity;   //所有的数据

//4种可能
-(void)FourCan:(whichInterface)interface andDict:(DetailCommitModel*)dict;

@end
