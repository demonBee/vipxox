//
//  TMAddressViewController.h
//  weimao
//
//  Created by Brady on 16/2/26.
//  Copyright © 2016年 Brady. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TMAddressViewControllerDelegate <NSObject>

-(void)DelegateForSendValueToAddress:(NSDictionary*)dict;    //给确认订单传数据

@end


@interface TMAddressViewController : UIViewController
@property(nonatomic,weak)id<TMAddressViewControllerDelegate>delegate;
@end
