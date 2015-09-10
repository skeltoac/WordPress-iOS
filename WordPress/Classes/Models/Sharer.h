#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Blog;

@interface Sharer : NSManagedObject

@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *genericon;
@property (nonatomic, strong) NSString *preview;
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) Blog *blog;

@end
