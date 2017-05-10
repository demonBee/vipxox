//
//  EvaluationViewController.h
//  Vipxox
//
//  Created by Tian Wei You on 16/3/31.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EvaluationViewControllerDelegate <NSObject>

-(void)delegateForBack1:(NSString*)str1 andSection:(NSInteger)section;

@end

@interface EvaluationViewController : UIViewController

@property(nonatomic,strong)NSString *pidStr;
@property(nonatomic,strong)NSString *order_idStr;
@property(nonatomic,strong)NSString *attrStr;

@property(nonatomic,strong)NSString *idd;   //用于评价

@property(nonatomic,assign)NSInteger indexTag;

@property(nonatomic,assign)id<EvaluationViewControllerDelegate>delegate;

@end
