//
//  EditCommentViewController.h
//  shashou
//
//  Created by 黄佳峰 on 16/7/6.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditCommentViewControllerDelegate <NSObject>

-(void)delegateForCompleteCommitToReload;

@end

@interface EditCommentViewController : UIViewController
@property(nonatomic,copy)NSString*orderID;   //for  jiekou
@property(nonatomic,weak)id<EditCommentViewControllerDelegate>delegate;


@end
