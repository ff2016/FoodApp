//
//  PBScrollView.h
//  无限轮播
//

#import <UIKit/UIKit.h>
typedef void(^ScrollViewBlock)(NSInteger index);//创建一个block以备以后可能的传值使用
@interface PBScrollView : UIView<UIScrollViewDelegate>//注意使用此封装类必须有一个xib视图来加载
{
    
    //2.声明一个对应类型的block的属性名
    ScrollViewBlock _scrollBlock;
    
}

//3.声明block的方法 再此方法中给block赋值
- (void)setCenterIndex:(ScrollViewBlock)block;

@property (nonatomic,copy)NSArray *imageArr;

@end
