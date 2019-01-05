//
//  CircleSearch_HotView.m
//  USchoolCircle
//  热词板 由CircleSearch_SearchBarView类调用
//  Created by raytheon on 16/2/19.
//  Copyright © 2016年 uskytec. All rights reserved.
//

#import "CircleSearch_HotView.h"
#import "SearchTagModel.h"

@interface CircleSearch_HotView ()
{
    
    CGRect _frame;
    NSMutableArray *tapArr;
    UIScrollView *scrollV;
    
}
@end

@implementation CircleSearch_HotView
/*
 * 初始化方法
 *
 * @param frame 尺寸
 *
 * @param arr 数据
 *
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _frame=frame;
        tapArr =[NSMutableArray new];
    
        
    }
    return self;
}


-(void)creatAndArrangeHot:(NSArray *)arr{
    
    for (id views in self.subviews) {
        [views removeFromSuperview];
    }
    
    
    tapArr =[NSMutableArray arrayWithObject:arr];
    //创建ScrollView
    scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _frame.size.width, _frame.size.height)];
    [self addSubview:scrollV];

    //热词提示按钮界面
    UIView *hotV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _frame.size.width, 0)];
   
    [scrollV addSubview:hotV];
    //根据热词来确定hotV的高度
    /*****计算热词数量以及其排列*****/
    NSArray *hotButtonArr = (NSArray *)[self creatAndArrangeHotButton:arr andSuperViewSize:hotV.size.width];
    
    for (UIButton *button_hot in hotButtonArr) {
        [hotV addSubview:button_hot];
    }
    UIButton *lastButton = [hotButtonArr lastObject];
    hotV.height = lastButton.bottom;
    //回调
    //_block(CGRectMake(_frame.origin.x, _frame.origin.y, _frame.size.width, hotV.bottom),nil,nil);
    
    //确定scrollV的内容尺寸
    scrollV.contentSize = CGSizeMake(_frame.size.width, hotV.bottom+10);
    
    
    //点击事件
    UITapGestureRecognizer *panGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(circleSearch_HotViewHandlePan:)];
    
    [scrollV addGestureRecognizer:panGestureRecognizer];
    
}

-(void)circleSearch_HotViewHandlePan:(UITapGestureRecognizer *)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(tapKeyboardEvent)]) {
        [_delegate tapKeyboardEvent];
    }
    
}

-(NSMutableArray *)creatAndArrangeHotButton:(NSArray *)arr andSuperViewSize:(float)width{
    
    
    
    /*****创建*****/
    //遍历每一个字符串，并建立button
    float width_button = 0;
    UIButton * hotButton;
    //用于存放创建好的热键按钮
    NSMutableArray *arr_button = [[NSMutableArray alloc] init];
    for (SearchTagModel *searchDto  in arr) {
        
        NSString *str=searchDto.hot_word;
        //获取button中文字的宽度
        width_button = [self getNeededWidth:str andSize:CGSizeMake(0, 30) andFont:15];
        //创建button并设置button大小
        hotButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width_button+11+11, 30)];
        [hotButton setTitle:str forState:UIControlStateNormal];
        [hotButton setTitleColor:[STSystemHelper colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        [hotButton.layer setBorderWidth:1.];
        [hotButton.layer setBorderColor:[STSystemHelper colorWithHexString:@"#F6F8FB"].CGColor];
        [hotButton setBackgroundColor:[STSystemHelper colorWithHexString:@"#ffffff"]];
        hotButton.layer.cornerRadius = hotButton.height/2.0;
        hotButton.layer.masksToBounds = YES;
        hotButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [hotButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        //button放入数组
        [arr_button addObject:hotButton];
    }
    /*****排列（设置热键的位置）*****/
    int currentWidth = 0; //控制几个button按钮的宽度
    int currentY = 0;
    int currentX = 0;
    for (int i = 0; i < arr_button.count; i++) {
        //取出button
        UIButton *button = arr_button[i];
        //确定按钮位置
        button.frame = CGRectMake(15+currentX*currentWidth, currentY*(button.height + 10), button.width, 30);
        currentWidth +=10 + button.width;
        currentX=1;
        if (currentWidth+15-8 > width) {
            //开始下一行
            currentWidth = 0;
            currentX = 0;
            currentY++;
            //最后一个不算
            i--;
        }
        
    }
    return arr_button;
}
/*
 * 点击热词
 */
-(void)clickButton:(UIButton*)button{
    NSLog(@"%@",button.titleLabel.text);
    if (_delegate && [_delegate respondsToSelector:@selector(tapContent:)]) {
        [_delegate tapContent: button.titleLabel.text];
    }
}
/*
 * 计算文本宽度
 *
 * @param checkStr 字符
 *
 * @param size1 尺寸
 *
 * @param font 字体大小
 */
-(float)getNeededWidth:(NSString*)checkStr andSize:(CGSize)size1 andFont:(CGFloat)font
{
    CGSize size = CGSizeMake(MAXFLOAT,size1.height);
    NSString *s = checkStr;
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:font]};
    
    CGSize retSize = [s boundingRectWithSize:size
                                     options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil].size;
    return retSize.width;
}
@end
