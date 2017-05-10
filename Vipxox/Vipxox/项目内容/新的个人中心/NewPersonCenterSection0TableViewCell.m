//
//  NewPersonCenterSection0TableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/19.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewPersonCenterSection0TableViewCell.h"

@implementation NewPersonCenterSection0TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    for (int i =1; i<6; i++) {
        UIImageView*imageView=[self viewWithTag:i];
        imageView.backgroundColor=[UIColor whiteColor];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapImageView:)];
        [imageView addGestureRecognizer:tap];
        
        
    }
    
}

-(void)TapImageView:(UITapGestureRecognizer*)tap{
  
    if (self.imageBolck) {
        self.imageBolck(tap.view.tag);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
