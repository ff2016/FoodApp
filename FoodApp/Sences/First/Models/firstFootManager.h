//
//  firstFootManager.h
//  HGY
//


#import <Foundation/Foundation.h>

@interface firstFootManager : NSObject


+ (firstFootManager *)shareManager;

- (void)requestDataForReloadWithUrl:(NSString *)url Block:(void(^)(NSArray *array))block;

//分类
- (Model *)ModelArray:(NSInteger)index;
- (NSInteger)numberArray;

@end
