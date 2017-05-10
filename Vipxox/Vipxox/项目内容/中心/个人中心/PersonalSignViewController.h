//
//  PersonalSignViewController.h
//  Vipxox
//
//  Created by Tian Wei You on 16/4/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalSignViewControllerDelegate <NSObject>

//-(void)delegateForBack1:(NSString*)str1;

@end

@interface PersonalSignViewController : UIViewController

@property(nonatomic,assign)id<PersonalSignViewControllerDelegate>delegate;

@end
