//
//  ModifiedCodeTableViewCell.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/16.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "ModifiedCodeTableViewCell.h"

@implementation ModifiedCodeTableViewCell

- (void)awakeFromNib {
    
    
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
   
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(0), ACTUAL_WIDTH(100),ACTUAL_HEIGHT(44))];
        self.label.text=@"原密码";
        self.label.textColor=RGBCOLOR(105, 105, 105, 1);
        self.label.textAlignment=1;
        self.label.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.label];
        
        self.textField=[[UITextField alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(105), ACTUAL_HEIGHT(13), ACTUAL_WIDTH(160), ACTUAL_HEIGHT(20))];
        self.textField.placeholder=@"请输入原密码";
        self.textField.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.textField];

 
    
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
