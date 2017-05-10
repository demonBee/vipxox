//
//  ChooseTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "NewChooseTableViewCell.h"
#import "UIImage+imageColor.h"

@interface NewChooseTableViewCell()
@property(nonatomic,strong)NSMutableArray*saveAllButton;

@end

@implementation NewChooseTableViewCell





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        
    }
    return self;
}

-(void)setCanChoose:(NSDictionary *)canChoose{
    _canChoose=canChoose;
 NSLog(@"xxxx%@",_canChoose);
    
    NSString*str1=_dict.allKeys[0];
    NSString*str2=_canChoose.allKeys[0];
    
    if (![str1 isEqualToString:str2]) {
        
         NSLog(@"xxxx 顺序问题");
        
    }else{
       
  
    
    
    NSArray*array1=_dict.allValues[0];
    NSArray*array2=_canChoose.allValues[0];
    
        NSMutableArray*sameArray=[NSMutableArray array];   //相同的数组
    
    for (int i=0; i<array1.count; i++) {
        for (int j=0; j<array2.count; j++) {
            if ( [array1[i] isEqualToString:array2[j]]) {
                [sameArray addObject:array1[i]];
                
                
            }
           
            
        }
        
        
    }
    
     
        
        for (UIButton*button in self.saveAllButton) {
            NSString*buttonStr=button.titleLabel.text;
            if ([sameArray containsObject:buttonStr]) {
                button.enabled=YES;
            }else{
                button.enabled=NO;
            }
            
            
        }
        
        
        
        
}
    

}

-(void)setDict:(NSDictionary *)dict{
    _dict=dict;
//    {
//        "\U7c7b\U578b" =     (
//                              "\U8f6f\U7cd6",
//                              "\U679c\U6c41\U7cd6"
//                              );
//    }
    self.saveAllButton=[NSMutableArray array];
    
    
    UILabel*titleLabel=[self.contentView viewWithTag:1000];
    if (!titleLabel) {
        titleLabel=[[UILabel alloc]init];
        titleLabel.tag=1000;
        titleLabel.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:titleLabel];
    }
    
    NSString*str=[dict allKeys].firstObject;
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
    
    for (int i=0; i<[dict.allValues[0] count]; i++) {
        NSArray*name=dict.allValues[0];
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
        
        [self.saveAllButton addObject:button];

        
        
    }
    
    
    
    
}


-(void)touchButton:(UIButton*)sender{
    NSInteger number=sender.tag-2000;
   NSArray*name= self.dict.allValues[0];
    NSString*jieguo=nil;
    NSString*key=[self.dict allKeys].firstObject;
    
    
    NSMutableArray*tempSaveAllButton=[self.saveAllButton mutableCopy];
    
    [tempSaveAllButton removeObject:sender];
    

    for (UIButton*button in tempSaveAllButton) {
        button.selected=NO;
    }
    
    if (sender.selected) {
        sender.selected=NO;
        //这里代表这个str 的数据清空   空字符串
        jieguo=@"";
        if (self.chooseBlock) {
            self.chooseBlock(jieguo,key);
        }
        
    }else{
        sender.selected=YES;
         jieguo=name[number];
        if (self.chooseBlock) {
            self.chooseBlock(jieguo,key);
        }
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end




