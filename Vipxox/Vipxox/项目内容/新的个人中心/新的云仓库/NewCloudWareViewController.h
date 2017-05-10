//
//  NewCloudWareViewController.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/8/4.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,threeCategory){
    canSelectd=0,
    cantSeleced
    
};

@interface NewCloudWareViewController : UIViewController
@property(nonatomic,assign)threeCategory category;

@end
