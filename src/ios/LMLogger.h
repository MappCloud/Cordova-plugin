
#import <Foundation/Foundation.h>

@interface LMLogger : NSObject

@property BOOL debugLogEnabled;

@property BOOL debugNotificationsEnabled;


- (void) postLocalNotificationWithMessage: (NSString*) alertBody;

- (void) debugNotification: (NSString*) format, ...;

- (void) debugLog: (NSString*) format, ...;

@end
