//
//  RealChooseViewController.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/3/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "RealChooseViewController.h"

@interface RealChooseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView*aatableView;
@property(nonatomic,strong)UITableView*subTableView;

@property(nonatomic,assign)NSInteger roow;  //作为从 suballDAtas  提取数字的下标
@property(nonatomic,strong)NSString *goods;  //用来存 前一个分类的名字

@property(nonatomic,assign)NSInteger tagForGetId;  //tableView 的indexPath 为了得到品牌的id
@end


@implementation RealChooseViewController

-(UITableView *)aatableView{
    if (!_aatableView) {
        _aatableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _aatableView.delegate=self;
        _aatableView.dataSource=self;
    }
    return _aatableView;
}

-(UITableView*)subTableView{
    if (!_subTableView) {
        _subTableView=[[UITableView alloc]initWithFrame:CGRectMake(KScreenWidth, ACTUAL_HEIGHT(64), KScreenWidth/2, KScreenHeight-ACTUAL_HEIGHT(64)) style:UITableViewStyleGrouped];
        _subTableView.delegate=self;
        _subTableView.dataSource=self;
    }
    return _subTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.allDatas[0];
    NSLog(@"%@",self.allDatas);
    [self.view addSubview:self.aatableView];
    self.view.backgroundColor=[UIColor blueColor];
    
    if (self.subAllDatas!=nil) {
        [self.view addSubview:self.subTableView];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.aatableView]) {
        return self.allDatas.count-1;

    }else{
        return [self.subAllDatas[self.roow] count];
    }
  }
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if ([tableView isEqual:self.aatableView]) {
        cell.textLabel.text=self.allDatas[indexPath.row+1];
        cell.textLabel.font=[UIFont systemFontOfSize:12];
        cell.textLabel.textColor=RGBCOLOR(122, 123, 124, 1);
        cell.backgroundColor=RGBCOLOR(240, 241, 242, 1);
        return cell;

    }else{
        cell.textLabel.text=self.subAllDatas[self.roow][indexPath.row];
        cell.textLabel.font=[UIFont systemFontOfSize:12];
        cell.textLabel.textColor=RGBCOLOR(122, 123, 124, 1);
        cell.backgroundColor=[UIColor whiteColor];

        return cell;
        
    }
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.aatableView]) {
        if (indexPath.row==0) {
            //此处  就是全部 最上面的按钮
            //直接给后台   数值   这个
            NSString *str=self.allDatas[1];
            self.goods=str;
            self.tagForGetId=indexPath.row+1;
            
            NSLog(@"%@",self.goods);
            if ([self.delegate respondsToSelector:@selector(backGoods:subGoods: andTag:)]) {
                [self.delegate backGoods:self.goods subGoods:nil andTag:self.tagForGetId];
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            self.goods=self.allDatas[indexPath.row+1];

            
            if (self.subAllDatas!=nil) {
                //这个值 直接从 subAllDatas 中提职
                self.roow=indexPath.row-1;
                
                if (self.subTableView.x==KScreenWidth) {
                    [UIView animateWithDuration:0.5 animations:^{
                        CGRect rect=CGRectMake(KScreenWidth/2, ACTUAL_HEIGHT(64), KScreenWidth/2, KScreenHeight-ACTUAL_HEIGHT(64));
                        self.subTableView.frame=rect;
                        [self.subTableView reloadData];
                        
                    }];
                    
                }else{
                    [self.subTableView reloadData];
                }
                

            }else{
                //等于空的时候
                NSLog(@"%@",self.goods);
                if ([self.delegate respondsToSelector:@selector(backGoods:subGoods: andTag:)]) {
                    [self.delegate backGoods:self.goods subGoods:nil andTag:self.tagForGetId];
                }

                [self.navigationController popViewControllerAnimated:YES];

                
            }
            
        }
        
}else{
        //此处需要穿数据给后台
    
    NSLog(@" %@,  %@",self.goods,self.subAllDatas[self.roow][indexPath.row]);
    if ([self.delegate respondsToSelector:@selector(backGoods:subGoods: andTag:)]) {
        [self.delegate backGoods:self.goods subGoods:self.subAllDatas[self.roow][indexPath.row] andTag:self.tagForGetId];
    }

    [self.navigationController popViewControllerAnimated:YES];

    
    
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
