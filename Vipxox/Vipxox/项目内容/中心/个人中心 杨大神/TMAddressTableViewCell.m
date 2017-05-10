//
//  TMAddressTableViewCell.m
//  weimao
//
//  Created by Brady on 16/2/26.
//  Copyright © 2016年 Brady. All rights reserved.
//

#import "TMAddressTableViewCell.h"

@implementation TMAddressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _label1=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(80), ACTUAL_HEIGHT(20))];
        _label1.textAlignment=0;
//        _label1.text=@"baobao";
        _label1.textColor=RGBCOLOR(129, 129, 129, 1);
        _label1.font=[UIFont systemFontOfSize:14];
        [self addSubview:_label1];
        
        _label2=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(200), ACTUAL_HEIGHT(20))];
        _label2.textAlignment=0;
//        label2.backgroundColor=[UIColor greenColor];
//        _label2.text=@"加拿大／BC／Rechmond";
        _label2.textColor=RGBCOLOR(129, 129, 129, 1);
        _label2.font=[UIFont systemFontOfSize:14];
        [self addSubview:_label2];
        
        _label3=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(50), ACTUAL_WIDTH(120), ACTUAL_HEIGHT(20))];
        _label3.textAlignment=0;
//        _label3.text=@"7211 gilbert rd";
        _label3.textColor=RGBCOLOR(129, 129, 129, 1);
        _label3.font=[UIFont systemFontOfSize:14];
        [self addSubview:_label3];
        
        _label4=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(70), ACTUAL_WIDTH(80), ACTUAL_HEIGHT(20))];
        _label4.textAlignment=0;
//        _label4.text=@"V7c3w5";
        _label4.textColor=RGBCOLOR(129, 129, 129, 1);
        _label4.font=[UIFont systemFontOfSize:14];
        [self addSubview:_label4];
        
        _label5=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(150), ACTUAL_HEIGHT(70), KScreenWidth-ACTUAL_WIDTH(160), ACTUAL_HEIGHT(20))];
        _label5.textAlignment=0;
//        _label5.text=@"7788890525";
        _label5.textColor=RGBCOLOR(129, 129, 129, 1);
        _label5.font=[UIFont systemFontOfSize:14];
        _label5.textAlignment=2;
        [self addSubview:_label5];

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
