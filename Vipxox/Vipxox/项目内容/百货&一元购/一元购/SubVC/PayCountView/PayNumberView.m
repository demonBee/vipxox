//
//  PayNumberView.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "PayNumberView.h"

#define IMAGENAMED(NAME)       [UIImage imageNamed:NAME]
#define SYSTEMFONT(FONTSIZE)     [UIFont systemFontOfSize:FONTSIZE]
@implementation PayNumberView

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews{
    
    UIImageView *numberBg = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.width,ACTUAL_WIDTH(30.f))];
    numberBg.image = IMAGENAMED(@"numbe_bg_icon");
    
    [self addSubview:numberBg];
    
    
    self.numberLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, numberBg.width, numberBg.height)];
    self.numberLab.text = @"1";
    self.numberLab.textAlignment = NSTextAlignmentCenter;
    self.numberLab.textColor = [UIColor darkGrayColor];
    self.numberLab.font = SYSTEMFONT(12);
    [numberBg addSubview:self.numberLab];
    
    self.jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jianBtn.frame = CGRectMake(0.f,0.f, ACTUAL_WIDTH(40.f), ACTUAL_WIDTH(30.f));
    [self.jianBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.jianBtn.tag = 11;
    [self.jianBtn setImage:IMAGENAMED(@"jian_icon") forState:UIControlStateNormal];
    self.jianBtn.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.jianBtn];
    
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(self.width - ACTUAL_WIDTH(40.f),self.jianBtn.top, ACTUAL_WIDTH(40.f), ACTUAL_WIDTH(30.f));
    self.addBtn.tag = 12;
    [self.addBtn setImage:IMAGENAMED(@"add_icon") forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.addBtn];
    
    
}

- (void)awakeFromNib {
    
    
}

- (void)deleteBtnAction:(UIButton *)sender {
    if ([self.numberLab.text integerValue] <=1)return;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnAction:addNumberView:)]){
        
        [self.delegate deleteBtnAction:sender addNumberView:self];
    }
    
    
}

- (void)addBtnAction:(UIButton *)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(addBtnAction:addNumberView:)]){
        
        [self.delegate addBtnAction:sender addNumberView:self];
    }
    
}

@end
