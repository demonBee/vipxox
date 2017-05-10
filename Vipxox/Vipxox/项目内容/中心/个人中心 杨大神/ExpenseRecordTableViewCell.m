//
//  ExpenseRecordTableViewCell.m
//  weimao
//
//  Created by Brady on 16/2/22.
//  Copyright © 2016年 Brady. All rights reserved.
//

#import "ExpenseRecordTableViewCell.h"

@implementation ExpenseRecordTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _firstLabel1=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(16), ACTUAL_HEIGHT(18), ACTUAL_WIDTH(45), ACTUAL_HEIGHT(15))];
        _firstLabel1.font=[UIFont systemFontOfSize:16];
        _firstLabel1.textColor=RGBCOLOR(167, 167, 167, 1);
        [self addSubview:_firstLabel1];
        
        _firstLabel2=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(14), ACTUAL_HEIGHT(42), ACTUAL_WIDTH(50), ACTUAL_HEIGHT(13))];
        _firstLabel2.font=[UIFont systemFontOfSize:14];
        _firstLabel2.textColor=RGBCOLOR(196, 196, 196, 1);
        [self addSubview:_firstLabel2];
        
        _firstLabel3=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(125), ACTUAL_HEIGHT(18), ACTUAL_WIDTH(150), ACTUAL_HEIGHT(17))];
        _firstLabel3.textColor=RGBCOLOR(68, 68, 68, 1);
        _firstLabel3.font=[UIFont systemFontOfSize:16];
        [self addSubview:_firstLabel3];
        
        _firstLabel4=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(125), ACTUAL_HEIGHT(41),KScreenWidth-ACTUAL_WIDTH(125), ACTUAL_HEIGHT(40))];
        _firstLabel4.text=@"[baobao]取消单个商品返款";
        _firstLabel4.font=[UIFont systemFontOfSize:14];
        _firstLabel4.textColor=RGBCOLOR(167, 167, 167, 1);
        _firstLabel4.numberOfLines=2;
        [self addSubview:_firstLabel4];
        
        _firstLabel5=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(200), ACTUAL_HEIGHT(15),KScreenWidth-ACTUAL_WIDTH(210), ACTUAL_HEIGHT(16))];
        _firstLabel5.font=[UIFont systemFontOfSize:13];
        _firstLabel5.textColor=RGBCOLOR(240, 114, 117, 1);
        _firstLabel5.textAlignment=2;
        [self addSubview:_firstLabel5];
        
        _imageview1=[[UIImageView alloc]init];
        _imageview1.backgroundColor=[UIColor whiteColor];
        _imageview1.contentMode=UIViewContentModeScaleAspectFit;
        _imageview1.frame=CGRectMake(ACTUAL_WIDTH(70), ACTUAL_HEIGHT(12), ACTUAL_WIDTH(43), ACTUAL_HEIGHT(43));
        [self addSubview:_imageview1];
        
        

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
