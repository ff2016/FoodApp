//
//  SecondTableViewCell.m
//  FoodApp
//


#import "SecondTableViewCell.h"


@implementation SecondTableViewCell

-(void)setSecondModel:(SecondModel *)secondModel{
    _foodTitle.text = secondModel.foodtitle;
    _kouwei.text = [NSString stringWithFormat:@"%@ / %@",secondModel.kouwei,secondModel.gongyi];
    _titlepic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",secondModel.titlepic]]]];
    _m.text = [NSString stringWithFormat:@"制作时所需时长: %@",secondModel.mt];
    _md.text = secondModel.md;

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
