//
//  BrandTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "BrandTableViewCell.h"

@implementation BrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}

-(void)setEntity:(brandModel *)entity{
    _entity=entity;
    
    UILabel*label1=[self viewWithTag:1];
    label1.text=@"品牌";
    
#
    UILabel*label2=[self viewWithTag:2];
    label2.text=[NSString stringWithFormat:@"查看全部%@件商品",entity.number];
    
    UIImageView*imageView3=[self viewWithTag:3];
    imageView3.contentMode=UIViewContentModeScaleAspectFit;
    imageView3.backgroundColor=[UIColor whiteColor];
    [imageView3 sd_setImageWithURL:[NSURL URLWithString:entity.logo] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    UILabel*titleLabel=[self viewWithTag:4];
    titleLabel.text=entity.name;
    
    
    UILabel*contentLabel=[self viewWithTag:5];
    contentLabel.text=entity.descriptionn;
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
