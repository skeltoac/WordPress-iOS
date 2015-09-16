#import "SharerServiceRemote.h"
#import "WordPressComApi.h"
#import "RemoteSharer.h"

@implementation SharerServiceRemote

- (void)getSharersWithSuccess:(void (^)(NSArray *sharers))success
                      failure:(void (^)(NSError *error))failure
{
    static NSString *const path = @"meta/sharing-buttons/";
    NSString *requestUrl = [self pathForEndpoint:path
                                     withVersion:ServiceRemoteRESTApiVersion_1_1];

    [self.api GET:requestUrl
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success) {
                  NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                  NSArray *sharers = [self remoteSharersWithJSONDictionary:[responseDictionary dictionaryForKey:@"services"]];
                  success(sharers);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure) {
                  failure(error);
              }
          }];
}

- (NSArray *)remoteSharersWithJSONDictionary:(NSDictionary *)jsonDictionary
{
    NSParameterAssert([jsonDictionary isKindOfClass:[NSDictionary class]]);
    
    NSMutableArray *sharers = [NSMutableArray arrayWithCapacity:jsonDictionary.count];
    for (NSString *key in jsonDictionary) {
        [sharers addObject:[self remoteSharer:key withJSONDictionary:jsonDictionary[key]]];
    }
    return sharers;
}

- (RemoteSharer *)remoteSharer:(NSString *)service
            withJSONDictionary:(NSDictionary *)jsonSharer
{
    NSParameterAssert([service isKindOfClass:[NSString class]]);
    NSParameterAssert([jsonSharer isKindOfClass:[NSDictionary class]]);

    RemoteSharer *sharer = [RemoteSharer new];
    sharer.service = service;
    sharer.name = [jsonSharer stringForKey:@"name"];
    sharer.shortName = [jsonSharer stringForKey:@"shortName"];
    sharer.genericon = [jsonSharer stringForKey:@"genericon"];
    sharer.preview = [jsonSharer stringForKey:@"preview"];
    return sharer;
}

@end
