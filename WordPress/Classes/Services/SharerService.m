#import "SharerService.h"
#import "Sharer.h"
#import "Blog.h"
#import "ContextManager.h"
#import "RemoteSharer.h"
#import "SharerServiceRemote.h"

@implementation SharerService

- (Sharer *)newSharerForBlog:(Blog *)blog
{
    Sharer *sharer = [NSEntityDescription insertNewObjectForEntityForName:@"Sharer"
                                                   inManagedObjectContext:self.managedObjectContext];
    sharer.blog = blog;
    return sharer;
}

- (Sharer *)findWithBlogObjectID:(NSManagedObjectID *)blogObjectID
                      andService:(NSString *)service;
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"service == %@", service];
    return [self findWithBlogObjectID:blogObjectID predicate:predicate];
}

- (Sharer *)findWithBlogObjectID:(NSManagedObjectID *)blogObjectID
                       predicate:(NSPredicate *)predicate
{
    Blog *blog = [self blogWithObjectID:blogObjectID];

    NSSet *results = [blog.sharers filteredSetUsingPredicate:predicate];
    return [results anyObject];
}

- (void)syncSharersForBlog:(Blog *)blog
                   success:(void (^)())success
                   failure:(void (^)(NSError *error))failure
{
    NSParameterAssert([blog isKindOfClass:[Blog class]]);

    SharerServiceRemote *remote = [[SharerServiceRemote alloc] initWithApi:blog.restApi];
    NSManagedObjectID *blogID = blog.objectID;
    [remote getSharersWithSuccess:^(NSArray *sharers) {
                         [self.managedObjectContext performBlock:^{
                             Blog *blog = (Blog *)[self.managedObjectContext existingObjectWithID:blogID error:nil];
                             if (!blog) {
                                 return;
                             }
                             [self mergeSharers:sharers forBlog:blog completionHandler:success];
                         }];
                     } failure:failure];
}

- (void)mergeSharers:(NSArray *)sharers
             forBlog:(Blog *)blog
   completionHandler:(void (^)(void))completion
{
    NSParameterAssert([sharers isKindOfClass:[NSArray class]]);
    NSParameterAssert([blog isKindOfClass:[Blog class]]);

    NSSet *remoteSet = [NSSet setWithArray:[sharers valueForKey:@"service"]];
    NSSet *localSet = [blog.sharers valueForKey:@"service"];
    NSMutableSet *toDelete = [localSet mutableCopy];
    [toDelete minusSet:remoteSet];

    if ([toDelete count] > 0) {
        for (Sharer *sharer in blog.sharers) {
            if ([toDelete containsObject:sharer.service]) {
                [self.managedObjectContext deleteObject:sharer];
            }
        }
    }

    for (RemoteSharer *remoteSharer in sharers) {
        Sharer *sharer = [self findWithBlogObjectID:blog.objectID andService:remoteSharer.service];
        if (!sharer) {
            sharer = [self newSharerForBlog:blog];
            sharer.service = remoteSharer.service;
        }
        sharer.name = remoteSharer.name;
        sharer.shortName = remoteSharer.shortName;
        sharer.genericon = remoteSharer.genericon;
        sharer.preview = remoteSharer.preview;
    }
    
    [[ContextManager sharedInstance] saveContext:self.managedObjectContext];

    if (completion) {
        completion();
    }
}

- (Blog *)blogWithObjectID:(NSManagedObjectID *)objectID
{
    if (objectID == nil) {
        return nil;
    }

    NSError *error;
    Blog *blog = (Blog *)[self.managedObjectContext existingObjectWithID:objectID error:&error];
    if (error) {
        DDLogError(@"Error when retrieving Blog by ID: %@", error);
        return nil;
    }

    return blog;
}

@end
