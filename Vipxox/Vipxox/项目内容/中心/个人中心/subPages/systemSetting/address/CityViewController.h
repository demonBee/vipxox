//
//  CityViewController.h
//  Vipxox
//
//  Created by Brady on 16/3/8.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityViewControllerDelegate <NSObject>

-(void)delegateForBack2:(NSString*)str2;

@end
@interface CityViewController : UIViewController
@property(nonatomic,assign)id<CityViewControllerDelegate>delegate;
@end
