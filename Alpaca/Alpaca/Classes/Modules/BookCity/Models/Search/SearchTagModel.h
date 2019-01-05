//
//  SearchTagModel.h
//  freestyleAction
//
//  Created by ACTION on 2017/12/20.
//  Copyright © 2017年 xiaoling li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchTagModel : NSObject

//"hot_word" = AI;
//id = 3;
//listorder = 2;
//state = 1;

@property (nonatomic,copy)NSString *hot_word;
@property (nonatomic,copy)NSString *listorder;
@property (nonatomic,copy)NSString *state;
@property (nonatomic,copy)NSString *_id;


@end
