//
//  DepartmentSection0TableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/11.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "DepartmentSection0TableViewCell.h"

@implementation DepartmentSection0TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    UITapGestureRecognizer*tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap:)];
    self.imageView1.userInteractionEnabled=YES;
    [self.imageView1 addGestureRecognizer:tap1];
    self.imageView1.backgroundColor=[UIColor whiteColor];
    
    
    UITapGestureRecognizer*tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap:)];
    self.imageView2.userInteractionEnabled=YES;
    [self.imageView2 addGestureRecognizer:tap2];
      self.imageView2.backgroundColor=[UIColor whiteColor];

    UITapGestureRecognizer*tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap:)];
    self.imageView3.userInteractionEnabled=YES;
    [self.imageView3 addGestureRecognizer:tap3];
      self.imageView3.backgroundColor=[UIColor whiteColor];

    UITapGestureRecognizer*tap4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap:)];
    self.imageView4.userInteractionEnabled=YES;
    [self.imageView4 addGestureRecognizer:tap4];
      self.imageView4.backgroundColor=[UIColor whiteColor];

    UITapGestureRecognizer*tap5=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTap:)];
    self.imageView5.userInteractionEnabled=YES;
    [self.imageView5 addGestureRecognizer:tap5];
      self.imageView5.backgroundColor=[UIColor whiteColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)touchTap:(UITapGestureRecognizer*)tap{
    NSLog(@"%lu",tap.view.tag);
    if (self.tapBlock) {
        self.tapBlock(tap.view.tag);
    }
    
}

@end
