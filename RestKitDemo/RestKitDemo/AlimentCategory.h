

#import <Foundation/Foundation.h>
#import "CategoryIcon.h"

@interface AlimentCategory : NSObject

@property (nonatomic, copy)NSString * cid;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * pluralName;
@property (nonatomic, copy)NSString * shortName;
@property (nonatomic, strong)CategoryIcon * icon;
@property (nonatomic, strong)NSMutableArray * categories;

@end
