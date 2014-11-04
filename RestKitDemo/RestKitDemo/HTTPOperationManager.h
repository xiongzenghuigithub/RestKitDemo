

#import <Foundation/Foundation.h>



@interface HTTPOperationManager : NSObject

- (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;

@end
