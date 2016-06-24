//
//  ChengShiTableViewCell.m
//  HGY
//


#import "ChengShiTableViewCell.h"




@implementation ChengShiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addcell];
    }
    return self;
}

- (void)addcell
{
      int a = 101;
     for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 3; j++) {
           
            self.button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            self.button.frame = CGRectMake((0 + j * 140) * kHeight  , (0 + i * 50) * kHeight , 130 * kWidth, 40 * kHeight) ;
            self.button.tag = a;
            self.button.layer.cornerRadius = self.button.frame.size.width / 20;
            self.button.layer.borderWidth = 0.5;
            [self.contentView addSubview:self.button];
            a++;
        }
    }

}

@end
