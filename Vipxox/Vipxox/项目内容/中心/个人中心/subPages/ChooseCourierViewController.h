//
//  ChooseCourierViewController.h
//  Vipxox
//
//  Created by Tian Wei You on 16/3/30.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseCourierViewControllerDelegate <NSObject>

-(void)delegateForBack0:(NSString*)str0;

@end

@interface ChooseCourierViewController : UIViewController
@property(nonatomic,assign)id<ChooseCourierViewControllerDelegate>delegate;
@end
