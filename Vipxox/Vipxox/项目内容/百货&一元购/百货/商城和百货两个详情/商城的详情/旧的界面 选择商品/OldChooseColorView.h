//
//  OldChooseColorView.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/3.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BUYORADD){
    immedateBuy=0,
    addToshoppingCar
};

//点击确定购买 代理回主视图 处理
@protocol OldChooseColorViewDelegate <NSObject>

-(void)DelegateBuy:(BUYORADD)immedateBuy andChooseDict:(NSMutableDictionary*)mtdict andHowMuchChoose:(NSUInteger)alldata_count andgoodsHowMuch:(NSString*)much;

@end


@interface OldChooseColorView : UIView

@property(nonatomic,copy)void(^cancelBlock)();
@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSDictionary*allDict;  //这件商品所有数据
@property(nonatomic,strong)NSArray*allDatas;   //数组 分发给cell 的
@property(nonatomic,assign)BUYORADD buyImmedatelyOrAddToCar;  //立即购买  还是加入购物车


@property(nonatomic,assign)id<OldChooseColorViewDelegate>delegate;


-(CGFloat)getViewHeight;   //计算cell 的高度

@end
