//
//  ChooseCourierViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/3/30.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "ChooseCourierViewController.h"
#import "HttpManager.h"
#import "NSString+PinYin.h"

@interface ChooseCourierViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView * tableView;

@property(nonatomic,strong) NSMutableArray * dataArr;

@property(nonatomic,strong)NSMutableArray * carArr;

@property(nonatomic,strong)NSString*str;


@end

@implementation ChooseCourierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc]init];
    [self makeNavi];
    [self getDatas];
    
    [self createTableView];
}

-(void)makeNavi{
    
    self.view.backgroundColor=RGBCOLOR(70, 73, 70, 1);
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(0), ACTUAL_HEIGHT(34),KScreenWidth, ACTUAL_WIDTH(19))];
    titleLabel.text=@"快递选择";
    titleLabel.textAlignment=1;
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    
    UIButton*button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(ACTUAL_WIDTH(20), ACTUAL_HEIGHT(30), ACTUAL_WIDTH(100), ACTUAL_HEIGHT(25));
    [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)preData
{
    for (char i = 'A'; i <= 'Z'; i++)
    {
        
        NSString * str = [NSString stringWithFormat:@"%c",i];
        
        NSMutableArray * carMuArr = [[NSMutableArray alloc]init];
        
        for (NSString * carName in _carArr)
        {
            if ([[carName getFirstLetter] isEqualToString:str])
            {
                [carMuArr addObject:carName];
            }
        }
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setObject:str forKey:@"Title"];
        [dic setObject:carMuArr forKey:@"Arr"];
        
        [_dataArr addObject:dic];
    }
    NSLog(@"%@",_dataArr);
}

- (void)createTableView
{
    _tableView = ({
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(66), KScreenWidth, KScreenHeight-ACTUAL_HEIGHT(66)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dic = _dataArr[section];
    NSArray * arr = dic[@"Arr"];
    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"myCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary * dic = _dataArr[indexPath.section];
    NSArray * arr = dic[@"Arr"];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}


//设置组名
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary * dic = _dataArr[section];
    return dic[@"Title"];
}

//设置索引名
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    tableView.sectionIndexColor = [UIColor blackColor];
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in _dataArr)
    {
        [arr addObject:dic[@"Title"]];
    }
    return arr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu    %lu",indexPath.section,indexPath.row);
    NSDictionary * dic = _dataArr[indexPath.section];
    NSArray * arr = dic[@"Arr"];
    _str= arr[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(delegateForBack0:)]) {
        [self.delegate delegateForBack0:_str];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getDatas{
    //http://www.vipxox.cn/?m=appapi&s=membercenter&act=transport&uid=&op=logistics
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];
    NSDictionary*params=@{@"m":@"appapi",@"s":@"membercenter",@"act":@"transport",@"uid":[UserSession instance].uid,@"op":@"logistics"};
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        
        if ([number isEqualToString:@"0"]) {
            _carArr=data[@"data"];
            
            NSLog(@"%@",data[@"data"]);
            [self preData];
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:[data objectForKey:@"errorMessage"]];
        }
        
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(delegateForBack0:)]) {
        [self.delegate delegateForBack0:_str];
    }
}


-(void)dismissTo{
    if ([self.delegate respondsToSelector:@selector(delegateForBack0:)]) {
        [self.delegate delegateForBack0:_str];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
