//
//  firstFootManager.m
//  HGY
//


#import "firstFootManager.h"

@interface firstFootManager ()
@property (nonatomic, retain)NSMutableArray *dataArray;

@end

@implementation firstFootManager

+ (firstFootManager *)shareManager
{
    static firstFootManager *share = nil;
    if (share == nil) {
        share = [[firstFootManager alloc] init];
    }
    return share;
}

- (void)requestDataForReloadWithUrl:(NSString *)url Block:(void(^)(NSArray *array))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30.0];
        [request setHTTPMethod:@"GET"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data == nil) {
                return ;
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
            
            self.dataArray = [NSMutableArray array];
            NSMutableArray *tempArray = dic[@"categories"];
            for (NSDictionary *dic in tempArray) {
                Model *model = [[Model alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(self.dataArray);
            });
        }];
        [dataTask resume];
        
        
    });
    
}


- (Model *)ModelArray:(NSInteger )index
{

        Model *model = self.dataArray[index];
        return model;
    
}
- (NSInteger)numberArray
{
    NSInteger index = self.dataArray.count;
    return index;
}



@end
