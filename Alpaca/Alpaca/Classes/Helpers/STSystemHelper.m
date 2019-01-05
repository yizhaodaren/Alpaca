//
//  STSystemHelper.m
//  Faith in life
//
//  Created by 王聪 on 16/4/19.
//  Copyright © 2016年 allan. All rights reserved.
//

#import "STSystemHelper.h"
#import "sys/utsname.h"
#import "UUID.h"
#import "Reachability.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation STSystemHelper

+ (NSString *)getDeviceName
{
    NSString *strName = [[UIDevice currentDevice] name];
    
//    NSLog(@"%@",strName);
    return strName;
}

+ (NSString *)getIphoneName
{
    NSString *phoneName = [[UIDevice currentDevice] model];
    
    return phoneName;
}

+ (NSString *)getApp_version
{
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = [NSString stringWithFormat:@"%@", infoDict[@"CFBundleShortVersionString"]];
    return currentVersion;
}

+ (NSString *)getApp_bundleid {
    NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
    NSString *currentBundleId = [NSString stringWithFormat:@"%@", infoDict[@"CFBundleIdentifier"]];
    return currentBundleId;
}

+ (NSString *)getDeviceID
{
//    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
//    
//    return identifierForVendor;
    
    NSString *gId = [UUID getUUID];
    return gId;
}

// 返回用户ID
+ (NSString *)getUserID
{
//    NSString *uidStr = [NSString stringWithFormat:@"%zd",[DataCenter shareInstance].uid];
//    return uidStr;
    return nil;
}

+ (void)getBatteryMoniter   // 获取系统电量
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIDeviceBatteryLevelDidChangeNotification
     object:nil queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *notification) {
         // Level has changed
         
//         float currentBattery = [UIDevice currentDevice].batteryLevel;
//         
         // 电量在这个区间，尝试发送数据到服务器
//         if (0.50 <= currentBattery <= 0.70) {
//             [STTracker isShouldSend];
//         }
     }];
}


+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

+ (NSString *)iphoneNameAndVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)getDeviceModel
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
    
}


+ (NSString *)getHardParam  // 返回CPU类型
{
    NSMutableString *cpu = [[NSMutableString alloc] init];
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    // values for cputype and cpusubtype defined in mach/machine.h
    if (type == CPU_TYPE_X86)
    {
        [cpu appendString:@"x86 "];
        // check for subtype ...
        
    } else if (type == CPU_TYPE_ARM)
    {
        [cpu appendString:@"ARM"];
        [cpu appendFormat:@",Type:%d",subtype];
    }
    return cpu;
}

+ (NSString *)getTelephonyInfo     // 获取运营商信息
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    
    return mCarrier;
}

+ (NSString *)getIOSID
{
    NSString *strSysName = [[UIDevice currentDevice] systemName];
    return strSysName;
}

+ (NSString *)getiOSSDKVersion
{
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
    return strSysVersion;
}


// 获得设备总内存
+ (NSUInteger)getTotalMemoryBytes
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, HW_PHYSMEM};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results/1024/1024;
}

// 异常收集处理
void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
}

// 写入异常信息
-(void)writeACrashMessage
{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

// 获取运行中的进程
//+ (NSArray *)getRunningProcesses {
//    
//    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
//    size_t miblen = 4;
//    
//    size_t size;
//    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
//    
//    struct kinfo_proc * process = NULL;
//    struct kinfo_proc * newprocess = NULL;
//    
//    do {
//        
//        size += size / 10;
//        newprocess = realloc(process, size);
//        
//        if (!newprocess){
//            
//            if (process){
//                free(process);
//            }
//            
//            return nil;
//        }
//        
//        process = newprocess;
//        st = sysctl(mib, miblen, process, &size, NULL, 0);
//        
//    } while (st == -1 && errno == ENOMEM);
//    
//    if (st == 0){
//        
//        if (size % sizeof(struct kinfo_proc) == 0){
//            int nprocess = size / sizeof(struct kinfo_proc);
//            
//            if (nprocess){
//                
//                NSMutableArray * array = [[NSMutableArray alloc] init];
//                
//                for (int i = nprocess - 1; i >= 0; i--){
//                    
//                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
//                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
//                    
//                    NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, nil]
//                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", nil]];
//                    [array addObject:dict];
//                }
//                
//                free(process);
//                return array;
//            }
//        }
//    }
//    
//    
//    return nil;
//}


// 获取网络类型
+(NSString*)getNetworkType
{
        /**
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyGPRS          __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyEdge          __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyWCDMA         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyHSDPA         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyHSUPA         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMA1x        __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMAEVDORev0  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMAEVDORevA  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyCDMAEVDORevB  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyeHRPD         __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     CORETELEPHONY_EXTERN NSString * const CTRadioAccessTechnologyLTE           __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_7_0);
     **/
    NSString *netconnType = @"";
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            
            netconnType = @"no network";
        }
            break;
            
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}

//必须在有网的情况下才能获取手机的IP地址
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

// 用于数字转换成万  eg:1.1万
+ (NSString *)getNum:(NSInteger)num{
    NSString *string;
    if (num>10000) {
    
        string =[NSString stringWithFormat:@"%ld.%ld",num/10000,num%10000%10000];
    
        CGFloat f =roundf(string.floatValue*10)/10;
        
        return string =[NSString stringWithFormat:@"%.1f万",f];
        
    }else{
        return string =[NSString stringWithFormat:@"%ld",num];
    }
}

#pragma mark -
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


///三个文字一个逗号
+(NSString *)countNumAndChangeformat:(NSString *)num
{
    NSString * string = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithLongLong:num.longLongValue]
                                                         numberStyle:NSNumberFormatterDecimalStyle];
    return string;
    
    
}

///NSMutableAttributedString
+(NSMutableAttributedString *)attributedContent:(NSString *)content color:(UIColor *)color font:(UIFont *)font{
    if (!content) {
        return [NSMutableAttributedString new];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content?content:@""];
//    if (color) {
//        str.yy_color = color;
//    }
//    
//    if (font) {
//       str.yy_font = font;
//    }
    return str;
}

/**
 判断是否是手机号格式
 
 @param mobileNum 输入手机号字符串对象
 
 @return 返回Bool值，yes，表示是手机号，NO，表示不是手机号
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString *regex = @"1[0-9]{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:mobileNum];
}

+ (NSInteger)getHour:(NSInteger)timerInterval{
    NSInteger hours =0;
    if (timerInterval) {
        
        hours =timerInterval / 60/60%24 ;
    }
    return hours;
}

+ (NSInteger)getMinute:(NSInteger)timerInterval{
    
    NSInteger minute =0;
    if (timerInterval) {
        minute =((int)timerInterval / 60) % 60;
    }
    return minute;
}

+ (NSInteger)getSecond:(NSInteger)timerInterval{
    
    NSInteger second =0;
    if (timerInterval) {
        second =timerInterval % 60;
    }
    return second;
   
}

+ (NSString *)getNumberString:(NSInteger)num{
    num = (num<=0)?0:num;
    
    if (num<10) {
        return [NSString stringWithFormat:@"0%ld",num];
    }else{
        return [NSString stringWithFormat:@"%ld",num];
    }
    
}

+ (int)getCurrentBatteryLevel
{
    
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive||app.applicationState==UIApplicationStateInactive) {
        Ivar ivar=  class_getInstanceVariable([app class],"_statusBar");
        id status  = object_getIvar(app, ivar);
        for (id aview in [status subviews]) {
            int batteryLevel = 0;
            for (id bview in [aview subviews]) {
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >=6.0)
                {
                    
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if(ivar)
                    {
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        //这种方式也可以
                        /*ptrdiff_t offset = ivar_getOffset(ivar);
                         unsigned char *stuffBytes = (unsigned char *)(__bridge void *)bview;
                         batteryLevel = * ((int *)(stuffBytes + offset));*/
                        NSLog(@"电池电量:%d",batteryLevel);
                        if (batteryLevel > 0 && batteryLevel <= 100) {
                            return batteryLevel;
                            
                        } else {
                            return 0;
                        }
                    }
                    
                }
                
            }
        }
    }
    
    return 0;
}


+(int)getBatteryQuantity{
    UIDevice * device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    CGFloat tempV = [device batteryLevel];
    if (tempV > 0 && tempV <= 1) {
        
      int interValue = roundf(tempV * 100);
        return interValue;
    }else{
        return 0;
    }
 
    
}

/**
 *   //设备相关信息的获取
 NSString *strName = [[UIDevice currentDevice] name];
 NSLog(@"设备名称：%@", strName);//e.g. "My iPhone"
 
 NSString *strId = [[UIDevice currentDevice] uniqueIdentifier];
 NSLog(@"设备唯一标识：%@", strId);//UUID,5.0后不可用
 
 NSString *strSysName = [[UIDevice currentDevice] systemName];
 NSLog(@"系统名称：%@", strSysName);// e.g. @"iOS"
 
 NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
 NSLog(@"系统版本号：%@", strSysVersion);// e.g. @"4.0"
 
 NSString *strModel = [[UIDevice currentDevice] model];
 NSLog(@"设备模式：%@", strModel);// e.g. @"iPhone", @"iPod touch"
 
 NSString *strLocModel = [[UIDevice currentDevice] localizedModel];
 NSLog(@"本地设备模式：%@", strLocModel);// localized version of model
 */


@end
