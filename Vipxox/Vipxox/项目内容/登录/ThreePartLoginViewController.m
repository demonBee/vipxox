//
//  ThreePartLoginViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/25.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ThreePartLoginViewController.h"
#import "ThreeRegisterViewController.h"
#import "ThreeAboutViewController.h"

@interface ThreePartLoginViewController ()

@property(nonatomic,strong)NSString*auser;
@end

@implementation ThreePartLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeButton];
    [self getValue];
   }

-(void)changeButton{
    UIView*view=[self.view viewWithTag:9];
    view.backgroundColor=ManColor;

    UIButton*leftButton=[[UIButton alloc]init];
    leftButton.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [leftButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    //快速注册
    UIButton*button3=[self.view viewWithTag:3];
    button3.layer.cornerRadius=6;
    button3.backgroundColor=ManColor;
    [button3 addTarget:self action:@selector(touchLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
    //立即关联
    UIButton*button4=[self.view viewWithTag:4];
    button4.layer.cornerRadius=6;
    button4.layer.borderColor=RGBCOLOR(193, 193, 193, 1).CGColor;
    button4.layer.borderWidth=1;
    [button4 addTarget:self action:@selector(touchAbout) forControlEvents:UIControlEventTouchUpInside];
  
}

-(void)touchLogin{
    //快速注册
    ThreeRegisterViewController*vc=[[ThreeRegisterViewController alloc]init];
    vc.params=self.params;
    vc.cid=self.cid;
    [self presentViewController:vc animated:YES completion:nil];
    
    
    
}

-(void)touchAbout{
    //立即关联
    ThreeAboutViewController*vc=[[ThreeAboutViewController alloc]init];
    vc.params=self.params;
    vc.cid=self.cid;
    [self presentViewController:vc animated:YES completion:nil];

}


-(void)getValue{
    //得到值
    UIImageView*imageView=[self.view viewWithTag:1];
    imageView.layer.cornerRadius=50;
    imageView.layer.masksToBounds=YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.aPhoto] placeholderImage:[UIImage imageNamed:@"placeholder_100x100"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            imageView.alpha=0.3;
            CGFloat scale = 0.3;
            imageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView.alpha=1;
                CGFloat scale = 1.0;
                imageView.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    
    if ([self.aplatformName isEqualToString:@"wxsession"]) {
        self.auser=@"微信";
    }else if ([self.aplatformName isEqualToString:@"qq"]){
        self.auser=@"QQ";
    }else if ([self.aplatformName isEqualToString:@"sina"]){
        self.auser=@"微博";
    }else if ([self.aplatformName isEqualToString:@"facebook"]){
        self.auser=@"faceBook";
    }
    
    UILabel*label2=[self.view viewWithTag:2];
    label2.text=[NSString stringWithFormat:@"亲爱的%@用户:%@",self.auser,self.aname];
    
}

-(void)touchBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
