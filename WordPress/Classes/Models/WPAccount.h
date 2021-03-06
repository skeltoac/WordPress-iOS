#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import <WordPressApi/WordPressApi.h>

#import "WordPressComApi.h"

@class Blog;

@interface WPAccount : NSManagedObject

///-----------------
/// @name Properties
///-----------------

@property (nonatomic, strong)   NSNumber    *userID;
@property (nonatomic, strong)   NSString    *avatarURL;
@property (nonatomic, copy)     NSString    *username;
@property (nonatomic, copy)     NSString    *uuid;
@property (nonatomic, strong)   NSString    *email;
@property (nonatomic, strong)   NSString    *displayName;
@property (nonatomic, strong)   NSSet       *blogs;
@property (nonatomic, strong)   NSSet       *jetpackBlogs;
@property (nonatomic, readonly) NSArray     *visibleBlogs;
@property (nonatomic, strong)   Blog        *defaultBlog;

/**
 The OAuth2 auth token for WordPress.com accounts
 */
@property (nonatomic, copy) NSString *authToken;


///------------------
/// @name API Helpers
///------------------

/**
 A WordPressComApi object if the account is a WordPress.com account. Otherwise, it returns `nil`
 */
@property (nonatomic, readonly) WordPressComApi *restApi;

@end

@interface WPAccount (CoreDataGeneratedAccessors)

- (void)addBlogsObject:(Blog *)value;
- (void)removeBlogsObject:(Blog *)value;
- (void)addBlogs:(NSSet *)values;
- (void)removeBlogs:(NSSet *)values;

- (void)addJetpackBlogsObject:(Blog *)value;
- (void)removeJetpackBlogsObject:(Blog *)value;
- (void)addJetpackBlogs:(NSSet *)values;
- (void)removeJetpackBlogs:(NSSet *)values;

#pragma mark - WordPress.com support methods

/**
 *  @brief      Call this method to know if the account is a WordPress.com account.
 *  @details    This is the same as checking if restApi != nil, but it conveys its own meaning
 *              in a cleaner way to the reader.
 *
 *  @returns    YES if this account is a WordPress.com account, NO otherwise.
 */
- (BOOL)isWPComAccount;

@end
