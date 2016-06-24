//
//  MeiShiTableViewCell.m
//  HGY
//


#import "MeiShiTableViewCell.h"

@implementation MeiShiTableViewCell

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
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(5 * kWidth, 5 * kHeight, 150 * kWidth, 100 * kHeight)];
    //self.image.backgroundColor = [UIColor purpleColor];
    [self addSubview:self.image];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.image.right + 30 * kWidth, 10 * kHeight, kScreenWidth - (self.image.right + 30) * kWidth, 30 * kHeight)];
    self.nameLabel.numberOfLines = 0;
     //  self.nameLabel.backgroundColor = [UIColor redColor];
    [self addSubview:self.nameLabel];
    
    self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.image.right + 30 * kWidth, self.nameLabel.bottom + 10 * kHeight, kScreenWidth - (self.image.right + 30) * kWidth, 40 * kHeight)];
    self.subLabel.numberOfLines = 0;
    self.subLabel.font = [UIFont systemFontOfSize:15];
   // self.subLabel.backgroundColor = [UIColor greenColor];
    [self addSubview:self.subLabel];
}

@end
