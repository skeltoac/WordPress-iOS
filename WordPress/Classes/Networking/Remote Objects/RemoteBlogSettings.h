#import <Foundation/Foundation.h>

@interface RemoteBlogSettings : NSObject

// General
@property (copy) NSString *name;
@property (copy) NSString *desc;
@property (copy) NSNumber *privacy;

// Writing
@property (copy) NSNumber *defaultCategory;
@property (copy) NSString *defaultPostFormat;

// Sharing
@property (copy) NSNumber *disableLikes;
@property (copy) NSNumber *disableReblogs;
@property (copy) NSNumber *enableCommentLikes;
@property (copy) NSString *sharingButtonStyle;
@property (copy) NSString *sharingLabel;
@property (copy) NSArray *sharingShow;
@property (copy) NSString *sharingTwitter;

@end
