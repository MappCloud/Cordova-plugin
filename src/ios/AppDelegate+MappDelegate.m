
#import "AppDelegate+MappDelegate.h"
#import <objc/runtime.h>
#import "MappPlugin.h"
#import "AppoxeeSDK.h"
#import "AppoxeeLocationManager.h"
#import "AppoxeeInappSDK.h"
#import "AppoxeeInapp.h"


@interface AppDelegate () <AppoxeeNotificationDelegate, AppoxeeLocationManagerDelegate, AppoxeeInappDelegate>

@end

@implementation AppDelegate (AppoxeeDelegate)
- (BOOL)debugLogEnabled {
    return objc_getAssociatedObject(self, @selector(debugLogEnabled));
}
- (void)setDebugLogEnabled:(BOOL)debugLogEnabled {
    objc_setAssociatedObject(self, @selector(debugLogEnabled), [NSNumber numberWithBool:debugLogEnabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)debugNotificationsEnabled {
    return objc_getAssociatedObject(self, @selector(debugNotificationsEnabled));
}
- (void)setDebugNotificationsEnabled:(BOOL)debugNotificationsEnabled {
    objc_setAssociatedObject(self, @selector(debugNotificationsEnabled), [NSNumber numberWithBool:debugNotificationsEnabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (LMLogger *)logger {
    return objc_getAssociatedObject(self, @selector(logger));
}
- (void)setLogger:(LMLogger *)logger {
    objc_setAssociatedObject(self, @selector(logger), logger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//Swizzling should always be done in +load, is sent when the class is initially loaded

+ (void)load {
    
    [AppDelegate swizzeleLaunching];
}

//Method swizzling is the process of changing the implementation of an existing selector. It’s a technique made possible by the fact that method invocations in Objective-C can be changed at runtime, by changing how selectors are mapped to underlying functions in a class’s dispatch table

+ (void)swizzeleLaunching
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        SEL originalSelector = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzledSelector = @selector(apx_application:didFinishLaunchingWithOptions:);
        
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL isMethodExists = !class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (isMethodExists){
        
            method_exchangeImplementations(originalMethod, swizzledMethod);
        
        } else {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
        }
    });
}
- (BOOL)apx_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
        
        [[Appoxee shared] engageAndAutoIntegrateWithLaunchOptions:nil andDelegate:self with: TEST];
        
    } else {
        
        [[Appoxee shared] engageAndAutoIntegrateWithLaunchOptions:launchOptions andDelegate:self with: TEST];
    }
    [[Appoxee shared] addObserver:self forKeyPath:@"isReady" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    [[AppoxeeInapp shared] engageWithDelegate:self with:tEST];
    self.debugLogEnabled = true;
    self.debugNotificationsEnabled = false;
    return [self apx_application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isReady"]) {

        [[Appoxee shared] removeObserver:self forKeyPath:@"isReady"];
        [[AppoxeeLocationManager shared] setDelegate:self];
        [[AppoxeeLocationManager shared] setLogLevel: 1];
        [[AppoxeeLocationManager shared] enableLocationMonitoring];
    }
}

#pragma mark - AppoxeeNotificationDelegate

- (void)appoxee:(nonnull Appoxee *)appoxee handledRemoteNotification:(nonnull APXPushNotification *)pushNotification andIdentifer:(nonnull NSString *)actionIdentifier
{
    NSMutableDictionary *dictionary = [[MappPlugin dictionaryWithPropertiesOfObject:pushNotification] mutableCopy];
    if (actionIdentifier) dictionary[@"actionIdentifier"] = actionIdentifier;
    else dictionary[@"actionIdentifier"] = @"";
    
    if (dictionary) {
        
        NSString *json = [MappPlugin jsonStringFromDictionary:dictionary];
        
        if (json) {
            
            [MappPlugin saveJsonPayload:json];
        }
    }
}

#pragma mark - AppoxeeLocationManagerDelegate

- (void)locationManager:(nonnull AppoxeeLocationManager *)manager didFailWithError:(nullable NSError *)error
{
    [[self getLogger] debugLog:@"didFailWithError: %@", error.description];

    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    [dictionary setObject:[self jsCallbackNameForSelector :_cmd] forKey:@"eventType"];
    [dictionary setObject:error.description forKey:@"error"];
    if (dictionary) {

           NSString *json = [MappPlugin jsonStringFromDictionary:dictionary];

           if (json) {

              [MappPlugin saveJsonPayload:json];
           }
        }

}

- (void)locationManager:(nonnull AppoxeeLocationManager *)manager didEnterGeoRegion:(nonnull CLCircularRegion *)geoRegion
{

    [[self getLogger] debugLog:@"didEnterRegion: %@", geoRegion.identifier];
    [[self getLogger] debugNotification:@"didEnterRegion: %@", geoRegion.identifier];
    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    [dictionary setObject:[self jsCallbackNameForSelector:(_cmd)] forKey:@"eventType"];
    [dictionary setObject:[self mapOfRegion:geoRegion] forKey:@"region"];

    if (dictionary) {

       NSString *json = [MappPlugin jsonStringFromDictionary:dictionary];

       if (json) {

          [MappPlugin saveJsonPayload:json];
       }
    }
}

- (void)locationManager:(nonnull AppoxeeLocationManager *)manager didExitGeoRegion:(nonnull CLCircularRegion *)geoRegion
{
    [[self getLogger] debugLog:@"didExitRegion: %@", geoRegion.identifier];
    [[self getLogger] debugNotification:@"didExitRegion: %@", geoRegion.identifier];

    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    [dictionary setObject:[self jsCallbackNameForSelector:(_cmd)] forKey:@"eventType"];
    [dictionary setObject:[self mapOfRegion:geoRegion] forKey:@"region"];

    if (dictionary) {

       NSString *json = [MappPlugin jsonStringFromDictionary:dictionary];

       if (json) {

         [MappPlugin saveJsonPayload:json];
       }
    }

}

- (NSString*) jsCallbackNameForSelector: (SEL) selector {
    NSString* fullName = NSStringFromSelector(selector);

    NSString* shortName = [fullName stringByReplacingOccurrencesOfString:@"locationManager:" withString:@""];
    shortName = [shortName stringByReplacingOccurrencesOfString:@":error:" withString:@""];

    NSRange range = [shortName rangeOfString:@":"];

    while(range.location != NSNotFound) {
        shortName = [shortName stringByReplacingCharactersInRange:range withString:@""];
        if (range.location < shortName.length) {
            NSString* upperCaseLetter = [[shortName substringWithRange:range] uppercaseString];
            shortName = [shortName stringByReplacingCharactersInRange:range withString:upperCaseLetter];
        }

        range = [shortName rangeOfString:@":"];
    };

    [[self getLogger] debugLog:@"Converted %@ into %@", fullName, shortName];
    return shortName;
}

- (NSDictionary*) mapOfRegion: (CLRegion*) region {

    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];

    // identifier
    [dict setObject:region.identifier forKey:@"identifier"];

    // typeName - First two characters are cut down to remove the "CL" prefix.
    NSString *typeName = [NSStringFromClass([region class]) substringFromIndex:2];
    typeName = [typeName isEqualToString:@"Region"] ? @"CircularRegion" : typeName;
    [dict setObject:typeName forKey:@"typeName"];

    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        //TODO when we will add support for Beacons
        //CLBeaconRegion* beaconRegion = (CLBeaconRegion*) region;
        //NSDictionary * beaconRegionDict = [self mapOfBeaconRegion:beaconRegion];
        //[dict addEntriesFromDictionary: beaconRegionDict];
        return dict;
    }

    CLCircularRegion *circularRegion = (CLCircularRegion*) region;
    // radius
    NSNumber* radius = [NSNumber numberWithDouble: circularRegion.radius];
    [dict setValue: radius forKey:@"radius"];


    NSNumber* latitude = [NSNumber numberWithDouble: circularRegion.center.latitude ];
    NSNumber* longitude = [NSNumber numberWithDouble: circularRegion.center.longitude];
    // center
    [dict setObject: latitude forKey:@"latitude"];
    [dict setObject: longitude forKey:@"longitude"];

    return dict;
}


- (LMLogger*) getLogger {

    if (self.logger == nil) {
        self.logger = [[LMLogger alloc] init];
    }

    [self.logger setDebugLogEnabled:self.debugLogEnabled];
    [self.logger setDebugNotificationsEnabled:self.debugNotificationsEnabled];

    return self.logger;
}

#pragma mark - AppoxeeInappDelegate

- (void)appoxeeInapp:(nonnull AppoxeeInapp *)appoxeeInapp didReceiveInappMessageWithIdentifier:(nonnull NSNumber *)identifier andMessageExtraData:(nullable NSDictionary <NSString *, id> *)messageExtraData{

    NSDictionary *dict = [[MappPlugin dictionaryWithPropertiesOfObject:messageExtraData] mutableCopy];

    if(dict){

        NSString *json = [MappPlugin jsonStringFromDictionary:dict];


        if (json) {

            [MappPlugin saveJsonPayload:json];
        }
    }
}
- (void)didReceiveCustomLinkWithIdentifier:(nonnull NSNumber *)identifier withMessageString:(nonnull NSString *)message{

    NSDictionary *dict = [[MappPlugin dictionaryWithPropertiesOfObject:message] mutableCopy];

    if(dict){

        NSString *json = [MappPlugin jsonStringFromDictionary:dict];

        if (json) {

            [MappPlugin saveJsonPayload:json];
        }
    }
}

- (void)didReceiveDeepLinkWithIdentifier:(nonnull NSNumber *)identifier withMessageString:(nonnull NSString *)message{

    NSDictionary *dict = [[MappPlugin dictionaryWithPropertiesOfObject:message] mutableCopy];

    if(dict){

        NSString *json = [MappPlugin jsonStringFromDictionary:dict];


        if (json) {

            [MappPlugin saveJsonPayload:json];
        }
    }
}

- (void)didReceiveInBoxMessage:(APXInBoxMessage *_Nullable)message{


    NSDictionary *dict = [[MappPlugin dictionaryWithPropertiesOfObject:message] mutableCopy];

    if(dict){

        NSString *json = [MappPlugin jsonStringFromDictionary:dict];

        if (json) {

            [MappPlugin saveJsonPayload:json];
        }
    }
}

-(void)didReceiveInBoxMessages:(NSArray *)messages{

    NSDictionary *dict = [[MappPlugin dictionaryWithPropertiesOfObject:messages] mutableCopy];

    if(dict){

        NSString *json = [MappPlugin jsonStringFromDictionary:dict];


        if (json) {

            [MappPlugin saveJsonPayload:json];

        }
    }
}

# pragma mark Javascript Plugin API

- (void)disableDebugLogs {
    self.debugLogEnabled = false;
    [self.logger setDebugLogEnabled:false];
}

- (void)enableDebugLogs {
    self.debugLogEnabled = true;
    [self.logger setDebugLogEnabled:true];
}

- (void)disableDebugNotifications {
    self.debugNotificationsEnabled = false;
    [self.logger setDebugNotificationsEnabled:false];
}

- (void)enableDebugNotifications {
    self.debugNotificationsEnabled = true;
    [self.logger setDebugNotificationsEnabled:true];
}

@end
