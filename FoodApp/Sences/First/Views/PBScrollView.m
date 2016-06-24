//
//  PBScrollView.m
//  无限轮播
//


#import "PBScrollView.h"

/**
 *  创建宏定义，方便以后换地方使用时修改
 */
#define kItemWidth 200
#define kItemIntreval 10

#define kHeight self.frame.size.height
#define kWidth self.frame.size.width

#define kXContentOffset 1.5 * kItemWidth + kItemIntreval//scrollView最初状态时的偏移量

@implementation PBScrollView
{
    /**
     *  创建左中右三个imageView视图
     */
    UIImageView *_leftView;
    UIImageView *_centerView;
    UIImageView *_rightView;
    
    /**
     *  常见底部滚动视图
     */
    UIScrollView *_myScrollView;
    
    /**
     *  左中右三个imageView视图上的数组坐标
     */
    NSInteger leftIndex,centerIndex,rightIndex;
}


- (void)setCenterIndex:(ScrollViewBlock)block
{
    _scrollBlock = block;
}

- (void)setImageArr:(NSMutableArray *)imageArr
{
    _imageArr = imageArr;
    leftIndex = 0;
    centerIndex = 1;
    rightIndex = 2;
    [self creatView];
}

- (void)creatView
{
    _myScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _myScrollView.contentSize = CGSizeMake(5*kItemWidth + 2*kItemIntreval, kHeight);
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.showsVerticalScrollIndicator = NO;
    //不设置裁剪
    _myScrollView.clipsToBounds = NO;
    _myScrollView.delegate = self;
    [self addSubview:_myScrollView];
    /*设置_scrollView初始的偏移量 使中间视图处在屏幕的中央
     *
     *kXContentOffset = 2.5 *kItemWidth +kItemIntreval -kWidth/2
     *kXContentOffset:使中间视图处在屏幕的中央应设置的滚动偏移量
     *2.5 *kItemWidth +kItemIntreval:中间视图中线的便移位置
     *kWidth/2:屏幕宽的一半
     *
     */
    [_myScrollView setContentOffset:CGPointMake(kXContentOffset,0)];
    NSLog(@"%f",_myScrollView.contentOffset.x);
    //左边视图
    _leftView = [[UIImageView alloc] initWithFrame:CGRectMake(kItemWidth + kItemIntreval, 0, kItemWidth, kHeight)];
    _leftView.image = _imageArr[leftIndex];
    [_myScrollView addSubview:_leftView];
    
    //中心视图
    _centerView = [[UIImageView alloc] initWithFrame:CGRectMake(kItemWidth*2 + 2*kItemIntreval, 0, kItemWidth, kHeight)];
    _centerView.image = _imageArr[centerIndex];
    //放大中间的图片
    _centerView.transform = CGAffineTransformMakeScale(1.0, 1.3);
    [_myScrollView addSubview:_centerView];
    
    //右边视图
    _rightView = [[UIImageView alloc] initWithFrame:CGRectMake(3*kItemWidth + 3*kItemIntreval, 0, kItemWidth, kHeight)];
    _rightView.image = _imageArr[rightIndex];
    [_myScrollView addSubview:_rightView];
    
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xOffset = scrollView.contentOffset.x;
    //获得scrollView初始时的偏移量
    CGFloat x = kXContentOffset;
    if ((int)(xOffset - x)%kItemWidth == 0 && (int)(xOffset -x)/kItemWidth != 0) {
        //切换单元格元素的方法
        [self reloadView];
        //切换完数据之后 使_scrollView恢复初始时的滚动偏移量
        [_myScrollView setContentOffset:CGPointMake(kXContentOffset, 0)];
        }
}

//当scrollView结束拖拽时调用的方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    /*当scrollView结束拖拽时调用的方法强制给scrollView设置一个宽度的偏移量
     *原因：调用切换单元格元素的方法的判断条件是滚动了一个单元格的宽度。而每次滚动时滚动的偏移量不会正好是一个单元格的宽度
     */
    
    /*
     *判断:偏移量与oldOffset（开始拖拽是产生的x方向的滚动偏移量）比较
     *如果是大于：向左拖拽 -> 滚动偏移量在初始偏移量的基础上加一个单元格的宽度
     *如果是小于：向右拖拽 -> 滚动偏移量在初始偏移量的基础上减一个单元格的宽度
     */
    if (targetContentOffset->x > kXContentOffset) {
       
        targetContentOffset->x = kItemWidth + kXContentOffset;
    }else if (targetContentOffset->x < kXContentOffset) {
        
        targetContentOffset->x = -kItemWidth + kXContentOffset;
    }
}


- (void)reloadView {
    /*将此时_scrollView的偏移量与初始偏移量（最初单元格所处的位置）相比较
     *大于 每个单元格切换下一个数据
     *小于 每个单元格切换上一个数据
   */
    if (_myScrollView.contentOffset.x > kXContentOffset) {
        
        leftIndex = (leftIndex +1)%_imageArr.count;
        
        centerIndex = (centerIndex +1)%_imageArr.count;
        
        rightIndex = (rightIndex +1)%_imageArr.count;
        
    }else if (_myScrollView.contentOffset.x < kXContentOffset) {
        NSLog(@"%f",_myScrollView.contentOffset.x);
        leftIndex = (leftIndex -1 +_imageArr.count)%_imageArr.count;
        
        centerIndex = (centerIndex -1 +_imageArr.count)%_imageArr.count;
        
        rightIndex = (rightIndex -1 +_imageArr.count)%_imageArr.count;
        
    }
    _leftView.image = _imageArr[leftIndex];
    _centerView.image = _imageArr[centerIndex];
    _rightView.image = _imageArr[rightIndex];
    NSLog(@"%ld,%ld,%ld,%f",leftIndex,centerIndex,rightIndex,_myScrollView.contentOffset.x);
    //4.给block传值
    if (_scrollBlock) {
        
        _scrollBlock(centerIndex);
    }
    
}



@end
