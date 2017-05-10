//
//  ShoppingCarHeaderView.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/9.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ShoppingCarHeaderView.h"

@implementation ShoppingCarHeaderView






-(void)awakeFromNib{
    [super awakeFromNib];
    UIButton*button=[self viewWithTag:999];
    [button setBackgroundImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted=NO;
    
    
    UIButton*toBuy=[self viewWithTag:3];
    [toBuy addTarget:self action:@selector(touchToBuy) forControlEvents:UIControlEventTouchUpInside];

    
}


#pragma mark --  touch
-(void)touchButton:(UIButton*)sender{
    if (sender.selected) {
        sender.selected=NO;
        if (self.selectAllBlock) {
            self.selectAllBlock(sender.selected);
        }
        
        
        
    }else{
        sender.selected=YES;
        if (self.selectAllBlock) {
            self.selectAllBlock(sender.selected);
        }

    }
    
}


//去凑单
-(void)touchToBuy{
    if (self.ToBuyBlock) {
        self.ToBuyBlock();
    }
    
    
}

@end
