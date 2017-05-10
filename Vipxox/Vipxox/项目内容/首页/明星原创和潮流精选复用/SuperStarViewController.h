//
//  SuperStarViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/14.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,categoryy){
    isMingxing=0,     //明星品牌
    ischaoliu,        //潮流
};
@interface SuperStarViewController : UIViewController
@property(nonatomic,assign)categoryy cate;
@end
