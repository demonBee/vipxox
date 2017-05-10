//
//  CommitTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "CommitTableViewCell.h"

@implementation CommitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoImageView.layer.cornerRadius=26;
    self.photoImageView.layer.masksToBounds=YES;
//    self.photoImageView.backgroundColor=[UIColor blueColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


  // 旧版  userimg user con  score  attr create_time  没有 赞字段 多了个属性字段
//新版 只要影藏 属性字段 在显示 赞 赞需要修改
-(void)FourCan:(whichInterface)interface andDict:(DetailCommitModel*)dict{
    self.entity=dict;
    self.interface=interface;
    switch (interface) {
        case 2:{
           
            //旧版 详情
             [self oldPinglun];
              self.left.constant=15;
        }
            
            break;
        case 3:{
            //旧版 列表
             [self oldPinglun];
            self.left.constant=0;
        }
            
            break;
        case 0:{
            //百货 详情
            [self newDepartment];
             self.left.constant=15;
        }
            
            break;
        case 1:{
            //百货 列表
             [self newDepartment];
             self.left.constant=0;
        }
            
            break;

        default:
            break;
    }
    
    
    
}

//新版
-(void)newDepartment{
//    _zanButton  现在 没有 那就 一直影藏这把
    self.zanButton.hidden=YES;
    self.attruLabel.hidden=YES;

    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.userimg] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //懒得写动画了
    }];
    
    self.userName.text=self.entity.user;
    self.timeLabel.text=self.entity.create_time;
    self.contentLabel.text=self.entity.con;
  
    
    //星星
    NSString*xingxing=self.entity.score;
    int a=[xingxing intValue];
    for (int i=11; i<16; i++) {
        UIImageView*imageView=[self viewWithTag:i];
        
        if (imageView.tag-10<=a) {
            //亮
            imageView.image=[UIImage imageNamed:@"img_star"];
        }else{
            //灰
            imageView.image=[UIImage imageNamed:@"img_star_grey"];
        }
        
    }

    
    
}


// 旧版  userimg user con  score  attr create_time  没有 赞字段 多了个属性字段

//老的评论
-(void)oldPinglun{
    //两者存在一个
    self.zanButton.hidden=YES;
    self.attruLabel.hidden=NO;
    self.attruLabel.text=self.entity.attr;

    
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.entity.userimg] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //懒得写动画了
        }];

    self.userName.text=self.entity.user;
    self.timeLabel.text=self.entity.create_time;
    self.contentLabel.text=self.entity.con;
     self.left.constant=15;   //底下的线
    
      //星星
    NSString*xingxing=self.entity.score;
    int a=[xingxing intValue];
    for (int i=11; i<16; i++) {
        UIImageView*imageView=[self viewWithTag:i];
        
        if (imageView.tag-10<=a) {
            //亮
            imageView.image=[UIImage imageNamed:@"img_star"];
        }else{
            //灰
              imageView.image=[UIImage imageNamed:@"img_star_grey"];
        }
        
    }
    
    
}


-(void)touchButton{
    NSLog(@"11");
}


@end
