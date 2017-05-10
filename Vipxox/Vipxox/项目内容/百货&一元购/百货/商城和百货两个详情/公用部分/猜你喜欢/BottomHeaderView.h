//
//  BottomHeaderView.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bottomCollectionVView.h"

@interface BottomHeaderView : UITableViewHeaderFooterView<bottomCollectionVViewDelegate>

@property(nonatomic,strong)NSArray*allDatas;  //所有的数据
@property(nonatomic,strong)bottomCollectionVView*bottomVView;  //贴上的6个collectionCell 的图

@property(nonatomic,assign)id<bottomCollectionVViewDelegate>aa;  //用来接主控制器中的delegate
@end
