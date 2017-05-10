//
//  AffirmOrderTableViewCell.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/22.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "AffirmOrderTableViewCell.h"

@implementation AffirmOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        self.backgroundColor=[UIColor yellowColor];
        
        _courierImageView=[[UIImageView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(40), ACTUAL_HEIGHT(40))];
        _courierImageView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_courierImageView];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(70), ACTUAL_HEIGHT(10), KScreenWidth-ACTUAL_WIDTH(115), ACTUAL_HEIGHT(20))];
        _titleLabel.textAlignment=0;
        _titleLabel.text=@"本地中邮平邮";
//        _titleLabel.backgroundColor=[UIColor blueColor];
        [self addSubview:_titleLabel];
        
        _priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(70), ACTUAL_HEIGHT(35),ACTUAL_WIDTH(130), ACTUAL_HEIGHT(20))];
        _priceLabel.textAlignment=0;
        _priceLabel.text=@"$108.15";
        _priceLabel.textColor=RGBCOLOR(193, 0, 22, 1);
//        _priceLabel.backgroundColor=[UIColor greenColor];
        [self addSubview:_priceLabel];
        
        _dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(200), ACTUAL_HEIGHT(35), KScreenWidth-ACTUAL_WIDTH(215), ACTUAL_HEIGHT(20))];
        _dayLabel.textAlignment=0;
        _dayLabel.textColor=RGBCOLOR(193, 0, 22, 1);
        _dayLabel.font=[UIFont systemFontOfSize:14];
//        _dayLabel.backgroundColor=[UIColor yellowColor];
        [self addSubview:_dayLabel];
        
        _introduceLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(60), KScreenWidth-ACTUAL_WIDTH(65), ACTUAL_HEIGHT(20))];
        _introduceLabel.textAlignment=0;
        _introduceLabel.text=@"清关速度快，可接受内置或配套电池物品";
//        _introduceLabel.backgroundColor=[UIColor purpleColor];
        _introduceLabel.font=[UIFont systemFontOfSize:14];
        [self addSubview:_introduceLabel];
        
        _courierLimitedLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(80), KScreenWidth-ACTUAL_WIDTH(65), ACTUAL_HEIGHT(40))];
        _courierLimitedLabel.textAlignment=0;
        _courierLimitedLabel.text=@"商品限制：液体、粉末、膏体、枪支弹药、化工用品、易燃易爆品 重量：3kg";
//        _courierLimitedLabel.backgroundColor=[UIColor orangeColor];
        _courierLimitedLabel.font=[UIFont systemFontOfSize:14];
        _courierLimitedLabel.numberOfLines=2;
        [self addSubview:_courierLimitedLabel];
        
        self.imageHook=[[UIButton alloc]init];
        self.imageHook.frame=CGRectMake(ACTUAL_WIDTH(330), ACTUAL_HEIGHT(50), ACTUAL_WIDTH(33), ACTUAL_HEIGHT(30));
        [self.imageHook setBackgroundImage:[UIImage imageNamed:@"whiteBall"] forState:UIControlStateNormal];
        [self.imageHook setBackgroundImage:[UIImage imageNamed:@"blackBall"] forState:UIControlStateSelected];
        [self addSubview:self.imageHook];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
