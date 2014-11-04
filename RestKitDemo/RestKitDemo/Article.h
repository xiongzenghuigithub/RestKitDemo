
#import <Foundation/Foundation.h>
@class Author;


@interface Article : NSObject


@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * body;
//@property (nonatomic, strong)Author * author;
@property (nonatomic, copy) NSString* author;
@property (nonatomic) NSDate*   publicationDate;

@end
