//
//  E_ColorModel.h
//  Alpaca
//
//  Created by xujin on 2018/12/5.
//  Copyright © 2018年 Moli. All rights reserved.
//

typedef NS_ENUM(NSInteger,E_ColorType) {
    E_ColorType_Hex,     //16 进制色值
    E_ColorType_Image,   //图片背景
    E_colorType_Night,   //夜间模式
};

#import "BSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface E_ColorModel : BSModel
@property (nonatomic,assign)  E_ColorType colorType;
@property (nonatomic,strong)  NSString *colorD;
@property (nonatomic,strong)  NSString *colorS;
@property (nonatomic,strong)  NSString *colorB;
@property (nonatomic,strong)  NSString *smallImageD;
@property (nonatomic,strong)  NSString *smallImageS;

@property (nonatomic,strong)  NSString *bigImage;
@end

NS_ASSUME_NONNULL_END
