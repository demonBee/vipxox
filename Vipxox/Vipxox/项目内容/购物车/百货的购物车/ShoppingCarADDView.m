//
//  ShoppingCarADDView.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/9.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ShoppingCarADDView.h"

@interface ShoppingCarADDView()
@property(nonatomic,strong)UILabel*numberLabel;

@property(nonatomic,assign)NSInteger number;
@property(nonatomic,strong)NSString*showString;


@end

@implementation ShoppingCarADDView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(void)awakeFromNib{
    
//    NSLog(@"%@",NSStringFromCGRect(self.frame));
    //self 的宽高   {85, 25}
    //25 25  35   3者的宽高
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius=3;
    self.layer.masksToBounds=YES;
    
    UIButton*sub=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.width*25/85, self.height)];
    [sub setBackgroundImage:[UIImage imageNamed:@"减号1"] forState:UIControlStateNormal];
    [sub addTarget:self action:@selector(touchSub) forControlEvents:UIControlEventTouchUpInside];
    sub.layer.borderColor=RGBCOLOR(158, 158, 158, 1).CGColor;
    sub.layer.borderWidth=1;

    [self addSubview:sub];
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(sub.right-1, 0, self.width*35/85+2, self.height)];
    titleLabel.layer.borderColor=RGBCOLOR(158, 158, 158, 1).CGColor;
    titleLabel.layer.borderWidth=1;
    titleLabel.font=[UIFont systemFontOfSize:12];
    titleLabel.textAlignment=NSTextAlignmentCenter;
//    titleLabel.text=@"1";
    self.numberLabel=titleLabel;
    [self addSubview:titleLabel];
    
    UIButton*add=[[UIButton alloc]initWithFrame:CGRectMake(titleLabel.right-1, 0, self.width*25/85, self.height)];
    [add setBackgroundImage:[UIImage imageNamed:@"加号1"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(touchAdd) forControlEvents:UIControlEventTouchUpInside];

    add.layer.borderColor=RGBCOLOR(158, 158, 158, 1).CGColor;
    add.layer.borderWidth=1;
    [self addSubview:add];

    
    
}

#pragma mark  --   touch
-(void)touchSub{
    if (self.number>1) {
        self.number--;
        if (self.AddBlock) {
            _AddBlock(self.number);
        }
        
        
    }
    
    
}


-(void)touchAdd{
    if (self.number<9) {
        self.number++;
        if (self.SubBlock) {
            self.SubBlock(self.number);
        }
        
        
    }
    
}


#pragma mark   ----set
-(void)setCurrentStr:(NSString *)currentStr{
    _currentStr=currentStr;
    NSInteger aa =[currentStr integerValue];
    
//    if (aa<1) {
//        aa=1;
//    }
    
    self.number=aa;
    
    
}

-(void)setNumber:(NSInteger)number{
    _number=number;
    self.numberLabel.text=[NSString stringWithFormat:@"%ld",(long)number];
    
}


@end
