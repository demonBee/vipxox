//
//  CategoryViewController.m
//  weimao
//
//  Created by 黄佳峰 on 16/2/26.
//  Copyright © 2016年 黄佳峰. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategroyTableViewCell.h"
#import "CaregroyTwoTableViewCell.h"
//#import "XXNavigationController.h"

#define  Categroy      @"CategroyTableViewCell"
#define  CategroyTwo   @"CaregroyTwoTableViewCell"

@interface CategoryViewController ()<UITableViewDataSource,UITableViewDelegate,ChinaSuperMarketViewControllerDelegate>
@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)UIView*mainView;

@property(nonatomic,strong) UIView*topView;

@property(nonatomic,strong)NSArray*whiteImageArray;   //白色的图片
@end


@implementation CategoryViewController

-(ChinaSuperMarketViewController *)ChinaSM{
    if (!_ChinaSM) {
        _ChinaSM=[[ChinaSuperMarketViewController alloc]init];
       _ChinaSM.xcolor =self.xcolor;
        _ChinaSM.isSuperMark=YES;
        _ChinaSM.view.frame=CGRectMake(KScreenWidth, 0, 0, KScreenHeight);
        _ChinaSM.delegate=self;
        
    }
    return _ChinaSM;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(KScreenWidth-ACTUAL_WIDTH(250), 0, ACTUAL_WIDTH(250), KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
       
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeWhenTap) name:@"removeCategory" object:nil];


    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CategroyTableViewCell class] forCellReuseIdentifier:Categroy];
    [self.tableView registerClass:[CaregroyTwoTableViewCell class] forCellReuseIdentifier:CategroyTwo];
    
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self getAllDatas];
    
    
//    self.mainView=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth, 0, 0, KScreenHeight)];
//    self.mainView.backgroundColor=[UIColor redColor];
//    [self.view addSubview:self.mainView];
    
    
       //那条 粉红色
    _topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ACTUAL_WIDTH(250), ACTUAL_HEIGHT(20))];
#warning 颜色
//    _topView.backgroundColor=ManColor;
    [self.tableView addSubview:_topView];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    [self getColor];
}
-(void)getColor{
#warning 颜色
    if (_xcolor==0) {
//        [self.navigationController.navigationBar setBarTintColor:ManColor];
        _topView.backgroundColor=ManColor;
        
    }else if (_xcolor==1){
//        [self.navigationController.navigationBar setBarTintColor:YooPink];
        _topView.backgroundColor=YooPink;
        
    }else if (_xcolor==2){
//        [self.navigationController.navigationBar setBarTintColor:BoyColor];
        _topView.backgroundColor=BoyColor;
        
    }else if (_xcolor==3){
        _topView.backgroundColor=NorthAmercia;
    }

}

-(void)getAllDatas{
    NSDictionary*dic0=@{@"image":@"boy-0",@"labelMain":@"男生",@"labelSmall":@"BOYS"};
    NSDictionary*dic1=@{@"image":@"girl-0",@"labelMain":@"女生",@"labelSmall":@"GIRLS"};
     NSDictionary*dic2=@{@"image":@"kid-0",@"labelMain":@"潮童",@"labelSmall":@"KIDS"};
     NSDictionary*dic3=@{@"image":@"life style-0",@"labelMain":@"北美生活",@"labelSmall":@"LIFE STYLE"};
     NSDictionary*dic4=@{@"image":@"sale-0",@"labelMain":@"华人超市",@"labelSmall":@"GROCERIES"};
    NSArray*arr0=@[dic0,dic1,dic2,dic3,dic4];
    
    NSDictionary*dicc0=@{@"image":@"plus-0",@"labelMain":@"折扣专区",@"labelSmall":@"SALE"};
    NSDictionary*dicc1=@{@"image":@"star-0",@"labelMain":@"明星原创",@"labelSmall":@"STAR"};
    NSDictionary*dicc2=@{@"image":@"globle shop-0",@"labelMain":@"全球包邮",@"labelSmall":@"FREESHIPPING"};
    NSDictionary*dicc3=@{@"image":@"trendfinder-0",@"labelMain":@"逛街",@"labelSmall":@"FINDEVERYTHING"};
    NSArray*arr1=@[dicc0,dicc1,dicc2,dicc3];

    self.allDatas=@[arr0,arr1];
    
    
    NSDictionary*dicw0=@{@"image":@"Wboy-0",@"labelMain":@"男生",@"labelSmall":@"BOYS"};
    NSDictionary*dicw1=@{@"image":@"Wgirl-0",@"labelMain":@"女生",@"labelSmall":@"GIRLS"};
    NSDictionary*dicw2=@{@"image":@"Wkid-0",@"labelMain":@"潮童",@"labelSmall":@"KIDS"};
    NSDictionary*dicw3=@{@"image":@"Wlife style-0",@"labelMain":@"北美生活",@"labelSmall":@"LIFE STYLE"};
    NSDictionary*dicw4=@{@"image":@"Wsale-0",@"labelMain":@"华人超市",@"labelSmall":@"GROCERIES"};
    NSArray*arrw0=@[dicw0,dicw1,dicw2,dicw3,dicw4];
    
    NSDictionary*diccw0=@{@"image":@"Wplus-0",@"labelMain":@"折扣专区",@"labelSmall":@"SALE"};
    NSDictionary*diccw1=@{@"image":@"Wstar-0",@"labelMain":@"明星原创",@"labelSmall":@"STAR"};
    NSDictionary*diccw2=@{@"image":@"Wgloble shop-0",@"labelMain":@"全球包邮",@"labelSmall":@"FREESHIPPING"};
    NSDictionary*diccw3=@{@"image":@"Wtrendfinder-0",@"labelMain":@"逛街",@"labelSmall":@"FINDEVERYTHING"};
    NSArray*arrw1=@[diccw0,diccw1,diccw2,diccw3];

    self.whiteImageArray=@[arrw0,arrw1];

    
}

#pragma mark----delegate
-(void)dismissThisVC{
    [UIView animateWithDuration:.5 animations:^{
//        [self.ChinaSM.view setY:KScreenHeight];
        
        CGRect rect= CGRectMake(ACTUAL_WIDTH(375), 0, 0, KScreenHeight);
        CGRect table=CGRectMake(0, ACTUAL_HEIGHT(64), 0, KScreenHeight);
        CGRect button=CGRectMake(ACTUAL_WIDTH(19),ACTUAL_HEIGHT(31), 0, ACTUAL_HEIGHT(24));
        CGRect naviView=CGRectMake(0, 0, 0, ACTUAL_HEIGHT(64));
        
        CGRect spimage=CGRectMake(0,ACTUAL_HEIGHT(24), 0, ACTUAL_HEIGHT(40));
        
        self.ChinaSM.view.frame=rect;
        self.ChinaSM.tableView.frame=table;
//        self.ChinaSM.backButton.frame=button;
        self.ChinaSM.topView.frame=naviView;
        self.ChinaSM.spImageView.frame=spimage;
        
        
        
    }];
    [NSTimer scheduledTimerWithTimeInterval:.7 target:self selector:@selector(removeVC:) userInfo:nil repeats:NO];
}
-(void)removeVC:(NSTimer*)timer{
    [self.ChinaSM.view removeFromSuperview];
    [self.ChinaSM removeFromParentViewController];
    self.ChinaSM=nil;
    [timer invalidate];
    timer = nil;
}

-(void)removeWhenTap{
    [self dismissThisVC];
}

#pragma mark  ----  tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }else{
        return 4;
    }
  
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
      
    }
 
    
       if (indexPath.section==0) {
           CategroyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:Categroy];

//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
           cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
           cell.selectedBackgroundView.backgroundColor=[UIColor blackColor];
             cell.labelMain.font=[UIFont fontWithName:@"Helvetica-Bold" size:19];
//             cell.labelSmall.font=[UIFont fontWithName:@"PingFang SC" size:10];
                cell.labelSmall.font=[UIFont boldSystemFontOfSize:10];

        cell.imageBig.image=[UIImage imageNamed:self.allDatas[indexPath.section][indexPath.row][@"image"]];
           cell.imageBig.highlightedImage=[UIImage imageNamed:self.whiteImageArray[indexPath.section][indexPath.row][@"image"]];
           
        cell.labelMain.text=self.allDatas[indexPath.section][indexPath.row][@"labelMain"];
           
           cell.labelMain.highlightedTextColor=[UIColor whiteColor];
      
        cell.labelSmall.text=self.allDatas[indexPath.section][indexPath.row][@"labelSmall"];
           cell.labelSmall.highlightedTextColor=[UIColor whiteColor];
           
           if (indexPath.row==4) {
               UIImageView*imageV=[cell viewWithTag:11];
               imageV.backgroundColor=[UIColor whiteColor];
               imageV.contentMode=UIViewContentModeScaleAspectFit;
               if (!imageV) {
                   imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_Back"]];
                   imageV.frame=CGRectMake(ACTUAL_WIDTH(222), ACTUAL_HEIGHT(22), ACTUAL_WIDTH(12), ACTUAL_HEIGHT(21));
                   imageV.tag=11;
//                   imageV.backgroundColor=[UIColor redColor];
                   imageV.image=[UIImage imageNamed:@"ringArr"];
                   imageV.highlightedImage=[UIImage imageNamed:@"wringArr"];
                   imageV.backgroundColor=[UIColor whiteColor];
                   imageV.contentMode=UIViewContentModeScaleAspectFit;

                   [cell.contentView addSubview:imageV];
                  
               }
           }
           
//           cell.selectionStyle
        return cell;

    }else{
        CaregroyTwoTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CategroyTwo];
        
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor=[UIColor blackColor];

        cell.labelTitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
//        cell.labelDetail.font=[UIFont fontWithName:@"PingFang SC" size:10];
        cell.labelDetail.font=[UIFont boldSystemFontOfSize:10];

        cell.imageBig.image=[UIImage imageNamed:self.allDatas[indexPath.section][indexPath.row][@"image"]];
        cell.imageBig.highlightedImage=[UIImage imageNamed:self.whiteImageArray[indexPath.section][indexPath.row][@"image"]];
        cell.labelTitle.text=self.allDatas[indexPath.section][indexPath.row][@"labelMain"];
        cell.labelTitle.highlightedTextColor=[UIColor whiteColor];
        cell.labelDetail.text=self.allDatas[indexPath.section][indexPath.row][@"labelSmall"];
        cell.labelDetail.highlightedTextColor=[UIColor whiteColor];
        if (indexPath.row==1) {
            cell.imageBig.frame=CGRectMake(ACTUAL_WIDTH(10),ACTUAL_HEIGHT(10),ACTUAL_WIDTH(30), ACTUAL_HEIGHT(30));
            cell.imageBig.image=[UIImage imageNamed:@"home_Star1"];
        }
        
        if (indexPath.row==3) {
            UIImageView*imageV=[cell viewWithTag:66];
            if (!imageV) {
                imageV=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_Back"]];
                imageV.frame=CGRectMake(ACTUAL_WIDTH(222), ACTUAL_HEIGHT(15), ACTUAL_WIDTH(12), ACTUAL_HEIGHT(21));
                imageV.tag=66;
//                imageV.backgroundColor=[UIColor redColor];
                imageV.backgroundColor=[UIColor whiteColor];
                imageV.contentMode=UIViewContentModeScaleAspectFit;

                imageV.image=[UIImage imageNamed:@"ringArr"];
                imageV.highlightedImage=[UIImage imageNamed:@"wringArr"];

                [cell.contentView addSubview:imageV];
                
            }
        }
        
        return cell;
    }
   }



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==4) {
[self.view addSubview:self.ChinaSM.view];
[[NSNotificationCenter defaultCenter]postNotificationName:@"isSuperMarket" object:nil];
[UIView animateWithDuration:.5 animations:^{
               CGRect rect= CGRectMake(ACTUAL_WIDTH(125), 0, ACTUAL_WIDTH(250), KScreenHeight);
               CGRect table=CGRectMake(0, ACTUAL_HEIGHT(64), ACTUAL_WIDTH(250), KScreenHeight);
//               CGRect button=CGRectMake(ACTUAL_WIDTH(0),ACTUAL_HEIGHT(31), ACTUAL_WIDTH(170), ACTUAL_HEIGHT(24));
               CGRect naviView=CGRectMake(0, 0, ACTUAL_WIDTH(250), ACTUAL_HEIGHT(64));
               CGRect spimage=CGRectMake(0,ACTUAL_HEIGHT(24), ACTUAL_WIDTH(250), ACTUAL_HEIGHT(40));
         
                self.ChinaSM.view.frame=rect;
               self.ChinaSM.tableView.frame=table;
//               self.ChinaSM.backButton.frame=button;
               self.ChinaSM.topView.frame=naviView;
               self.ChinaSM.spImageView.frame=spimage;
        }];

        NSLog(@"%ld,%ld",(long)indexPath.section,(long)indexPath.row);

#warning ------------------------------------
       
        
        
    }else if (indexPath.section==1&&indexPath.row==3){
            [self.view addSubview:self.ChinaSM.view];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"isntSuperMarket" object:nil];
    

        CGRect rect= CGRectMake(ACTUAL_WIDTH(125), 0, ACTUAL_WIDTH(250), KScreenHeight);
        CGRect table=CGRectMake(0, ACTUAL_HEIGHT(64), ACTUAL_WIDTH(250), KScreenHeight);
        CGRect button=CGRectMake(ACTUAL_WIDTH(19),ACTUAL_HEIGHT(31), ACTUAL_WIDTH(170), ACTUAL_HEIGHT(24));
        CGRect naviView=CGRectMake(0, 0, ACTUAL_WIDTH(250), ACTUAL_HEIGHT(64));
        CGRect spimage=CGRectMake(0,ACTUAL_HEIGHT(24), ACTUAL_WIDTH(250), ACTUAL_HEIGHT(40));

  

        [UIView animateWithDuration:0.5 animations:^{
//            CGRect rect= CGRectMake(0, 0, KScreenWidth, KScreenHeight);
            self.ChinaSM.view.frame=rect;
            self.ChinaSM.tableView.frame=table;
//            self.ChinaSM.backButton.frame=button;
            self.ChinaSM.topView.frame=naviView;
            self.ChinaSM.spImageView.frame=spimage;
        
        }];

        
    }else{
        if ([self.delegate respondsToSelector:@selector(touchCategory:)]) {
            [self.delegate touchCategory:indexPath];
        }

        
    }
    
  
    
        


    
    
        
        
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return ACTUAL_HEIGHT(65);

    }else{
        return ACTUAL_HEIGHT(50);
    }
   }

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return ACTUAL_HEIGHT(45);
    }else{
        return ACTUAL_HEIGHT(10);
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(10))];
        
        view.backgroundColor=RGBCOLOR(236, 236, 236, 1);
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
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
