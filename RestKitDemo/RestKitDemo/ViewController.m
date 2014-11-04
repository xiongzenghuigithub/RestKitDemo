
#import "ViewController.h"
#import <RestKit/RestKit.h>

#import "Venue.h"
#import "PoiItem.h"
#import "Article.h"
#import "Author.h"
#import "AlimentCategory.h"
#import "CategoryIcon.h"

#import "MyLogger.h"
#import "CocoaLumberjack.h"


#import "HTTPOperationManager.h"

#import "DPAPI.h"
#import "DPRequest.h"

#ifdef DEBUG
    static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
    static const int ddLogLevel = LOG_LEVEL_OFF;
#endif


@interface ViewController () <DPRequestDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBtn];
}

- (void)addBtn {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 64, 300, 50);
    [btn setTitle:@"访问网络json并转化成实体对象1" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn addTarget:self action:@selector(loadVenues) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, CGRectGetMaxY(btn.frame), 300, 50);
    [btn1 setTitle:@"访问网络json并转化成实体对象2" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 addTarget:self action:@selector(loadPOIItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(10, CGRectGetMaxY(btn1.frame), 300, 50);
    [btn2 setTitle:@"load articles" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor blueColor]];
    [btn2 addTarget:self action:@selector(loadCategories) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)loadVenues {
    
    //    https://api.Foursquare.com/v2/venues/search?ll=37.33,-122.03&categoryId=4bf58dd8d48988d1e0931735
    
    // initialize AFNetworking HTTPClient
    NSURL * baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager * objManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping addAttributeMappingsFromArray:@[@"name"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:venueMapping
                                                method:RKRequestMethodGET
                                                pathPattern:@"/v2/venues/search"
                                                keyPath:@"response.venues"
                                                statusCodes:[NSIndexSet indexSetWithIndex:200]
                                                ];
    [objManager addResponseDescriptor:responseDescriptor];
    
    NSString *latLon = @"37.33,-122.03";
    NSString *clientID = kCLIENTID;
    NSString *clientSecret = kCLIENTSECRET;
    
    NSDictionary *queryParams = @{@"ll" : latLon,
                                  @"client_id" : clientID,
                                  @"client_secret" : clientSecret,
                                  @"categoryId" : @"4bf58dd8d48988d1e0931735",
                                  @"v" : @"20140118"
                                  };
    
    [objManager getObjectsAtPath:@"/v2/venues/search"
                      parameters:queryParams
                         success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          for (int i = 0; i < [mappingResult.array count]; i++) {
                              Venue * v = mappingResult.array[i];
                              DDLogInfo(@"name = %@\n" , [v name]);
                          }
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                      }];
}

- (void)loadPOIItem{
    
    /*
        http://uat.api.openrice.com.cn/api/Sr2Api.htm?app_type=orapp2013iphonev4cn&app_ver=4.1.0&api_ver=401&api_token=z0530ZU8f9g8uR1BhiAx1SwQ2fw%3D91a4f2ed1714144975089198511&region_id=7&response_type=json&method=or.poi.getdetail&poi_id=470794&auth_token=6D05A1390E6E099D03D6F0A157204065%7CL1OpGVfVKflPdiv7z8MHemQfzSY%3D8eb656cf17141416360599338805159311147%7CCN%7C5159311147%7C5159311147&api_sig=DC29CA0389E23236568F5AB267E5AF96
     */
    
    NSURL * baseURL = [NSURL URLWithString:@"http://uat.api.openrice.com.cn"];
    AFHTTPClient * client = [AFHTTPClient clientWithBaseURL:baseURL];
    RKObjectManager * objManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    RKObjectMapping * poiMapping = [RKObjectMapping mappingForClass:[PoiItem class]];
    [poiMapping addAttributeMappingsFromDictionary:@{
                                        @"AddressLang1":@"AddressLang1",
                                        @"NameLang1":@"NameLang1",
                                        @"PoiUrl":@"PoiUrl"
                                                     }];
    RKResponseDescriptor * resDes = [RKResponseDescriptor responseDescriptorWithMapping:poiMapping method:RKRequestMethodGET pathPattern:@"/api/Sr2Api.htm" keyPath:@"response.poiItem" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objManager addResponseDescriptor:resDes];
    
    NSDictionary * queryParams =  @{
                  @"app_type":@"orapp2013iphonev4cn",
                  @"app_ver":@"4.1.0",
                  @"api_ver":@"401",
                  @"api_token":@"z0530ZU8f9g8uR1BhiAx1SwQ2fw%3D91a4f2ed1714144975089198511",
                  @"region_id":@"7",
                  @"response_type":@"json",
                  @"method":@"or.poi.getdetail",
                  @"poi_id":@"470794",
                  @"auth_token":@"6D05A1390E6E099D03D6F0A157204065%7CL1OpGVfVKflPdiv7z8MHemQfzSY%3D8eb656cf17141416360599338805159311147%7CCN%7C5159311147%7C5159311147",
                  @"api_sig":@"DC29CA0389E23236568F5AB267E5AF96"
                                  };
    
    [objManager getObjectsAtPath:@"/api/Sr2Api.htm" parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [MyLogger TTYLogInfo:[NSString stringWithFormat:@"mappingResult.array = %@" ,mappingResult.array]];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)loadArticles {
    
//    RKObjectMapping * articleMapping = [RKObjectMapping mappingForClass:[Article class]];
//    [articleMapping addAttributeMappingsFromDictionary:@{@"title": @"title",
//                                                         @"body": @"body",
//                                                         @"author": @"author",
//                                                         @"publication_date": @"publicationDate"}];
//    
//    NSURL * baseURL = [NSURL URLWithString:@"http://192.168.1.10:8080/articles"];
//    NSURLRequest * req = [NSURLRequest requestWithURL:baseURL];
//    
//    RKResponseDescriptor * resDes = [RKResponseDescriptor responseDescriptorWithMapping:articleMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    
//    RKObjectRequestOperation * op = [[RKObjectRequestOperation alloc] initWithRequest:req responseDescriptors:@[resDes]];
//    
//    [op setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        NSArray * articles = [mappingResult array];
//        
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        [MyLogger TTYLogError:[error localizedDescription]];
//    }];
//    
//    [op start];
    
    [self loadDealList];
    
}

- (void)loadDealList {
    
    NSString * url = [DPRequest serializeURL:@"http://api.dianping.com/v1/deal/get_all_id_list" params:@{@"city":@"北京"}];
    
    
    DPAPI * api = [[DPAPI  alloc] init];
    [api requestWithURL:@"v1/business/find_businesses" params:@{@"city":@"北京"} delegate:self];
}


- (void)request:(DPRequest *)request didReceiveResponse:(NSURLResponse *)response {

}

- (void)request:(DPRequest *)request didReceiveRawData:(NSData *)data {
    
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    [MyLogger TTYLogInfo:[NSString stringWithFormat:@"ViewController: didReceiveRawData: dict = %@" ,data]];
}



- (void)loadCategories {
    
    //1. 添加服务器json与本地实体类映射
    
    //1)实体1
    RKObjectMapping * categoryMapping = [RKObjectMapping mappingForClass:[AlimentCategory class]];
    [categoryMapping addAttributeMappingsFromDictionary:@{@"id":@"cid",@"name":@"name",@"pluralName":@"pluralName",@"shortName":@"shortName",@"":@"",}];
    
    //2)实体2
    RKObjectMapping * iconMapping = [RKObjectMapping mappingForClass:[CategoryIcon class]];
    [iconMapping addAttributeMappingsFromDictionary:@{@"prefix":@"prefix",@"suffix":@"suffix"}];
    
    //3)实体1与实体2的关联关系
    RKRelationshipMapping * relationship1 = [RKRelationshipMapping relationshipMappingFromKeyPath:@"icon" toKeyPath:@"icon" withMapping:iconMapping];
    
    [categoryMapping addPropertyMapping:relationship1];
    
    //4)数组属性
    RKRelationshipMapping * relateship2 = [RKRelationshipMapping relationshipMappingFromKeyPath:@"categories" toKeyPath:@"categories" withMapping:categoryMapping];
    [categoryMapping addPropertyMapping:relateship2];
    
    
    NSURL * baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
    AFHTTPClient * client = [AFHTTPClient clientWithBaseURL:baseURL];
    
    RKObjectManager * objManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKResponseDescriptor * resDes = [RKResponseDescriptor responseDescriptorWithMapping:categoryMapping method:RKRequestMethodGET pathPattern:@"/v2/venues/categories" keyPath:@"response.categories" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objManager addResponseDescriptor:resDes];
    
    //2. 获取制定的子路径path的服务器json
    //1) 请求参数
    NSDictionary * paramDict = @{
                                 @"client_id":kCLIENTID,
                                 @"client_secret":kCLIENTSECRET,
                                 @"v":@"20141028"
                                 };
    
    RKObjectManager * objManager2 = [RKObjectManager sharedManager];
    [objManager2 getObjectsAtPath:@"/v2/venues/categories" parameters:paramDict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        for (int i = 0; i < [mappingResult count]; i++) {
            AlimentCategory * category = [[mappingResult array] objectAtIndex:i];
            CategoryIcon * icon = [category icon];
            
            DDLogWarn(@"-------------------------------------------------");
            DDLogInfo(@"Category: id = %@, name = %@", [category cid], [category name]);
            DDLogInfo(@"Icon: prefix = %@, suffix = %@", [icon prefix], [icon suffix]);
            
            for (int i = 0; i < [[category categories] count]; i++) {
                AlimentCategory * child = [[category categories] objectAtIndex:i];
                DDLogInfo(@"当前分类 - %@ 的第%d个子分类 - %@",[category name], i+1 , [child name]);
            }
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [MyLogger TTYLogInfo:[NSString stringWithFormat:@"error = %@", [error localizedDescription]]];
    }];
}

//修改服务器数据(添加、删除、修改)
- (void)modifyServerData {
    
    //1. 设置BaseURL
    NSURL * baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
    AFHTTPClient * client = [AFHTTPClient clientWithBaseURL:baseURL];
    RKObjectManager * objManager = [RKObjectManager sharedManager];
    if (objManager == nil) {
        objManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    }
    
    //2. Response Mapping Description
    RKObjectMapping * venueResMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueResMapping addAttributeMappingsFromDictionary:@{@"name":@"name"}];
    RKResponseDescriptor * resDes = [RKResponseDescriptor responseDescriptorWithMapping:venueResMapping method:RKRequestMethodAny pathPattern:@"/v2/venues/search" keyPath:@"response.venues" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    //3. Request Mapping Description
    RKObjectMapping * venueRequestMapping = [RKObjectMapping requestMapping];
    [venueRequestMapping addPropertyMappingsFromArray:@[@"name"]];
    RKRequestDescriptor * reqDes = [RKRequestDescriptor requestDescriptorWithMapping:venueRequestMapping objectClass:[Venue class] rootKeyPath:@"v2/venues" method:RKRequestMethodAny];
    
    //4. 将2个请求类型的mapping的Description 添加到 RKObjectManager
    [objManager addResponseDescriptor:resDes];
    [objManager addRequestDescriptor:reqDes];
    
    //5. 对实体对象添加、删除、修改操作
    
    NSDictionary * paramDict = @{@"client_id":kCLIENTID,
                                 @"client_secret":kCLIENTSECRET
                                 };
    
    //1)添加 -- path = v2/venues/post(post是服务器指定的 v2/venues 下得一个对应添加实体的子路径。 修改和删除的子路径同意)
    Venue * v = [[Venue alloc] init];
    [v setName:@"新添加的Venue"];
    [objManager postObject:v path:@"v2/venues/post" parameters:paramDict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
    
    //2)修改 -- path = v2/venues/path
    v.name = @"修改后的name值";
    [objManager patchObject:v path:@"v2/venues/path" parameters:paramDict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
    
    //3)删除 -- [ath = v2/venues/delete
    [objManager deleteObject:v path:@"v2/venues/delete" parameters:paramDict success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
    
}

//添加不同的Route
- (void)addRoutes {
    
//    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://restkit.org"];
    
    // Class Routing
//    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[GGSegment class] pathPattern:@"/segments/:segmentID\\.json" method:RKRequestMethodGET]];
    
    // Relationship Routing
//    [manager.router.routeSet addRoute:[RKRoute routeWithRelationshipName:@"amenities" objectClass:[GGAirport class] pathPattern:@"/airports/:airportID/amenities.json" method:RKRequestMethodGET]];
    
    // Named Routes
//    [manager.router.routeSet addRoute:[RKRoute routeWithName:@"thumbs_down_review" resourcePathPattern:@"/reviews/:reviewID/thumbs_down" method:RKRequestMethodPOST]];
}

//在一个Route中, 对不同的path的服务器路径进行request请求 放入队列执行
- (void)settingRoute {
    
    //1. 设置BaseURL
//    NSURL * baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
//    AFHTTPClient * client = [AFHTTPClient clientWithBaseURL:baseURL];
//    RKObjectManager * objManager = [RKObjectManager sharedManager];
//    if (objManager == nil) {
//        objManager = [[RKObjectManager alloc] initWithHTTPClient:client];
//    }
    
    RKObjectManager *objManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://restkit.org"]];
    
    //2. 设置Route    (中间的 :code 表示对象的属性 或 直接就是值)
    RKRoute * route = [RKRoute routeWithName:@"route的名字" pathPattern:@"/airports/:code/weather" method:RKRequestMethodGET];
    
    [objManager enqueueBatchOfObjectRequestOperationsWithRoute:route objects:@[@"code值1", @"code值2", @"code值3"] progress:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
        //1. 参数1 - numberOfFinishedOperations: 当前完成的是第几个 :code 指向的请求
        //2. 参数2 - totalNumberOfOperations: 总共需要完成的请求次数
        
    } completion:^(NSArray *operations) {
        
        //全部请求完毕 (响应数据是不是在operations中 ? )
        NSLog(@"All Weather Reports Loaded!");
    }];
    
    //3. 会进行如下3个请求
    //1) http://restkit.org//airports/code值1/weather
    //2) http://restkit.org//airports/code值2/weather
    //3) http://restkit.org//airports/code值3/weather
}




@end
