//
//  fristVC.m
//  HGY

#import "fristVC.h"
#import "RequestViewController.h"

@interface fristVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain)UITableView *tableView;

@property (nonatomic, retain)NSMutableArray *dataArray;
@end

@implementation fristVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       [self requestDataForReloadWithUrl:nil Block:^(NSArray *array) {
       [self.tableView reloadData];
           self.dataArray = (NSMutableArray *)array;
        }];
    self.navigationController.navigationBar.translucent = NO;
   // self.view.backgroundColor = [UIColor redColor];
    [self addTableViews];
    
    
}


- (void)addTableViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight - 44 ) ) style:(UITableViewStylePlain)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
   // self.tableView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.dataArray.count = %ld", self.dataArray.count);
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeiShiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[MeiShiTableViewCell alloc ] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    }
    dealModel *model = self.dataArray[indexPath.row];
    
    cell.nameLabel.text = model.title;
    cell.subLabel.text = model.description1;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.s_image_url]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

// 数据源
- (void)requestDataForReloadWithUrl:(NSString *)url Block:(void(^)(NSArray *array))block
{
    if (self.cityStr.length == 0) {
        self.cityStr = @"上海";
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.cityStr, @"city", self.string,@"category", @"30", @"limit", @"1", @"page" , nil];
    NSMutableDictionary *newDic = [SignatrueEncryption encryptedParamsWithBaseParams:dic];
    NSString *UrlString  = [NSString stringWithFormat:@"http://api.dianping.com/v1/deal/find_deals?appkey=42960815&sign=%@&city=%@&category=%@&limit=30&page=1", newDic[@"sign"], newDic[@"city"], newDic[@"category"]];
    NSString *newUrl = [UrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUrl] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30.0];
        [request setHTTPMethod:@"GET"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           
            self.dataArray = [NSMutableArray array];
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (data == nil) {
                
                
                return ;
            }
            NSMutableArray *tempArray = dictionary[@"deals"];
            for (NSDictionary *dic in tempArray) {
                dealModel *model = [[dealModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                block (self.dataArray);
            });
            
        }];
        [dataTask resume];
    });

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dealModel *model = self.dataArray[indexPath.row];
    RequestViewController *request = [[RequestViewController alloc] init];
    request.requestUrl = model.deal_h5_url;
    request.model = model;
    [self.navigationController pushViewController:request animated:YES];

}



@end
