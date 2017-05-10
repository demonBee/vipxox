//
//  EditCommentViewController.m
//  shashou
//
//  Created by 黄佳峰 on 16/7/6.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "EditCommentViewController.h"
#import "EditCommentTableViewCell.h"   //就一个cell
#import "SAMTextView.h"

//#import "HttpObject.h"

#define EDITCELL  @"EditCommentTableViewCell"

@interface EditCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MBProgressHUDDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property (nonatomic,strong)SAMTextView * commentTextView;

@property (nonatomic,strong)NSMutableDictionary * requestDic;

@property (nonatomic,strong)NSMutableArray * picArr;
//@property (nonatomic,strong)NSMutableArray * picPathArr;
@property (nonatomic,strong)NSMutableArray * imgBtnArr;

@property(nonatomic,assign)NSInteger xingNumber;  //星数
@property(nonatomic,assign)BOOL canSave;  //


@end

@implementation EditCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"评论";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:EDITCELL bundle:nil] forCellReuseIdentifier:EDITCELL];
   }



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditCommentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:EDITCELL];
    cell.selectionStyle=NO;
    SAMTextView * textView = [cell viewWithTag:10];
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDone;
    self.commentTextView = textView;
    self.commentTextView.placeholder=@"请出入您的评论";
    
    for (NSUInteger i = 1; i <= 5; i++) {
        UIButton * btn = [cell viewWithTag:i];
         [btn setBackgroundImage:[UIImage imageNamed:@"img_star_grey"] forState:UIControlStateNormal];
    }

    
    __weak typeof(cell)myCell = cell;
    cell.starCount = ^(NSUInteger commentStarCount){
        
        self.xingNumber=commentStarCount;
        //评论星数
        //1-5
              for (NSUInteger i = 1; i <= 5; i++) {
            UIButton * btn = [myCell viewWithTag:i];
            if (i > commentStarCount) {
                [btn setBackgroundImage:[UIImage imageNamed:@"img_star_grey"] forState:UIControlStateNormal];
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:@"img_star"] forState:UIControlStateNormal];
            }
        }
    };
    

    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 305;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    bgView.backgroundColor=[UIColor clearColor];
    
    UIButton*submit=[[UIButton alloc]initWithFrame:CGRectMake(10, 17, KScreenWidth-20, 46)];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [submit setBackgroundColor:ManColor];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:submit];
    
    return bgView;;
}


#pragma mark  ---   评论
-(void)submit{
   NSString*str= [self judgeSave];
    if (!_canSave) {
        [JRToast showWithText:str];
        return;
    }
    
    
// www.vipxox.cn/?m=app&s=baihuo&act=pingjia&con=@“1111”&xing=5
    NSString*urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    NSString*xingStr=[NSString stringWithFormat:@"%lu",self.xingNumber];
    NSDictionary*params=@{@"m":@"app",@"s":@"baihuo",@"act":@"pingjia",@"con":self.commentTextView.text,@"xing":xingStr,@"uid":[UserSession instance].uid,@"order_id":self.orderID};
    
    
    HttpManager*manager=[[HttpManager alloc]init];
   [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
       NSLog(@"%@",data);
       if ([data[@"errorCode"] isEqualToString:@"0"]) {
           [JRToast showWithText:@"评论成功"];
           if ([self.delegate respondsToSelector:@selector(delegateForCompleteCommitToReload)]) {
               [self.delegate delegateForCompleteCommitToReload];
           }
           
           [self.navigationController popViewControllerAnimated:YES];
           
           
       }else{
           [JRToast showWithText:data[@"errorMessage"]];
       }
       
       
   }];
    
    
    
}


-(NSString*)judgeSave{
    self.canSave=YES;
    if (self.xingNumber<1) {
        self.canSave=NO;
        return @"请评价星数";
    }else if (self.commentTextView.text.length<10){
        self.canSave=NO;
        return @"评论字数不能小于10个数";
        
    }
    
    
    return @"66";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _tableView;
}


//隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}


@end
