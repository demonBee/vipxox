//
//  ChaoliuDapeiViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/28.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ChaoliuDapeiViewController.h"
#import "ChaoliuDapeoTableViewCell.h"
#import "UIButton+WebCache.h"
//#import "GoodsTailsViewController.h"    //商品详情
#import "NewGoodDetailViewController.h"


#define ChaoliuDapeoCell   @"ChaoliuDapeoTableViewCell"
@interface ChaoliuDapeiViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ChaoliuDapeoTableViewCellDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong) UIView*viewImage;    //没什么用

@property(nonatomic,strong)UIView*bottomView;  //frame一直变的view

@property(nonatomic,strong)NSDictionary*allDatas;   //所有的数据
@property(nonatomic,strong)NSArray*allCollectionViewDatas;   //保存了所有collectionView 里面的item
@property(nonatomic,strong)NSMutableArray*allButtons;   //保存了所有的按钮


@end

@implementation ChaoliuDapeiViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
//        _tableView.tableHeaderView=[self getHeaderView];
//        _tableView.tableHeaderView.height=self.viewImage.bottom;
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allCollectionViewDatas=[NSArray array];
    [self getDatas];
    [self.tableView registerClass:[ChaoliuDapeoTableViewCell class] forCellReuseIdentifier:ChaoliuDapeoCell];
    [self.view addSubview:self.tableView];

//    [self addView];
    
    
}
-(void)getDatas{
//    	http://www.vipxox.cn/? m=appapi&s=home_page&act=get_star_dp&id＝3
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"get_star_dp",@"id":self.dict[@"id"]};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"errorCode"] isEqualToString:@"0"]) {
            self.allDatas=data[@"data"];
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
    }];
  
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    
    if (indexPath.section==1) {
       ChaoliuDapeoTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:ChaoliuDapeoCell];
        cell.selectionStyle=NO;
        self.delegate=cell;
        cell.delegate=self;
        if ([self.allDatas[@"clist"] count]!=0) {
            NSArray*collectionValue=self.allDatas[@"clist"][0][@"prolist"];
            self.allCollectionViewDatas=collectionValue;
            if ([self.delegate respondsToSelector:@selector(DelegateForCellSendDatas:)]) {
                [self.delegate DelegateForCellSendDatas:self.allCollectionViewDatas];
            }
            return cell;
        }else{
              return cell;
        }
     
        
    }
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        
        return [self getHeaderView];
          }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
//        NSLog(@"%f",_viewImage.bottom);
//        return 1000;
        UIView*view=[self getHeaderView];
        return view.height;
    }else{
        return 0.001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 0.001;
    }else{
        
//        NSArray*array=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
//        NSInteger section=(array.count+1)/2;
        NSInteger section=(self.allCollectionViewDatas.count+1)/2;
        return ACTUAL_HEIGHT(15)+ACTUAL_HEIGHT(290)*section;
        
    }
}

-(UIView*)getHeaderView{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, ACTUAL_HEIGHT(585))];
    mainView.backgroundColor=[UIColor whiteColor];
//    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(_viewImage.bottom);
//        
//        
//    }];
    
    //
    UIImageView*imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(15), ACTUAL_HEIGHT(10), ACTUAL_WIDTH(30), ACTUAL_HEIGHT(30))];
    imageView1.layer.cornerRadius=15;
    imageView1.layer.masksToBounds=YES;
    imageView1.backgroundColor=[UIColor whiteColor];
    imageView1.contentMode=UIViewContentModeScaleAspectFit;


    [imageView1 sd_setImageWithURL:[NSURL URLWithString:self.allDatas[@"logo"]] placeholderImage:[UIImage imageNamed:@"placeholder_30x30"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            imageView1.alpha=0.3;
            CGFloat scale = 0.3;
            imageView1.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                imageView1.alpha=1;
                CGFloat scale = 1.0;
                imageView1.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    [mainView addSubview:imageView1];
    
    UILabel*label1=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(65), ACTUAL_HEIGHT(22), ACTUAL_WIDTH(210), ACTUAL_HEIGHT(15))];
//    label1.text=@"LEO_LIU";
    label1.text=[NSString stringWithFormat:@"%@",self.allDatas[@"user"]];
    label1.centerY=imageView1.centerY;
    label1.font=[UIFont systemFontOfSize:14];
    [mainView addSubview:label1];
    
    UIView*lineView=[[UIView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(56), KScreenWidth, ACTUAL_HEIGHT(1))];
    lineView.backgroundColor=RGBCOLOR(217, 217, 217, 1);
    [mainView addSubview:lineView];
    
    //
    TFLabel*labelTitle=[[TFLabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(15), lineView.bottom+ACTUAL_HEIGHT(14), KScreenWidth-ACTUAL_WIDTH(15), ACTUAL_HEIGHT(100))];
//    labelTitle.text=@"双方交流时佳峰拉开距离是否了解历史佳峰了解失联飞机老是放假了失联飞机了双方ssfsfslkfjskfjslfjslkjfslfjslfjslkfjlskjf";
    labelTitle.text=self.allDatas[@"title"];
    labelTitle.textColor=[UIColor blackColor];
    labelTitle.font=[UIFont systemFontOfSize:17];
    labelTitle.numberOfLines=0;
    [mainView addSubview:labelTitle];
    

    
    //时间那一栏
    UIImageView*imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(17), labelTitle.bottom+ACTUAL_HEIGHT(8), 15, 15)];
//    imageView2.backgroundColor=[UIColor yellowColor];
    imageView2.image=[UIImage imageNamed:@"chaoliushijian"];
    imageView2.backgroundColor=[UIColor whiteColor];
    imageView2.contentMode=UIViewContentModeScaleAspectFit;

    [mainView addSubview:imageView2];
//    imageView2.layer.cornerRadius=7.5;
//    imageView2.layer.masksToBounds=YES;

    
    TFLabel*label2=[[TFLabel alloc]initWithFrame:CGRectMake(imageView2.right+ACTUAL_WIDTH(5), labelTitle.bottom+ACTUAL_HEIGHT(8), 300, 15)];
    label2.centerY=imageView2.centerY;
    label2.font=[UIFont systemFontOfSize:12];
//    label2.text=@"3月27日 22:00";
    label2.text=self.allDatas[@"create_time"];
    label2.textColor=RGBCOLOR(164, 164, 164, 1);
    [mainView addSubview:label2];

    
    UIImageView*imageView3=[[UIImageView alloc]initWithFrame:CGRectMake(label2.right+ACTUAL_WIDTH(18), labelTitle.bottom+ACTUAL_HEIGHT(8), 20, 15)];
//    imageView3.backgroundColor=[UIColor yellowColor];
    imageView3.image=[UIImage imageNamed:@"chaoliuyanjin"];
    imageView3.backgroundColor=[UIColor whiteColor];
    imageView3.contentMode=UIViewContentModeScaleAspectFit;

    [mainView addSubview:imageView3];
//    imageView3.layer.cornerRadius=7.5;
//    imageView3.layer.masksToBounds=YES;

    
    UILabel*label3=[[UILabel alloc]initWithFrame:CGRectMake(imageView3.right+ACTUAL_WIDTH(6), labelTitle.bottom+ACTUAL_HEIGHT(8), 1000, 15)];
    label3.font=[UIFont systemFontOfSize:12];
//    label3.text=@"23205";
    label3.text=self.allDatas[@"praise"];
    label3.textColor=RGBCOLOR(164, 164, 164, 1);
    [mainView addSubview:label3];
    
    
    //最大的 imageView
    UIImageView*largeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, label3.bottom+ACTUAL_HEIGHT(18), KScreenWidth, ACTUAL_HEIGHT(375))];
//    largeImageView.backgroundColor=[UIColor yellowColor];
    largeImageView.backgroundColor=[UIColor whiteColor];
    largeImageView.contentMode=UIViewContentModeScaleAspectFit;

    [largeImageView sd_setImageWithURL:[NSURL URLWithString:self.allDatas[@"bigpic"]] placeholderImage:[UIImage imageNamed:@"placeholder_375x375"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            largeImageView.alpha=0.3;
            CGFloat scale = 0.3;
            largeImageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                largeImageView.alpha=1;
                CGFloat scale = 1.0;
                largeImageView.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];
    [mainView addSubview:largeImageView];
    
    
    //最长的废话
    TFLabel*longLabel=[[TFLabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(20), largeImageView.bottom+ACTUAL_HEIGHT(20), KScreenWidth-ACTUAL_WIDTH(40), 1000)];
    longLabel.numberOfLines=0;
    longLabel.font=[UIFont systemFontOfSize:14];
//    longLabel.text=@"双方建立双方就两手空房间里是否能上飞机失联事件弗拉索夫就流口水佳峰老师说弗雷斯科佳峰流口水佳峰了数据来看上的飞机来上课佳峰了手机铃声";
    longLabel.text=self.allDatas[@"description"];
    [mainView addSubview:longLabel];
//    [longLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(mainView.mas_left).offset(20);
//        make.right.mas_equalTo(mainView.mas_right).offset(-20);
//        make.top.mas_equalTo(largeImageView.mas_bottom).offset(20);
    
        
        
        //那个图片view  其实 没什么软用的
        _viewImage=[[UIView alloc]initWithFrame:CGRectMake(0, longLabel.bottom+ACTUAL_HEIGHT(16), KScreenWidth, ACTUAL_HEIGHT(120))];
//        _viewImage.backgroundColor=[UIColor greenColor];
        [mainView addSubview:_viewImage];
//        [_viewImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(mainView.left);
//            make.right.mas_equalTo(mainView.right);
//            make.top.mas_equalTo(longLabel.mas_bottom).offset(16);
//            make.height.mas_equalTo(ACTUAL_HEIGHT(120));
//            NSLog(@"%@",NSStringFromCGRect(_viewImage.frame));

            
//        }];
//        NSLog(@"%@",NSStringFromCGRect(_viewImage.frame));
//        NSLog(@"%f",_viewImage.bottom);
    
    self.allButtons=[NSMutableArray array];
        NSArray*arrayImage=self.allDatas[@"clist"];
        for (int i=0; i<arrayImage.count; i++) {
            UIButton*buttonImage=[[UIButton alloc]init];
            buttonImage.backgroundColor=[UIColor whiteColor];
            buttonImage.imageView.contentMode=UIViewContentModeScaleAspectFit;
            [buttonImage sd_setImageWithURL:[NSURL URLWithString:arrayImage[i][@"pic"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_58x80"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (cacheType!=2) {
                    buttonImage.alpha=0.3;
                    CGFloat scale = 0.3;
                    buttonImage.transform = CGAffineTransformMakeScale(scale, scale);
                    
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        buttonImage.alpha=1;
                        CGFloat scale = 1.0;
                        buttonImage.transform = CGAffineTransformMakeScale(scale, scale);
                    }];

                }
                
                
            }];
            buttonImage.frame=CGRectMake(ACTUAL_WIDTH(12)+ACTUAL_WIDTH(70)*i, ACTUAL_HEIGHT(18), ACTUAL_WIDTH(58), ACTUAL_HEIGHT(80));
            [buttonImage addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
                      [self.allButtons addObject:buttonImage];
            buttonImage.tag=i;
            if (buttonImage.tag==0) {
                buttonImage.selected=YES;
                buttonImage.layer.borderColor=[UIColor blackColor].CGColor;
                buttonImage.layer.borderWidth=3;
            }
            [_viewImage addSubview:buttonImage];
            
        }
        
//    }];
    mainView.frame=CGRectMake(0, 0, KScreenWidth, _viewImage.bottom);
    NSLog(@"%f",mainView.bottom);
    NSLog(@"%f",_viewImage.bottom);
    return mainView;

    
}

-(void)touchButton:(UIButton*)sender{
    //tag 0 1 2
    NSLog(@"%lu",sender.tag);
    for (int i=0; i<self.allButtons.count;i++ ) {
       UIButton*button= self.allButtons[i];
        button.selected=NO;
        button.layer.borderWidth=0;
    }
    
    
    if (sender.selected==YES) {
        //这里面并没有什么软用

    }else{
        sender.layer.borderWidth=3;
        sender.layer.borderColor=[UIColor blackColor].CGColor;
        sender.selected=YES;
        
       NSArray*collectionValue=self.allDatas[@"clist"][sender.tag][@"prolist"];
        self.allCollectionViewDatas=collectionValue;
        
        if ([self.delegate respondsToSelector:@selector(DelegateForCellSendDatas:)]) {
            [self.delegate DelegateForCellSendDatas:self.allCollectionViewDatas];
        }
    }
    
    
}

//-(void)addView{
//    _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0,KScreenHeight-ACTUAL_HEIGHT(120), KScreenWidth, ACTUAL_HEIGHT(120))];
//    _bottomView.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:_bottomView];
//    
//    NSArray*arrayImage=@[@"",@"",@""];
//    for (int i=0; i<arrayImage.count; i++) {
//        UIButton*buttonImage=[[UIButton alloc]init];
//        buttonImage.backgroundColor=[UIColor blueColor];
//        buttonImage.frame=CGRectMake(ACTUAL_WIDTH(12)+ACTUAL_WIDTH(70)*i, ACTUAL_HEIGHT(18), ACTUAL_WIDTH(58), ACTUAL_HEIGHT(80));
//        buttonImage.tag=i;
//        [_bottomView addSubview:buttonImage];
//
//    
//}
//}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGPoint aa=scrollView.contentOffset;
//    NSLog(@"%@",NSStringFromCGPoint(aa));
//    
////    88
//    if (scrollView.contentOffset.y==ACTUAL_HEIGHT(88)) {
//        [self.bottomView setY:KScreenHeight-ACTUAL_HEIGHT(120)-(scrollView.contentOffset.y-ACTUAL_HEIGHT(88))];
//    }
//    
//}

#pragma mark  ------   点击跳转到商品详情
-(void)DelegateForTiaozhuan:(NSDictionary *)dict{
//    GoodsTailsViewController*vc=[[GoodsTailsViewController alloc]init];
//    vc.thisDatas=dict;
//    [self.navigationController pushViewController:vc animated:YES];
    
    NewGoodDetailViewController*vc=[NewGoodDetailViewController creatNewVCwith:0 andDatas:dict];
    [self.navigationController pushViewController:vc animated:YES];
    
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
