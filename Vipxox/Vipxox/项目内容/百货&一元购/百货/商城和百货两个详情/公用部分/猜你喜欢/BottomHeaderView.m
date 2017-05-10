//
//  BottomHeaderView.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "BottomHeaderView.h"


@interface BottomHeaderView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView*scrollView;
@property(nonatomic,strong)NSMutableArray*sixArray;   //拆分好的数组 6个数组

@end
@implementation BottomHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect rect=self.contentView.frame;
        [self makeLabel];
        CGFloat with =(KScreenWidth-50)/3;
        CGFloat height =170-with+ACTUAL_HEIGHT(with);
        self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, KScreenWidth, height+8+height+8+20)];
        self.scrollView.delegate=self;
        self.scrollView.contentSize=CGSizeMake(KScreenWidth*4, 0);
        self.scrollView.backgroundColor=[UIColor whiteColor];
        self.scrollView.pagingEnabled=YES;
        self.scrollView.bounces=NO;
        [self.contentView addSubview:self.scrollView];
        
        
    }
    return self;
}

-(void)makeLabel{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(14, 14, KScreenWidth/2, 18)];
    label.text=@"大家都在买";
    label.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:label];
    
    
}

-(void)setAllDatas:(NSArray *)allDatas{
    _allDatas=allDatas;
    NSInteger number=0;
    
    NSInteger shang=allDatas.count/6;
    NSInteger yu=allDatas.count%6;
    
    if (yu!=0) {
        number=shang+1;
    }else{
        number=shang;
    }
    
    
    //总的数据分装
    for (int i=0; i<number; i++) {
      
        NSMutableArray*array=[NSMutableArray array];
        
        if (i<number-1) {
            for (int j=0; j<6; j++) {
                [array addObject:allDatas[i*6+j]];
            }
            [self.sixArray addObject:array];
            
        }else{
            //最后一个数
            for (NSInteger k=((number-1)*6); k<allDatas.count; k++) {
                
                [array addObject:allDatas[k]];
                
            }
            [self.sixArray addObject:array];

            
        }
        
        
    }
    
    
    NSLog(@"%@",self.sixArray);
    
    //数据分发给  各个view
    self.scrollView.contentSize=CGSizeMake(KScreenWidth*number, 0);
    
    for (int i=0; i<number; i++) {
        bottomCollectionVView*view=[self viewWithTag:1000+i];
        if (!view) {
            view=[[bottomCollectionVView alloc]initWithFrame:CGRectMake(KScreenWidth*i, 0, self.scrollView.width, self.scrollView.height)];
            view.tag=1000+i;
            [self.scrollView addSubview:view];

        }
        self.bottomVView=view;
        self.bottomVView.delegate=self.aa;
          view.allDatas=self.sixArray[i];
        
        
    }
    
    
    
}


-(NSMutableArray *)sixArray{
    if (!_sixArray) {
        _sixArray=[NSMutableArray array];
    }
    return _sixArray;
}


@end
