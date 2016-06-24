//
//  fristCollectionViewCell.m
//  HGY
//


#import "fristCollectionViewCell.h"



@implementation fristCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self addSubviews];
    }
    return self;
}



- (void)addSubviews
{
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100 * kWidth, 100 * kHeight)];
    [self addSubview:self.imageV];
   
    self.imageV.layer.cornerRadius = self.imageV.frame.size.width / 2.0;
    self.imageV.layer.masksToBounds = YES;
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , self.imageV.bottom + 10 * kHeight, 100 * kWidth, 20 * kHeight)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //self.titleLabel.backgroundColor = [UIColor greenColor];
    [self addSubview:self.titleLabel];
}

@end
