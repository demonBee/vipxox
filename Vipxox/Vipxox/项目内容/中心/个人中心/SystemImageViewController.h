//
//  SystemImageViewController.h
//  Vipxox
//
//  Created by Tian Wei You on 16/4/6.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SystemImageViewControllerDelegate <NSObject>

-(void)delegateForBack4:(NSString*)str4;

@end

@interface SystemImageViewController : UIViewController

@property(nonatomic,assign)id<SystemImageViewControllerDelegate>delegate;

@end
