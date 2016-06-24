//
//  dealModel.m
//  HGY
//


#import "dealModel.h"

@implementation dealModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.description1 = (NSString *)value;
    }

}
@end
