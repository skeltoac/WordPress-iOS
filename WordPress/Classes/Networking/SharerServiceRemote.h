#import <Foundation/Foundation.h>
#import "ServiceRemoteREST.h"

@class Blog;

@interface SharerServiceRemote : ServiceRemoteREST

/**
 *  @brief      Gets list of Sharer services available.
 *
 *  @param      success     The success handler.  Can be nil.
 *  @param      failure     The failure handler.  Can be nil.
 */
- (void)getSharersWithSuccess:(void (^)(NSArray *sharers))success
                      failure:(void (^)(NSError *error))failure;

@end
