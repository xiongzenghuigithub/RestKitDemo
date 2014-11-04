

#import "MyLogger.h"


////定义日志显示的级别
//#ifdef DEBUG
////static const int ddLogLevel = LOG_LEVEL_VERBOSE; //LOG_LEVEL_VERBOSE级别以下所有日志都会看见
//static const int ddLogLevel = LOG_LEVEL_WARN; //设置自定义log级别以下日志都可以看见
//#else
//static const int ddLogLevel = LOG_LEVEL_OFF; //发布版本时, 直接关闭所有日志输出
//#endif

@implementation MyLogger

//+ (void)initialize {
//    [DDLog addLogger:[DDTTYLogger sharedInstance]];
//    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
//    
//    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
//    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
//    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor purpleColor] backgroundColor:nil forFlag:LOG_FLAG_WARN];
//}

+ (void)TTYLogError:(NSString *)info {
//    DDLogError(info);
}

+ (void)TTYLogInfo:(NSString *)info {
//    DDLogInfo(info);
}

+ (void)TTYLogWarn:(NSString *)info {
//    DDLogWarn(info);
}

+ (void)TTYLogErrorTarget:(id)target {
//    DDLogError(@"%@", target);
}

+ (void)TTYLogInfoTarget:(id)target {
//    DDLogInfo(@"%@", target);
}

+ (void)TTYLogWarnTarget:(id)target {
//    DDLogWarn(@"%@", target);
}

@end
