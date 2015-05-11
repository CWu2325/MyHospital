//
//  TEXTLabel.m
//  ZiTiLabel
//
//  Created by 1 on 14-6-20.
//  Copyright (c) 2014年 huichewang. All rights reserved.
//

#import "TEXTLabel.h"

@implementation TEXTLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame WithAllString:(NSString *)allString WithEditString:(NSString *)editString WithColor:(UIColor *)color WithFont:(UIFont *)font

{
//- (NSRange)rangeOfString:(NSString *)aString
    self = [super initWithFrame:frame];
    
    if (self)
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allString];
        self.textColor = [UIColor grayColor];
        [str addAttribute:NSForegroundColorAttributeName value:color range:[allString rangeOfString:editString]];
        //[str addAttribute:NSFontAttributeName value:font range:[allString rangeOfString:editString]];
        self.font = font;
        self.attributedText = str;
        
       // UIFont *font = [UIFont systemFontOfSize:12];
        
    }

    return self;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
