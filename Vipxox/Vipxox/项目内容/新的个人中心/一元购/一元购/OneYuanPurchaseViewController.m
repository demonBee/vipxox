//
//  OneYuanPurchaseViewController.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/1.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "OneYuanPurchaseViewController.h"
#import "TMAddressViewController.h"
#import "OnePayDetailViewController.h"

#import "OneYuanModel.h"

#import "YJSegmentedControl.h"
#import "HttpObject.h"

#import "OneYuanTableViewCell.h"

#define ONEYUANCELL @"OneYuanTableViewCell"
@interface OneYuanPurchaseViewController ()<UITableViewDataSource,UITableViewDelegate,YJSegmentedControlDelegate,TMAddressViewControllerDelegate>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * requestTypeArr;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;
@property (nonatomic,assign)NSInteger segmentSelectIndex;
@property (nonatomic,strong)YJSegmentedControl * segmentedControl;
@property (nonatomic,copy)NSString * code;//中奖者期号

@end

@implementation OneYuanPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.title=@"夺宝记录";
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self getData];//初始化请求参数
    [self makeNavi];
    [self makeUIControl];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:ONEYUANCELL bundle:nil] forCellReuseIdentifier:ONEYUANCELL];
    
    [self setupRefresh];
    
}

- (void)makeNavi{
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NaviBack"] style:UIBarButtonItemStylePlain target:self action:@selector(touchLeft)];
    self.navigationItem.leftBarButtonItem =leftItem;
}
- (void)touchLeft{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView setContentOffset:CGPointMake(0.f, 0.f) animated:YES];
    [self.tableView headerBeginRefreshing];//下拉刷新
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData{
    self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.pagen = @"10";
    self.pages = 0;
    self.segmentSelectIndex = 0;
    self.requestTypeArr = @[@"whole",@"conduct",@"announced"];
}

#pragma mark - UIControl
-(UITableView *)tableView{
    if (!_tableView) {
        //100.f = 64.f + 35.f + 1.f
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 99.f, KScreenWidth, KScreenHeight-99.f) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=RGBCOLOR(247, 247, 247, 1);
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
- (void)makeUIControl{
    [self makeYJSegmentedControl];
}

#pragma - YJSegmentedControl
- (void)makeYJSegmentedControl{
    self.segmentedControl = [YJSegmentedControl segmentedControlFrame:CGRectMake(0,64.f, KScreenWidth, 35.f) titleDataSource:@[@"全部",@"进行中",@"已揭晓"] backgroundColor:[UIColor whiteColor] titleColor:RGBCOLOR(174, 174, 174, 1) titleFont:[UIFont systemFontOfSize:14.f] selectColor:[UIColor blackColor] buttonDownColor:[UIColor blackColor] Delegate:self];
    
    [self.view addSubview:self.segmentedControl];
}

-(void)segumentSelectionChange:(NSInteger)selection{
    self.segmentSelectIndex = selection;
    [self.tableView headerBeginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OneYuanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ONEYUANCELL];
    cell.model = self.dataArr[indexPath.section];
    typeof(cell)weakCell = cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rePayBlock = ^(NSInteger status){
        if (status == 1) {
            //再次购买
            OnePayDetailViewController * vc = [[OnePayDetailViewController alloc]init];
            vc.idd = weakCell.model.pid;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (status == 3){
            //获奖，填写地址3
            self.code = weakCell.model.user_code;
            TMAddressViewController*vc=[[TMAddressViewController alloc]init];
            vc.delegate=self;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSArray * hudArr = @[@"Please wait for the lottery",@"",@"The lottery opened",@"",@"The prize sending",@"The prize sended"];
//             NSArray * hudArr = @[@"待开奖",@"",@"已揭奖",@"",@"发奖中",@"奖品已发送"];
            [self showHUDWithStr:hudArr[status]];
        }
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.f;
}

#pragma mark - TableView Refresh
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
- (void)headerRereshing
{
    //重置&请求
    self.pages = 0;
    [self.tableView setContentOffset:CGPointMake(0.f, 0.f) animated:YES];
    [self requestOneYuanDataWithSegumentIndexPages:0];
}

- (void)footerRereshing
{
    self.pages++;
    [self requestOneYuanDataWithSegumentIndexPages:self.pages];
}

#pragma mark - TMAddressViewControllerDelegate
//邮编号
- (BOOL)isZipIDWithStr:(NSString *)zipNumber{
    NSString *zipNumberRegex = @"^[0-9]{2,20}+$";
    NSPredicate *zipNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",zipNumberRegex];
    return [zipNumberPredicate evaluateWithObject:zipNumber];
}
-(void)DelegateForSendValueToAddress:(NSDictionary*)dict{
    //给获奖订单传数据
    MyLog(@"获奖填写地址:%@",dict);
    if (![self isZipIDWithStr:dict[@"zip"]]) {
//        [self showHUDWithStr:@"Please fill in right zip"];
        [self showHUDWithStr:@"请填写正确的邮编"];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sureAddressWithDic:dict];//确认收货地址
    });
    
  

}

- (void)sureAddressWithDic:(NSDictionary *)dict{
    UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary * program = @{@"uid":[UserSession instance].uid,@"code":self.code,@"name":dict[@"name"],@"country":dict[@"country_name"],@"province":dict[@"province_name"],@"city":dict[@"city_name"],@"address":dict[@"address"],@"tel":dict[@"mobile"],@"zip":dict[@"zip"]};
        [self requestGetPrizeWithProgram:program];
    }];
    UIAlertAction * CancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attention" message:@"To receive the prize address cannot be modified.Confirm is the address?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:CancelAction];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - HTTP
- (void)requestOneYuanDataWithSegumentIndexPages:(NSInteger)page{
    NSDictionary * pragram = @{@"uid":[UserSession instance].uid,@"zt":self.requestTypeArr[self.segmentSelectIndex],@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager] postDataWithType:OnePayType_LIST withPragram:pragram success:^(id responsObj) {
        MyLog(@"OnePayList program is %@",pragram);
        MyLog(@"OnePayList is %@",responsObj);
        if (page == 0) {
            //下拉刷新
            [self.tableView headerEndRefreshing];
            [self.dataArr removeAllObjects];
        }else{
            //上拉刷新
            [self.tableView footerEndRefreshing];
        }
        NSArray * dataArr = responsObj[@"data"];
        if (dataArr.count <= 0)return;//无新数据则返回
        for (NSDictionary * dataDic in dataArr) {
            OneYuanModel * oneyuanModel = [OneYuanModel yy_modelWithDictionary:dataDic];
            [self.dataArr addObject:oneyuanModel];
        }
        [self.tableView reloadData];
    } failur:^(NSError *error) {
        MyLog(@"OnePayList error is%@",error);
        if (page == 0) {
            [self.tableView headerEndRefreshing];
        }else{
            [self.tableView footerEndRefreshing];
        }
    }];
}

- (void)requestGetPrizeWithProgram:(NSDictionary *)program{
    [[HttpObject manager]getDataWithType:OnePayType_GETPRIZE withPragram:program success:^(id responsObj) {
        MyLog(@"Get Prizi is %@",responsObj);
        MyLog(@"Get Prizi pragram is %@",program);
        [self showHUDWithStr:@"Please wait for receiving"];
        [self.tableView headerBeginRefreshing];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Get Prizi pragram is %@",program);
        MyLog(@"Get Prizi error is %@",error);
        [self showHUDWithStr:@"Faild"];
    }];
}

#pragma mark - MBProgressHUD
- (void)showHUDWithStr:(NSString *)showHud{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = showHud;
    hud.dimBackground = YES;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.7];
}

@end
