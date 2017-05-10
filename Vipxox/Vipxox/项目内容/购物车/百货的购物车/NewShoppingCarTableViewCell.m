//
//  NewShoppingCarTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/9.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewShoppingCarTableViewCell.h"
#import "ShoppingCarADDView.h"

@implementation NewShoppingCarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    UIButton*button=[self.contentView viewWithTag:1];
    [button setBackgroundImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted=NO;
    

    
    UIImageView*imageView=[self.contentView viewWithTag:2];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    imageView.layer.borderColor=RGBCOLOR(158, 158, 158, 1).CGColor;
    imageView.layer.borderWidth=1;
    
   
    
    UIButton*delete=[self viewWithTag:99];
    [delete addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    delete.adjustsImageWhenHighlighted=NO;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark --  touch
-(void)touchButton:(UIButton*)sender{
    if (sender.selected) {
        sender.selected=NO;
        
        if (self.CellButtonBlock) {
            self.CellButtonBlock(sender.selected);
        }
        
    }else{
        sender.selected=YES;
        if (self.CellButtonBlock) {
            self.CellButtonBlock(sender.selected);
        }

    }
    
    
    
    
}


-(void)deleteButton:(UIButton*)sender{
//    if (sender.selected) {
//        sender.selected=NO;
//    }else{
//        sender.selected=YES;
//        
//    }
    
    if (self.CellDeleteBlock) {
        self.CellDeleteBlock();
    }
    
    
}

@end
