//
//  GuangjieViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/5/23.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "GuangjieViewController.h"
#import "GuangjieTableViewCell.h"
#import "HTM5ViewController.h"
#import "BuyOtherGurideViewController.h"   //guride

#define GUANGJIECELL  @"GuangjieTableViewCell"

@interface GuangjieViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSArray*arrayImage;
@property(nonatomic,strong)NSArray*arrayUrl;
@property(nonatomic,strong)NSArray*arrayName;
@property(nonatomic,strong)NSArray*arrayTouchUrl;  //点击url
@end

@implementation GuangjieViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=RGBCOLOR(235, 236, 237, 1);
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDatas];
    [self makeNaviUI];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:GUANGJIECELL bundle:nil] forCellReuseIdentifier:GUANGJIECELL];
    
}

-(void)makeNaviUI{
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_nav_daigouinfor"] style:UIBarButtonItemStylePlain target:self action:@selector(touchRightNavi:)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
}

-(void)touchRightNavi:(id)sender{
    BuyOtherGurideViewController*vc=[[BuyOtherGurideViewController alloc]init];
    [self.navigationController pushViewController:vc animated:nil];
    
}

-(void)getDatas{
    //    http://www.vipxox.cn/?m=appapi&s=go_shop&act=image_url&uid=1
    //      http://www.vipxox.cn/?m=appapi&s=home_page&act=image_url&uid=1
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
  
    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"image_url",@"uid":[UserSession instance].uid};
    HttpManager *manager=[[HttpManager alloc]init];
    __weak typeof(self)weakSelf=self;
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
            weakSelf.arrayImage=data[@"data"];
            weakSelf.arrayUrl=data[@"url"];
            weakSelf.arrayName=data[@"ddate"];
            weakSelf.arrayTouchUrl=data[@"uurl"];
            
            [self.tableView reloadData];
            
            
            
            
            
            
        }else{
            [JRToast showWithText:[data objectForKey:@"errorMessage"]];
        }
        
    }];
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.arrayImage.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:GUANGJIECELL];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=RGBCOLOR(235, 236, 237, 1);
    UIView*mainView=[cell viewWithTag:1];
    mainView.layer.cornerRadius=6;
    mainView.layer.masksToBounds=YES;
    mainView.backgroundColor=[UIColor whiteColor];
    
    UIImageView*imageView=[cell viewWithTag:2];
    imageView.layer.cornerRadius=imageView.width/2;
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.contentMode=UIViewContentModeScaleAspectFit;

       [imageView sd_setImageWithURL:[NSURL URLWithString:self.arrayImage[indexPath.section]] placeholderImage:[UIImage imageNamed:@"placeholder_55x55"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    
    UILabel*labelName=[cell viewWithTag:3];
    labelName.text=self.arrayName[indexPath.section];
    
    UILabel*labelEng=[cell viewWithTag:4];
    labelEng.text=self.arrayUrl[indexPath.section];
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTM5ViewController*vc=[[HTM5ViewController alloc]init];
    vc.strHtml=self.arrayTouchUrl[indexPath.section];
    vc.str1=self.arrayName[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
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
