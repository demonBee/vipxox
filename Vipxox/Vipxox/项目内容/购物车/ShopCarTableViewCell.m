//
//  ShopCarTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ShopCarTableViewCell.h"

#import "ShopCarViewController.h"

@implementation ShopCarTableViewCell

- (void)awakeFromNib {
   self.addView=[[AddNumberView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(137), ACTUAL_HEIGHT(8), ACTUAL_WIDTH(140), ACTUAL_HEIGHT(32))];
    
    if (IS_IPHONE_5||IS_IPHONE_4_OR_LESS) {
        [self.addView setX:130];
    }
      self.addView.backgroundColor=[UIColor whiteColor];
      self.addView.hidden=YES;
    [self.contentView addSubview:  self.addView];
  

    self.buttonChoose=[UIButton buttonWithType:0];
    self.buttonChoose.backgroundColor=[UIColor blackColor];
    self.buttonChoose.frame=CGRectMake(ACTUAL_WIDTH(137), ACTUAL_HEIGHT(40), ACTUAL_WIDTH(140), ACTUAL_HEIGHT(32));
    self.buttonChoose.hidden=YES;
    self.tag=self.tag;
    [self.buttonChoose addTarget:self action:@selector(touchThisButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.buttonChoose];
#warning  ---------- 先隐藏了
    self.buttonChoose.hidden=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)touchThisButton:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(delegateForShowChoose:)]) {
        [self.delegate delegateForShowChoose:sender];
    }
    
}

@end
