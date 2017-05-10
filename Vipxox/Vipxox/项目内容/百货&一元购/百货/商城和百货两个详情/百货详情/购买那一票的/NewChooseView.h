//
//  NewChooseView.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartmentDetailModel.h"


@protocol NewChooseViewDelegate <NSObject>

-(void)ShowViewDismiss;

@end

@interface NewChooseView : UIView
@property(nonatomic,weak)id<NewChooseViewDelegate>delegate;

@property(nonatomic,copy)void(^cancelBlock)();
@property(nonatomic,strong)NSArray*allDatas;

@property(nonatomic,strong)DepartmentDetailModel*bigMModel;   //大model


-(CGFloat)calculatarHeight;   //计算cell 的高度
@end
