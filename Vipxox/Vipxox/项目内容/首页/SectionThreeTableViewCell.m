//
//  SectionThreeTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "SectionThreeTableViewCell.h"
#import "YoohuoViewController.h"
#import "UIButton+WebCache.h"

@interface SectionThreeTableViewCell()<YoohuoViewControllerDelegate>

@property(nonatomic,strong)NSArray*thisDatas;
@end
@implementation SectionThreeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)DelegateForSectionThreeCell:(NSArray *)array{
    self.thisDatas=array;
    NSLog(@"%@",array);
    self.labelTitle.text=array[0][@"name"];
    NSArray*sixDict=array[0][@"con_list"];
    _button0.backgroundColor=[UIColor whiteColor];
    _button0.imageView.contentMode=UIViewContentModeScaleToFill;

    [self.button0 sd_setBackgroundImageWithURL:[NSURL URLWithString:sixDict[0][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_375x232"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            self.button0.alpha=0.3;
            CGFloat scale = 0.3;
            self.button0.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                self.button0.alpha=1;
                CGFloat scale = 1.0;
                self.button0.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    _button1.backgroundColor=[UIColor whiteColor];
    _button1.imageView.contentMode=UIViewContentModeScaleAspectFit;

    [self.button1 sd_setImageWithURL:[NSURL URLWithString:sixDict[1][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_150x224"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            self.button1.alpha=0.3;
            CGFloat scale = 0.3;
            self.button1.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                self.button1.alpha=1;
                CGFloat scale = 1.0;
                self.button1.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }

    }];
    _button2.backgroundColor=[UIColor whiteColor];
    _button2.imageView.contentMode=UIViewContentModeScaleAspectFit;

    [self.button2 sd_setImageWithURL:[NSURL URLWithString:sixDict[2][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_112x112"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            self.button2.alpha=0.3;
            CGFloat scale = 0.3;
            self.button2.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                self.button2.alpha=1;
                CGFloat scale = 1.0;
                self.button2.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }

    }];
    _button3.backgroundColor=[UIColor whiteColor];
    _button3.imageView.contentMode=UIViewContentModeScaleAspectFit;

    [self.button3 sd_setImageWithURL:[NSURL URLWithString:sixDict[3][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_112x112"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            self.button3.alpha=0.3;
            CGFloat scale = 0.3;
            self.button3.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                self.button3.alpha=1;
                CGFloat scale = 1.0;
                self.button3.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }

    }];
    
    _button4.backgroundColor=[UIColor whiteColor];
    _button4.imageView.contentMode=UIViewContentModeScaleAspectFit;

    [self.button4 sd_setImageWithURL:[NSURL URLWithString:sixDict[4][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_112x112"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            self.button4.alpha=0.3;
            CGFloat scale = 0.3;
            self.button4.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                self.button4.alpha=1;
                CGFloat scale = 1.0;
                self.button4.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }

    }];
    _button5.backgroundColor=[UIColor whiteColor];
    _button5.imageView.contentMode=UIViewContentModeScaleAspectFit;

    [self.button5 sd_setImageWithURL:[NSURL URLWithString:sixDict[5][@"picName"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_112x112"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            self.button5.alpha=0.3;
            CGFloat scale = 0.3;
            self.button5.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                self.button5.alpha=1;
                CGFloat scale = 1.0;
                self.button5.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }

    }];

    
    
}
    


- (IBAction)touchButtons:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(touchImageButton:andThisCellAllDatas:)]) {
        [self.delegate touchImageButton:sender andThisCellAllDatas:self.thisDatas];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
