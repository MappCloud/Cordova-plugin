
#import "AppDelegate.h"
#import "LMLogger.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate (AppoxeeDelegate)

@property (retain, readwrite) LMLogger *logger;
@property BOOL debugLogEnabled;
@property BOOL debugNotificationsEnabled;

@end
