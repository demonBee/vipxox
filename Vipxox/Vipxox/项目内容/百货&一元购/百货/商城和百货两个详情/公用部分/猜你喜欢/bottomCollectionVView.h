//
//  bottomCollectionVView.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol bottomCollectionVViewDelegate <NSObject>

//点击事件代理给主控制器
-(void)delegateFromCollectionTouch:(NSInteger)viewTag andIndexPath:(NSIndexPath*)indexPath andthisRowDict:(NSDictionary*)dict;

@end

@interface bottomCollectionVView : UIView

@property(nonatomic,strong)NSArray*allDatas;
@property(nonatomic,assign)id<bottomCollectionVViewDelegate>delegate;  //
@end
