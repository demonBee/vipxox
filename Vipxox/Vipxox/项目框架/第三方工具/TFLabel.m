#import "TFLabel.h"

@implementation TFLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.numberOfLines = 0;
//        self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
//        self.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    self.frame = [self textRectForBounds:self.frame limitedToNumberOfLines:self.numberOfLines];
    
}

@end
