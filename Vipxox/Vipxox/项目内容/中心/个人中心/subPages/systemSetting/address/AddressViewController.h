//
//  AddressViewController.h
//  Vipxox
//
//  Created by Brady on 16/3/8.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressViewControllerDelegate <NSObject>

-(void)delegateForBack4:(NSString*)str4;

@end
@interface AddressViewController : UIViewController
@property(nonatomic,assign)id<AddressViewControllerDelegate>delegate;
@end
