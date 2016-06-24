//
//  ChengShiVC.h
//  HGY


#import <UIKit/UIKit.h>

@protocol ChengShiVCDelegate <NSObject>

- (void)string:(NSString *)str;

@end

@interface ChengShiVC : UIViewController

@property (nonatomic, assign)id<ChengShiVCDelegate>delegate;

@end
