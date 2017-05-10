//
//  NewGoodDetailViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/26.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,whichCategory){
    oldCategory=0,
    newgeneral,
    
};



@interface NewGoodDetailViewController : UIViewController

//这两个是 创建的时候需要
@property(nonatomic,assign)whichCategory category;
@property(nonatomic,strong)NSDictionary*dictJiekou;

#pragma mark  ----- 应对旧商城的 选择尺寸和 选择项。  0为旧商城 1为新商城
+(instancetype)creatNewVCwith:(whichCategory)oldOrNew andDatas:(NSDictionary*)dict;


@end
