//
//  YoohuoViewController.h
//  weimao
//
//  Created by 黄佳峰 on 16/2/26.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,category){
    isMan=0,
    isGirl=1,
    isBabyBoy=2,
    isNorthAmerica=3,
//    isChinaSuperMarket=4
    
    
};

@protocol YoohuoViewControllerDelegate <NSObject>

-(void)DelegateForSectionOneCell:(NSArray*)array;   //委托給cell 代理   section1  里面的
-(void)DelegateForSectionTwoCell:(NSArray*)array;   //委托給cell 代理   section2 里面的
-(void)DelegateForSectionThreeCell:(NSArray*)array;   //委托給cell 代理   section3 里面的

-(void)DelegateCollectionToReload;  //委托 section4 reload；

@end

@interface YoohuoViewController : UIViewController
@property(nonatomic,weak)id<YoohuoViewControllerDelegate>delegate;

@property(nonatomic,assign)category cate;


@property(nonatomic,assign)int xcolor;   //颜色 0黑色man    1红色yoohoo   2蓝色男孩   3北美

@end
