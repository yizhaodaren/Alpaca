//
//  NetRequest.m
//  Alpaca
//
//  Created by xujin on 2018/11/16.
//  Copyright © 2018年 Moli. All rights reserved.
//

#import "NetRequest.h"
#import "UIViewController+NoNetwork.h"
#import "BSModel.h"

@implementation NetRequest

-(void)baseNetwork_startRequestWithcompletion:(RequestSuccessBlock)completion failure:(RequestFaileBlock)failure{
    
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [[[GlobalManager shareGlobalManager] global_currentViewControl] hiddenNoNetwork];
        
        NSLog(@"%@ \n %@",request,request.responseObject);
        
        Class modelClass =self.modelClass;
        // 获取数据类型
        id resBody = request.responseObject[@"resBody"];
        
        
        
        BSModel *model;
        
        if (resBody && [resBody isKindOfClass:[NSDictionary class]]) {//字典
            model = [modelClass mj_objectWithKeyValues:resBody];
            model.code = [request.responseObject[@"code"] integerValue];
            model.message = request.responseObject[@"message"];
            model.total = [request.responseObject mol_jsonInteger:@"total"];
            
        }else{
            model =[self.modelClass mj_objectWithKeyValues:request.responseObject];
        }
        
        if (completion) {
            completion(request,model,model.code,model.message);
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@ \n %@",request, request.error.localizedDescription);
        if (failure) {
            failure(request);
        }
        
    }];
    
}


@end
