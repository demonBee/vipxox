//
//  NameViewController.h
//  Vipxox
//
//  Created by Brady on 16/3/8.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NameViewControllerDelegate <NSObject>

-(void)delegateForBack5:(NSString*)str5;

@end
@interface NameViewController : UIViewController
@property(nonatomic,assign)id<NameViewControllerDelegate>delegate;
@end
