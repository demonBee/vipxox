//
//  PhoneViewController.h
//  Vipxox
//
//  Created by Brady on 16/3/8.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhoneViewControllerDelegate <NSObject>

-(void)delegateForBack6:(NSString*)str6;

@end
@interface PhoneViewController : UIViewController
@property(nonatomic,assign)id<PhoneViewControllerDelegate>delegate;
@end
