#import "RemoteSharer.h"

@implementation RemoteSharer

- (NSString *)debugDescription {
    NSDictionary *properties = @{
                                 @"service": self.service,
                                 @"name": self.name,
                                 @"shortName": self.shortName,
                                 @"preview": self.preview,
                                 };
    return [NSString stringWithFormat:@"<%@: %p> (%@)", NSStringFromClass([self class]), self, properties];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> %@[%@]", NSStringFromClass([self class]), self, self.service];
}

@end
