//
//  E_ContantFile.h
//  WFReader
//
//  Created by 阿虎 on 14/12/25.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#ifndef WFReader_E_ContantFile_h
#define WFReader_E_ContantFile_h

#define OPEN @"open"
#define SAVEPAGE @"savePage"
#define SAVETHEME @"saveTheme"
#define SAVETHEMELAST @"saveThemeLast"
#define offSet_x 15
#define offSet_y 44
#define FONT_SIZE @"FONT_SIZE"
#define LINE_SPACE @"LINE_SPACE"
#define COLOR_CONTENT @"COLOR_CONTENT"
#define BRIGHTNESS @"BRIGHTNESS"
#define ERBRIGHTNESS_Read @"ERBRIGHTNESS_Read"
#define CHAPTER_NAME @"CHAPTER_NAME"
#define kBottomBarH 150

#define FilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define epubBookName @"倚天屠龙记"
#define kScreenW [UIScreen mainScreen].bounds.size.width


#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))

#endif
