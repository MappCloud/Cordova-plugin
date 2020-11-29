
#import "LMLogger.h"

@class CDVLocationManager;
@class AppDelegate;

@implementation LMLogger

- (void) postLocalNotificationWithMessage: (NSString*) alertBody {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = alertBody;
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void) debugLog: (NSString*) format, ... {

    if (!self.debugLogEnabled) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSLog(@"%@", msg);
}


- (void) debugNotification: (NSString*) format, ... {
    
    if (!self.debugNotificationsEnabled) {
        return;
    }
    
    va_list args;
    va_start(args, format);
    NSString *alertBody = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [self postLocalNotificationWithMessage:alertBody];
}

@end
