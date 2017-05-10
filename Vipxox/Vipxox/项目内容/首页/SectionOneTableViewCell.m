//
//  SectionOneTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SectionOneTableViewCell.h"
#import "YoohuoViewController.h"
#import "UIButton+WebCache.h"

@interface SectionOneTableViewCell()
@property(nonatomic,strong)NSMutableArray*allButtons;

@end
@implementation SectionOneTableViewCell


//-(void)DelegateForSectionOneCell:(NSArray *)array{
//    NSLog(@"%@",array);
//    for (int i=0; i<self.allButtons.count; i++) {
//        UIButton*button=self.allButtons[i];
//
//        if (i==6) {
//            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:array[i][@"logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_188x96"]];
//
//            continue;
//        }
//        
//              [button sd_setBackgroundImageWithURL:[NSURL URLWithString:array[i][@"logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_94x96"]];
//    
//
//        
//    }
//    
//    
//}

-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;
    NSLog(@"%@",_allDatas);
    for (int i=0; i<self.allButtons.count; i++) {
        UIButton*button=self.allButtons[i];
        button.backgroundColor=[UIColor whiteColor];
        button.imageView.contentMode=UIViewContentModeScaleAspectFit;

        if (i==6) {
            [button sd_setImageWithURL:[NSURL URLWithString:_allDatas[i][@"logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_188x96"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (cacheType!=2) {
                    button.alpha=0.3;
                    CGFloat scale = 0.3;
                    button.transform = CGAffineTransformMakeScale(scale, scale);
                    
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        button.alpha=1;
                        CGFloat scale = 1.0;
                        button.transform = CGAffineTransformMakeScale(scale, scale);
                    }];
                }
            }];
            
            continue;
        }
        
        [button sd_setImageWithURL:[NSURL URLWithString:_allDatas[i][@"logo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_94x96"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cacheType!=2) {
                button.alpha=0.3;
                CGFloat scale = 0.3;
                button.transform = CGAffineTransformMakeScale(scale, scale);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    button.alpha=1;
                    CGFloat scale = 1.0;
                    button.transform = CGAffineTransformMakeScale(scale, scale);
                }];
            }
        }];
        
        
        
    }

    
    
    
}


- (void)awakeFromNib {
    CGFloat with=KScreenWidth/4;
    CGFloat height=ACTUAL_HEIGHT(96);
    
    self.allButtons=[NSMutableArray array];
    
    //6+1
    for (int i=0; i<6; i++) {
        int heng =i%4;
        int shu =i/4;
        
        UIButton*button=[UIButton buttonWithType:0];
        button.frame=CGRectMake(KScreenWidth/4*heng, ACTUAL_HEIGHT(36)+height*shu, with, height);
        button.tag=i;
        button.backgroundColor=[UIColor whiteColor];
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [self.allButtons addObject:button];
        
    }

    //1
    UIButton*button1=[UIButton buttonWithType:0];
    button1.frame=CGRectMake(KScreenWidth/2, ACTUAL_HEIGHT(132), KScreenWidth/2, height);
    button1.tag=6;
    button1.backgroundColor=[UIColor whiteColor];
    [button1 addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button1];
    [self.allButtons addObject:button1];
    

    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}

-(void)touchButton:(UIButton*)sender{
//    NSLog(@"%ld",(long)sender.tag);
    if ([self.delegate respondsToSelector:@selector(touchSectionOne:)]) {
        [self.delegate touchSectionOne:sender];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
