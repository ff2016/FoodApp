//
//  UIView+WLFrame.h
//  
//

//

#import <UIKit/UIKit.h>

//#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface UIView (WLFrame)

//  高度
@property (nonatomic,assign) CGFloat height;
//  宽度
@property (nonatomic,assign) CGFloat width;

//  Y
@property (nonatomic,assign) CGFloat top; // 上
//  X
@property (nonatomic,assign) CGFloat left; // 左

//  Y + Height
@property (nonatomic,assign) CGFloat bottom; // 低
//  X + width
@property (nonatomic,assign) CGFloat right; // 右

@end
