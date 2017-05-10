//
//  NewGoodHeaderView.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/27.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewGoodHeaderView.h"
#import "SDCycleScrollView.h"
@implementation NewGoodHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{

    
}

//这个不要动 --   allDatas  在主控制器弄好后 传过来
 //创建4个字典对应的key   labelTitle   images    priceLabel     marketLabel
-(void)setAllDatas:(DetailHeaderModel *)allDatas{
    _allDatas=allDatas;
 
    //标题
    self.labelTitle.text=allDatas.labelTitle;
//    self.labelTitle.backgroundColor=[UIColor redColor];
    
    //图片
    NSArray*imageArray=allDatas.images;
    self.bannerScrollView.imagesGroup=imageArray;
    self.bannerScrollView.placeholder=@"placeholder_375x375";
    self.bannerScrollView.autoScrollTimeInterval=3;
   
    
    //现价
    NSString*num =allDatas.priceLabel;
    CGFloat number=[num floatValue];
    NSString*jiage=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,number];
    NSMutableAttributedString*vip=[[NSMutableAttributedString alloc]initWithString:@"vip:" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(189, 189, 189, 1),NSFontAttributeName:[UIFont systemFontOfSize:14]}];

    NSMutableAttributedString*newjiage=[[NSMutableAttributedString alloc]initWithString:jiage attributes:@{NSForegroundColorAttributeName:RGBCOLOR(252, 76, 30, 1),NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    [vip appendAttributedString:newjiage];
    
    _priceLabel.attributedText=vip;
    
    
    //原价
    NSMutableAttributedString*aa=[[NSMutableAttributedString alloc]initWithString:@"市场价：" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(189, 189, 189, 1),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    
    NSString*num2=allDatas.marketLabel;
    CGFloat number2=[num2 floatValue];
    NSString*xx=[NSString stringWithFormat:@"%@%.2f",[UserSession instance].currency,number2];
    NSMutableAttributedString*bb=[[NSMutableAttributedString alloc]initWithString:xx attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:RGBCOLOR(189, 189, 189, 1)}];
    [bb addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, bb.length)];
    [aa appendAttributedString:bb];
    _marketLabel.attributedText=aa;
    
//    _marketLabel.text=[NSString stringWithFormat:@"市场价:%@%.2f",[UserSession instance].currency,number2];
    
    
    
}


@end
