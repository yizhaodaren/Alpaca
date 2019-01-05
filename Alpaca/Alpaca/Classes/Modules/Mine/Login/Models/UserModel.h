//
//  UserModel.h
//  Alpaca
//
//  Created by xujin on 2018/11/16.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "BSModel.h"
#import "UserChannelModel.h"
#import "UserWalletModel.h"
#import "UserTodayVO.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserModel : BSModel
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign)NSInteger inviteSign; //1 不显示输入好友邀请码 0显示输入好友邀请码
@property (nonatomic, assign)NSInteger newBagSign; //0未领取 1已领取
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) UserChannelModel *userChannelVO;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *birthDay;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy) NSString *signInfo;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *userUuid; // 用户id
@property (nonatomic, assign)NSInteger uuid;

@property (nonatomic, assign) NSInteger isFriend;  // 0未关注  1 已关注 2 相互关注

@property (nonatomic, assign) NSInteger attentionCount;  // 关注数量
@property (nonatomic, assign) NSInteger fansCount;  // 粉丝数量
@property (nonatomic, assign) NSInteger beFavorCount;  // 获赞数量

@property (nonatomic, assign) NSInteger favorCount;  // 喜欢数量
@property (nonatomic, assign) NSInteger storyCount;  // 作品数量
@property (nonatomic, assign) NSInteger rewardCount;  // 悬赏数量

@property (nonatomic, copy) NSString *accessToken; // token

@property (nonatomic, strong)UserWalletModel *userWalletVO; //用户钱包

@property (nonatomic, strong)UserTodayVO *userTodayVO;
@end

NS_ASSUME_NONNULL_END
