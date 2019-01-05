//
//  FileManager.m
//  CanCan
//
//  Created by xiaolong li on 16/12/12.
//  Copyright © 2016年 xingjian. All rights reserved.
//

#define FILE_MANAGER           [NSFileManager defaultManager]

#import "FileManager.h"

@implementation FileManager

static FileManager *instance=nil;  //单例对象


/**
 * 获取document路径
 */
-(NSString *)getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);//得到documents的路径，为当前应用程序独享
    NSString *documentD = [paths lastObject];
    return documentD;
}
/**
 * 在iOS环境下，只有document directory 是可以进行读写的。
 * 在写程式时用的那个Resource资料夹底下的东西都是read-only。
 * 因此，建立的资料库要放在document 资料夹下
 *
 */
- (NSString *)fullFileName:(NSString *)shortFileName {
    //返回一个绝对路径用来存放我们需要储存的文件
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths lastObject];
    
    NSString *file = [documentDirectory stringByAppendingPathComponent:shortFileName];
    return file;
}
/**
 * 创建文件夹
 * directoryName:全路径文件夹名
 */

-(BOOL) createDirectory:(NSString *) directoryName {
    BOOL bRet = NO;
    @try {
        NSFileManager * _fileManager = FILE_MANAGER;
        
        if(![_fileManager fileExistsAtPath:directoryName])
        {
            bRet =  [_fileManager createDirectoryAtPath:directoryName withIntermediateDirectories:YES attributes:nil error:nil];
            return bRet;
        }
        
        bRet = YES;
    } @catch (NSException *exception) {
        NSLog(@"createPath: 创建文件夹失败 %@: %@", [exception name], [exception reason]);
    }
    @finally
    {
        return bRet;
    }
    
}


/**
 * 判断文件是否存在
 * fileName:文件的相对路径［相对Documents路径而言］，如：logs/log20150119.log
 */
- (BOOL)isFileExists:(NSString *)fileName {
    BOOL bRet = NO;
    NSFileManager *fileManager =nil;
    NSString *file = nil;
    @try {
        fileManager = [NSFileManager defaultManager];
        file = [self fullFileName:fileName];
        bRet =[fileManager fileExistsAtPath:file];
    } @catch (NSException *exception) {
        NSLog(@"isFileExists: 判断文件是否存在失败 %@: %@", [exception name], [exception reason]);
    }
    @finally
    {
        return bRet;
    }
    
}
/**
 * 创建文件
 * fileName: 全路径文件名
 * shouldOverwrite: 是否覆盖已经存在的同名文件
 */
- (BOOL)createFile:(NSString *)fileName overwrite:(BOOL)shouldOverwrite {
    BOOL bRet = NO;
    //NSString *file=nil;
    NSFileManager *fileManager =nil;
    
    @try {
        fileManager = [NSFileManager defaultManager];
        
        //只有文件不存在或者可以覆盖时，才执行创建
        if (shouldOverwrite || ![fileManager fileExistsAtPath:fileName]) {
            bRet = [fileManager createFileAtPath:fileName contents:nil attributes:nil];
            NSLog(@"创建文件 (%@) %@", fileName, bRet ? @"成功" : @"失败");
        } else {
            bRet = YES;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"createFile: 创建文件失败 %@: %@", [exception name], [exception reason]);
    }
    @finally
    {
        return bRet;
    }
    
}
/**
 * 删除文件
 * fileName:文件相对路径名(包括docments下的多级路径及叶子节点[文件名称])
 */
- (BOOL)removeFile:(NSString *)fileName {
    BOOL bRet = NO;
    NSString *file=nil;
    NSFileManager *fileManager =nil;
    @try {
        fileManager = [NSFileManager defaultManager];
        file = [self fullFileName:fileName];
        //需要先判断文件是否存在
        bRet = [self isFileExists:fileName];
        if (bRet == NO) {
            NSLog(@"removeFile: 文件 %@: 不存在", file);
            bRet = YES;
        } else {
            bRet = [fileManager removeItemAtPath:file error:nil];
        }
    } @catch (NSException *exception) {
        NSLog(@"removeFile: 删除文件失败 %@: %@", [exception name], [exception reason]);
    } @finally {
        return bRet;
    }
    
}
/**
 * 写内容到文件,如果是中文，需要转码：  NSData *contents=[content dataUsingEncoding:NSUnicodeStringEncoding];
 * fileName: 文件相对路径
 * contents: 内容
 * shouldAppend:是否追加的方式保存内容
 */
- (BOOL)writeFile:(NSString *)fileName contents:(NSData *)contents append:(BOOL)shouldAppend {
    BOOL bRet = NO;
    NSString *fullName = nil;
    NSFileHandle *fileHandle = nil;
    
    @try {
        //如果文件不存在，则创建
        if (![self isFileExists:fileName] || !shouldAppend) {
            [self createFile:fileName overwrite:YES];
        }
        fullName = [self fullFileName:fileName];
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:fullName];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:contents];
        [fileHandle closeFile];
        bRet = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"writeFile: 写内容到文件失败 %@: %@", [exception name], [exception reason]);
        
    }
    @finally {
        return bRet;
    }
    
}
/**
 * 获取指定路径下的文件列表
 * path:绝对路径
 */
- (NSArray *)getSubFiles:(NSString *)path{
    NSArray *files=nil;
    NSFileManager *fileManager =nil;
    @try {
        //扫描指定路径下的文件,如果文件名不保护以上三个日期，则删除
        fileManager = [NSFileManager defaultManager];
        files = [fileManager subpathsAtPath: path ];
        fileManager =nil;
    }
    @catch (NSException *exception) {
        NSLog(@"writeFile: 写内容到文件失败 %@: %@", [exception name], [exception reason]);
    }
    @finally {
        return files;
    }
}
/**
 * 实现单例方法,线程安全的
 * 调用方式
 */
+(FileManager *)getInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [self new];//该方法会调用 allocWithZone   [[super allocWithZone:NULL] init]
        
    });
    
    return instance;
}


@end
