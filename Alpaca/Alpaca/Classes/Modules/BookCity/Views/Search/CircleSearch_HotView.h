//
//  CircleSearch_HotView.h
//  USchoolCircle
//  热词板 由CircleSearch_SearchBarView类调用
//  Created by raytheon on 16/2/19.
//  Copyright © 2016年 uskytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleSearch_HotViewDelegate<NSObject>

-(void)tapContent:(NSString *)content;
-(void)tapKeyboardEvent;

@end

@interface CircleSearch_HotView : UIView
{
    void (^_block)(CGRect rect,NSString *action,NSString *content);
}

@property (nonatomic,weak)id<CircleSearch_HotViewDelegate>delegate;

//初始化
-(instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)arr content:(void(^)(CGRect rect,NSString *action,NSString *content))block;

-(void)creatAndArrangeHot:(NSArray *)arr;
@end
