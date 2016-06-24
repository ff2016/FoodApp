//
//  headerView.m
//  Mtime
//


#import "HeaderView.h"


@implementation HeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
     _view.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:1.0];
    _scrollView.backgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:0];
    _dataArray = @[[UIImage imageNamed:@"mn111"],[UIImage imageNamed:@"mn112"],[UIImage imageNamed:@"mn113"],[UIImage imageNamed:@"mn114"],[UIImage imageNamed:@"mn115"]];
    
    _scrollView.imageArr = _dataArray;

}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = @[[UIImage imageNamed:@"mn111"],[UIImage imageNamed:@"mn112"],[UIImage imageNamed:@"mn113"],[UIImage imageNamed:@"mn114"],[UIImage imageNamed:@"mn115"]];

    _scrollView.imageArr = _dataArray;
}



@end
