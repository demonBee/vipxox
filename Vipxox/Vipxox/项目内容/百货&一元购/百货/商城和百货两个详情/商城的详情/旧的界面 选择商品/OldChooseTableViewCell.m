//
//  OldChooseTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OldChooseTableViewCell.h"

@interface OldChooseTableViewCell()

@property(nonatomic,strong)NSMutableArray*saveAllButton;

@property(nonatomic,assign)CGFloat BHeight;
@end
@implementation OldChooseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
       
    }
    return self;
}


-(void)setAllDatas:(NSMutableArray *)allDatas{
    _allDatas=allDatas;
    //一个标题 另一个是元素
    NSString*longStr=allDatas[0];
    NSArray*array=[longStr componentsSeparatedByString:@","];
    NSMutableArray*mtArray=[array mutableCopy];
    NSString*title=mtArray[0];
    
  [mtArray removeObject:mtArray[0]];
//    NSArray*aa=@[@"111",@"11111",@"11111111",@"11111111111",@"111",@"11111",@"11111111",@"11111111111",@"111",@"11111",@"11111111",@"11111111111",@"111",@"11111",@"11111111",@"11111111111",@"111",@"11111",@"11111111",@"11111111111",@"111",@"11111",@"11111111",@"11111111111",];
//    mtArray=[aa mutableCopy];
    
    
    UILabel*titleLabel=[self.contentView viewWithTag:1000];
    if (!titleLabel) {
        titleLabel=[[UILabel alloc]init];
        titleLabel.tag=1000;
        titleLabel.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:titleLabel];
    }
    
    NSString*str=title;
    titleLabel.text=str;
    CGSize strSize=[str boundingRectWithSize:CGSizeMake(KScreenWidth/2, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    titleLabel.y=(44-strSize.height)/2;
    titleLabel.x=15;
    titleLabel.size=strSize;
    
    CGFloat common= titleLabel.right+10;  //默认的距离左边
    CGFloat leftPoint=titleLabel.right+10;  //左边距离
    CGFloat leaveTop=titleLabel.y-6;     //距上可加
    CGFloat leavejianju=10;    //
    CGFloat buttonAddWith =16;   //每个button string大小要加上这个
    CGFloat ButtonHeight =27;
    
      self.saveAllButton=[NSMutableArray array];
    for (int i=0; i<mtArray.count; i++) {
        NSArray*name=mtArray;
        UIButton*button=[self.contentView viewWithTag:2000+i];
        if (!button) {
            button=[[UIButton alloc]init];
            button.tag=2000+i;
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            button.layer.borderWidth=1;
            button.layer.borderColor=RGBCOLOR(204, 204, 204, 1).CGColor;
            [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:button];
            
            
            
            
            
        }
        
        [button setTitle:name[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        
        
        [button setTitle:name[i] forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [button setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(228, 228, 228, 1)] forState:UIControlStateDisabled];
        
        
        [button setTitle:name[i] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(252, 76, 30, 1)] forState:UIControlStateSelected];
        
        
        
        CGSize stringSize=[name[i] boundingRectWithSize:CGSizeMake(KScreenWidth/3*2, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (leftPoint+stringSize.width+buttonAddWith+leavejianju>KScreenWidth) {
            leftPoint=common;
            leaveTop=leaveTop+ButtonHeight+10;
        }
        
        button.frame=CGRectMake(leftPoint, leaveTop, stringSize.width+buttonAddWith, ButtonHeight);
        
        
        leftPoint=leftPoint+stringSize.width+buttonAddWith+leavejianju;
        _BHeight=leaveTop+ButtonHeight+10;
        
        [self.saveAllButton addObject:button];
        
        
        
    }
    
    
}

-(CGFloat)getHeight{
    
    return _BHeight;
}

-(void)touchButton:(UIButton*)sender{
    
    NSInteger number=sender.tag-2000;
    NSString*longStr=_allDatas[0];
    NSArray*array=[longStr componentsSeparatedByString:@","];
    NSMutableArray*mtArray=[array mutableCopy];
    
    NSString*key=mtArray[0];    //key
    [mtArray removeObject:mtArray[0]];
    NSString*value=mtArray[number];   //值

    
    
    
    NSMutableArray*tempSaveAllButton=[self.saveAllButton mutableCopy];
    
    [tempSaveAllButton removeObject:sender];
    
    
    for (UIButton*button in tempSaveAllButton) {
        button.selected=NO;
    }
    
    
    if (sender.selected) {
        sender.selected=NO;
        if (self.chooseBlock) {
            self.chooseBlock(@"",key);
        }
        
    }else{
        sender.selected=YES;

        if (self.chooseBlock) {
            self.chooseBlock(value,key);
        }
        
    }
    
}



@end
