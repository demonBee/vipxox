//
//  MyCollectionTableViewCell.m
//  Vipxox
//
//  Created by Brady on 16/3/9.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "MyCollectionTableViewCell.h"

@implementation MyCollectionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(96), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(250), ACTUAL_HEIGHT(40))];
        _titleLabel.font=[UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines=2;
        [self addSubview:_titleLabel];
        
//        _currencyLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(96), ACTUAL_HEIGHT(65), ACTUAL_WIDTH(14), ACTUAL_HEIGHT(18))];
//        _currencyLabel.font=[UIFont systemFontOfSize:14];
//        _currencyLabel.textAlignment=NSTextAlignmentRight;
//        _currencyLabel
//        [self addSubview:_currencyLabel];
        
        _moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(96), ACTUAL_HEIGHT(65), ACTUAL_WIDTH(250), ACTUAL_HEIGHT(18))];
        _moneyLabel.font=[UIFont systemFontOfSize:14];
        _moneyLabel.textColor=RGBCOLOR(195, 0, 22, 1);
        [self addSubview:_moneyLabel];
        
        _imageview1=[[UIImageView alloc]init];
        _imageview1.backgroundColor=[UIColor whiteColor];
        _imageview1.contentMode=UIViewContentModeScaleAspectFit;

        _imageview1.frame=CGRectMake(ACTUAL_WIDTH(18), ACTUAL_HEIGHT(16), ACTUAL_WIDTH(70), ACTUAL_HEIGHT(95));
//        _imageview1.image=[UIImage imageNamed:@"Logo"];
        [self addSubview:_imageview1];
        
        _goodsDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(96), ACTUAL_HEIGHT(90), ACTUAL_WIDTH(300), ACTUAL_HEIGHT(20))];
//        _goodsDetailLabel.backgroundColor=[UIColor redColor];
        _goodsDetailLabel.font=[UIFont systemFontOfSize:12];
        _goodsDetailLabel.textColor=[UIColor grayColor];
        [self addSubview:_goodsDetailLabel];
        
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
