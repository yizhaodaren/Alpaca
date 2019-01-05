//
//  BadgeNumber.m
//  BadgeNumberDemo
//
//  Created by ios on 15/1/17.
//  Copyright (c) 2015年 NB. All rights reserved.
//

#import "BadgeNumber.h"

@implementation BadgeNumber

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _rect = frame;
        self.font =REGULAR_FONT(8);
        self.textColor = [UIColor clearColor];
        
        
        _label = [[UILabel alloc] init];
        _label.font = self.font;
        _label.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _label.backgroundColor = HEX_COLOR(0xED424B);
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        
    }
    return self;
}

- (UIImage *)imageToExtent:(UIImage *)img{
    if ([img respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]){
        CGFloat top = 5; // 顶端盖高度
        CGFloat bottom = 5 ; // 底端盖高度
        CGFloat left = 5; // 左端盖宽度
        CGFloat right = 5; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        img = [img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    return img;
}

-(void)setBadgeString:(NSString *)badgeString{
    NSString *countString = badgeString;
    if ([countString length] == 0 || [countString isEqualToString:@"0"])
    {
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    
    
    CGSize numberSize = [countString sizeWithAttributes:@{NSFontAttributeName : _font}];
    
    
    numberSize.width += 4.0f;
    if (numberSize.width<18.0f){
        numberSize.width = 18.0f;
    }
    if (numberSize.height<18.0f){
        numberSize.height = 18.0f;
    }
    _label.textColor = self.textColor;
    _label.font = self.font;
    if ([countString isEqualToString:@"zero"]) {
        _label.text = @"";//用户消息页面“与我相关”只显示小红点不显示数目
    }else{
        _label.text = badgeString;
    }
    _label.frame = CGRectMake((_rect.size.width-numberSize.width)/2.0f,(_rect.size.height-numberSize.height)/2.0f, numberSize.width, numberSize.height);
    
}

- (NSString*)getBadgeString{
    return _badgeString;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
