//
//  E_EveryChapter.m
//  E_Reader
//
//  Created by 阿虎 on 14-8-8.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "E_EveryChapter.h"

@implementation E_EveryChapter

+(id)getLocalModelWithURL:(NSURL *)url
{
    NSString *key = [url.path lastPathComponent];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([[key pathExtension] isEqualToString:@"txt"]) {
        LSYReadModel *model = [[LSYReadModel alloc] initWithContent:[LSYReadUtilites encodeWithURL:url]];
        model.resource = url;
        [LSYReadModel updateLocalModel:model url:url];
        return model;
    }
    else if ([[key pathExtension] isEqualToString:@"epub"]){
        NSLog(@"this is epub");
        LSYReadModel *model = [[LSYReadModel alloc] initWithePub:url.path];
        model.resource = url;
        [LSYReadModel updateLocalModel:model url:url];
        return model;
    }
    else{
        @throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
    }
}

@end
