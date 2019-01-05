//
//  FileManager.h
//  CanCan
//
//  Created by xiaolong li on 16/12/12.
//  Copyright © 2016年 xingjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

/**
 * 获取document路径
 */
-(NSString *)getDocumentDirectory;

/**
 * 创建文件夹
 */
-(BOOL) createDirectory:(NSString *) directoryName;

/**
 转换短文件名为全路径文件名
 如：　"mycache/user/icon.png" -> "/Users/zhoujun/Library/Application Support/iPhone Simulator/7.1/Applications/ABCE2119-E864-4492-A3A9-A238ADA74BE5/Documents/mycache/user/icon.png".
 @return full file name.
 */
- (NSString *)fullFileName:(NSString *)shortFileName;

/**
 文件是否存在
 @param fileName file path and file name, e.g. "mycache/user/icon.png".
 @return YES if exists, NO otherwise.
 */
- (BOOL)isFileExists:(NSString *)fileName;

/**
 创建文件，如果已经存在，则自动覆盖
 @param fileName fileName file path and file name, e.g. "mycache/user/icon.png".
 @param shouldOverwrite YES:if the file exists then overwirte it, NO:if the file exists then do nothing
 */
-(BOOL)createFile:(NSString *)fileName overwrite:(BOOL)shouldOverwrite;

/**
 将内容写入文件，如果文件不存在，则自动创建
 @param fileName fileName file path and file name, e.g. "mycache/user/icon.png".
 @param contents the contents you wish to write
 @param shouldAppend YES:append contents to original file; NO:overwrite the original file
 */
- (BOOL)writeFile:(NSString *)fileName contents:(NSData *)contents append:(BOOL)shouldAppend;

/**
 删除文件
 @param fileName file path and file name, e.g. "mycache/user/icon.png".
 */
- (BOOL)removeFile:(NSString *)fileName;

/**
 * 获取指定路径下的文件列表
 * path:绝对路径
 */
- (NSArray *)getSubFiles:(NSString *)path;

/**
 * 实现单例方法,线程安全的
 * 调用方式
 */
+(FileManager *)getInstance;


@end
