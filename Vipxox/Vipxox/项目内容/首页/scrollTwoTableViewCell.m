//
//  scrollTwoTableViewCell.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/2/29.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "scrollTwoTableViewCell.h"
#import "UIButton+WebCache.h"


@implementation scrollTwoTableViewCell

- (void)awakeFromNib {
    self.saveAllButtons=[NSMutableArray array];
//    self.allDatas=[NSArray array];

    
    UIScrollView*scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(34), KScreenWidth, ACTUAL_HEIGHT(321))];
//    scroll.backgroundColor=[UIColor greenColor];
    scroll.contentSize=CGSizeMake(KScreenWidth*2, ACTUAL_HEIGHT(34));
    scroll.pagingEnabled=YES;
    scroll.bounces=NO;
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.delegate=self;
    self.scroll=scroll;
    [self.contentView addSubview:scroll];
    
    CGFloat with=KScreenWidth/4;
    CGFloat height=ACTUAL_HEIGHT(100);
  
  
    
    for (int i=0; i<24; i++) {
        if (i<12) {
            int hang =i%4;
            int lie=i/4;
            UIButton*button=[UIButton buttonWithType:0];
            button.frame=CGRectMake(with*hang, height*lie, with, height);
//            button.backgroundColor=[UIColor yellowColor];
            [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            [self.saveAllButtons addObject:button];
            [scroll addSubview:button];

        }else{
            int hang =(i-12)%4;
            int lie=(i-12)/4;
            UIButton*button=[UIButton buttonWithType:0];
            button.frame=CGRectMake(KScreenWidth+with*hang, height*lie, with, height);
//            button.backgroundColor=[UIColor blueColor];
            [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            [self.saveAllButtons addObject:button];
            [scroll addSubview:button];

            
        }
       
     
        
    }
    
    
    [self addline];
    [self addOtherline];
    [self addPageControl];
}

-(void)addPageControl{
    UIPageControl*pagecontrol=[[UIPageControl alloc]initWithFrame:CGRectMake(KScreenWidth/2-ACTUAL_WIDTH(15), ACTUAL_HEIGHT(345), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(8))];
//    pagecontrol.backgroundColor=[UIColor redColor];
    pagecontrol.numberOfPages=2;
    pagecontrol.currentPage=0;
    pagecontrol.currentPageIndicatorTintColor=[UIColor grayColor];
    pagecontrol.pageIndicatorTintColor=RGBCOLOR(230, 231, 233, 1);
    self.pageControl=pagecontrol;
//    [pagecontrol mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.contentView.centerX).offset(0);
//      
//    }];
    NSLog(@"%@",NSStringFromCGRect(pagecontrol.frame));
    [self.contentView addSubview:pagecontrol];
    
    
}

-(void)addOtherline{
    UIView*hengline1=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, 1)];
    hengline1.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:hengline1];
    
    
    UIView*hengline2=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth, ACTUAL_HEIGHT(100), KScreenWidth, 1)];
    hengline2.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:hengline2];
    
    UIView*hengline3=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth, ACTUAL_HEIGHT(200), KScreenWidth, 1)];
    hengline3.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:hengline3];
    
    UIView*hengline4=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth, ACTUAL_HEIGHT(300), KScreenWidth, 1)];
    hengline4.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:hengline4];
    
    
    UIView*shuline1=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth+KScreenWidth/4, 0, 1, ACTUAL_HEIGHT(300))];
    shuline1.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:shuline1];
    
    UIView*shuline2=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth+KScreenWidth/4*2, 0, 1, ACTUAL_HEIGHT(300))];
    shuline2.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:shuline2];
    
    UIView*shuline3=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth+KScreenWidth/4*3, 0, 1, ACTUAL_HEIGHT(300))];
    shuline3.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:shuline3];

}

-(void)addline{
    UIView*hengline1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    hengline1.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:hengline1];
    
    
    UIView*hengline2=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(100), KScreenWidth, 1)];
    hengline2.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:hengline2];
    
    UIView*hengline3=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(200), KScreenWidth, 1)];
    hengline3.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:hengline3];
    
    UIView*hengline4=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(300), KScreenWidth, 1)];
    hengline4.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:hengline4];
    
    
    UIView*shuline1=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/4, 0, 1, ACTUAL_HEIGHT(300))];
    shuline1.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:shuline1];
    
    UIView*shuline2=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/4*2, 0, 1, ACTUAL_HEIGHT(300))];
    shuline2.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:shuline2];
    
    UIView*shuline3=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/4*3, 0, 1, ACTUAL_HEIGHT(300))];
    shuline3.backgroundColor=RGBCOLOR(223, 223, 223, 1);
    [_scroll addSubview:shuline3];
    

    
    //
    
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/ KScreenWidth;
    //NSLog(@"%d",index);
    [_pageControl setCurrentPage:index];
}
-(void)touchButton:(UIButton*)sender{
    NSLog(@"%ld",(long)sender.tag);
    if ([self.delegate respondsToSelector:@selector(touchSectionZero:)]) {
        [self.delegate touchSectionZero:sender];
    }
    
    
}

-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;
    
    self.pageControl.frame= CGRectMake(KScreenWidth/2-ACTUAL_WIDTH(15), ACTUAL_HEIGHT(345), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(8));
    NSLog(@"%@",self.allDatas);
    NSMutableArray*array=[NSMutableArray array];  //保存所有图片
    for (int i=0; i<[self.allDatas[0] count]; i++) {
        [array addObject:self.allDatas[0][i][@"pic"] ];
    }
    
    for (int i=0; i<array.count; i++) {
        UIButton*button=self.saveAllButtons[i];

        


        [button sd_setImageWithURL:[NSURL URLWithString:array[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_94x100"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (cacheType!=2) {
                button.alpha=0.3;
                CGFloat scale = 0.3;
                button.transform = CGAffineTransformMakeScale(scale, scale);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    button.alpha=1;
                    CGFloat scale = 1.0;
                    button.transform = CGAffineTransformMakeScale(scale, scale);
                }];

            }
            
            
        }];




        
        
    }

    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
