//
//  StateViewController.h
//  Vipxox
//
//  Created by Brady on 16/3/8.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StateViewControllerDelegate <NSObject>

-(void)delegateForBack1:(NSString*)str1;

@end
@interface StateViewController : UIViewController
@property(nonatomic,assign)id<StateViewControllerDelegate>delegate;
@end
