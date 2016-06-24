//
//  SecondModel.h
//  FoodApp
//


#import <Foundation/Foundation.h>

@interface SecondModel : NSObject

@property(nonatomic, copy)NSString *foodtitle;//菜名

@property(nonatomic, copy)NSString *src;//视频地址

@property(nonatomic, copy)NSString *kouwei;//口味

@property(nonatomic, copy)NSString *titlepic;//展示图片地址

@property(nonatomic, copy)NSString *mt;//需要时间

@property(nonatomic, copy)NSString *md;//难度等级

@property(nonatomic, copy)NSString *gongyi;//制作方法(炖,炒)
@end
