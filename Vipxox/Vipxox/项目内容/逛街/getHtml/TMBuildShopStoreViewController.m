#import "TMBuildShopStoreViewController.h"
#import "TRCollectionViewCell.h"
#import "HTM5ViewController.h"
#import "HttpManager.h"

@interface TMBuildShopStoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)NSArray*allDatas;
@property(nonatomic,strong)NSArray*allImages;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation TMBuildShopStoreViewController



   - (void)viewDidLoad
{
    [super viewDidLoad];

    [self getDatas];
       [self makeCollectionView];
//    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    self.view.backgroundColor=[UIColor whiteColor];
    
}
static NSString *ID = @"Cell";
-(void)makeCollectionView{
    //    布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(KScreenWidth/3, ACTUAL_HEIGHT(124));//cell的尺寸
    flowLayout.minimumLineSpacing = 0;//横向间距
    flowLayout.minimumInteritemSpacing = 0;//竖向间距
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);//分区头间距
    flowLayout.footerReferenceSize = CGSizeMake(0, 0);//分区尾间距
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//设置为横屏滑动
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, KScreenHeight-NavigationBarHeight-tabbarDeHeight-StatusBarHeight) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TRCollectionViewCell class] forCellWithReuseIdentifier:ID];//注册
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:collectionView];
    NSLog(@"%f",NavigationBarHeight);
    NSLog(@"%d",tabbarDeHeight);
    NSLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
}




-(void)getDatas{
//    http://www.vipxox.cn/?m=appapi&s=go_shop&act=image_url&uid=1
//      http://www.vipxox.cn/?m=appapi&s=home_page&act=image_url&uid=1
    
    NSMutableString *urlStr=[NSMutableString stringWithFormat:@"%@", HTTP_ADDRESS];

    NSDictionary*params=@{@"m":@"appapi",@"s":@"home_page",@"act":@"image_url",@"uid":[UserSession instance].uid};
    HttpManager *manager=[[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        
        NSString*number=[NSString stringWithFormat:@"%@",data[@"errorCode"]];
        NSLog(@"%@",number);
        
        if ([number isEqualToString:@"0"]) {
        
            self.allDatas=data[@"data"];
            self.allImages=data[@"url"];
            
            [self.collectionView reloadData];
            
            
        }else{
            [JRToast showWithText:[data objectForKey:@"errorMessage"]];
        }
        
    }];
    

    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //图片  和 url  都是要按 每行3个
    if ([self.allDatas count]%3!=0) {
        NSInteger section=[self.allDatas count]/3+1;
        return section;
    }else{
        NSInteger section=[self.allDatas count]/3;
        return section;
    }
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (section==0||section==1) {
//        return 3;
//    }else{
//        return 2;
//    }
    return 3;
    
  }


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TRCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSLog(@"%@",self.allImages);
    
        NSInteger number=indexPath.section*3+indexPath.row;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.allDatas[number]]]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [cell.imageView setImage:image];
//            });
//        });
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.allDatas[number]] placeholderImage:[UIImage imageNamed:@"placeholder_375x667"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType!=2) {
            cell.imageView.alpha=0.3;
            CGFloat scale = 0.3;
            cell.imageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            
            [UIView animateWithDuration:0.3 animations:^{
                cell.imageView.alpha=1;
                CGFloat scale = 1.0;
                cell.imageView.transform = CGAffineTransformMakeScale(scale, scale);
            }];
        }
    }];

    
 
   
//    cell.imageView.image=[UIImage imageNamed:@"1"];
    
   return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
       NSInteger number=indexPath.section*3+indexPath.row;
    NSString*str=self.allImages[number];
    NSArray *array=@[@"淘宝",@"天猫",@"京东商城",@"苏宁易购",@"当当网",@"阿里巴巴",@"时尚起义",@"聚划算",@"美丽说"];
    HTM5ViewController*vc=[[HTM5ViewController alloc]init];
    vc.strHtml=str;
    vc.str1=array[number];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"%@",str);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  设置导航栏按钮
 */
//- (void)setupBarButtonItem
//{
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
//    self.navigationItem.leftBarButtonItem = left;
//    
//}

/**
 *  取消
 */
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
