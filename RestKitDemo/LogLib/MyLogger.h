
#import <Foundation/Foundation.h>

@interface MyLogger : NSObject

/**
 *  发送日志语句到控制台
 */
+ (void)TTYLogError:(NSString *)info;
+ (void)TTYLogInfo:(NSString *)info;
+ (void)TTYLogWarn:(NSString *)info;

+ (void)TTYLogErrorTarget:(id)target;
+ (void)TTYLogInfoTarget:(id)target;
+ (void)TTYLogWarnTarget:(id)target;

@end
