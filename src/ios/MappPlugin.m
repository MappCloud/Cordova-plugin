//
// AppoxeePlugin.m
//
// Created by Saska Radosavljevic on 03/01/2019
//
//

#import "MappPlugin.h"
#import "AppoxeeSDK.h"
#import "AppoxeeLocationManager.h"
#import "APXLocationServices.h"
#import "AppoxeeInappSDK.h"


#import <objc/runtime.h>

@interface MappPlugin () <AppoxeeNotificationDelegate, AppoxeeLocationManagerDelegate, AppoxeeInappDelegate>

@property(nonatomic, strong) NSString  *alias;
    
@end

@implementation MappPlugin

#pragma mark - Initalization

-(void)pluginInitialize
{
    [[Appoxee shared] setDelegate:self];
    [[AppoxeeInapp shared] setDelegate: self];
}
- (void)sendPluginResults:(NSDictionary *)jsonObj withError:(NSError *)appoxeeError toCommand:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult = nil;
    
    if (!appoxeeError) {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];
        
    } else {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[appoxeeError description]];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Initialize

- (void)engage:(CDVInvokedUrlCommand *)command
{
    /*
     * There is no need to engage the iOS plugin.
     * Currently, just sendind back an 'ok'.
     * Probably should remove this method, but need to coordinate this with Android.
     */
    [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:nil toCommand:command];
}

- (void)isAppoxeeReadyCordova:(CDVInvokedUrlCommand *)command
{
    BOOL state = [[Appoxee shared] isReady];
    NSString *stateStr = [MappPlugin stringFromBooleanArgumet:state];
    
    [self sendPluginResults:[MappPlugin successDictionaryWithParam:stateStr] withError:nil toCommand:command];
}

#pragma mark - Alias API

- (void)setDeviceAliasWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    NSString *alias = [command.arguments firstObject];
    
    [[Appoxee shared] setDeviceAlias:alias withCompletionHandler:^(NSError *appoxeeError, id data) {
        
        [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:appoxeeError toCommand:command];
    }];
}

- (void)removeDeviceAliasWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    [[Appoxee shared] removeDeviceAliasWithCompletionHandler:^(NSError *appoxeeError, id data) {
        
        [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:appoxeeError toCommand:command];
    }];
}

- (void)getDeviceAliasWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    [[Appoxee shared] getDeviceAliasWithCompletionHandler:^(NSError *appoxeeError, id data) {
        
        NSString *deviceAlias = nil;
        NSDictionary *jsonObj = nil;
        
        if ([data isKindOfClass:[NSString class]]) {
            
            deviceAlias = (NSString *)data;
            jsonObj = [MappPlugin successDictionaryWithParam:deviceAlias];
        }
        
        [self sendPluginResults:jsonObj withError:appoxeeError toCommand:command];
    }];
}

#pragma mark - Tags API

- (void)fetchDeviceTagsCordova:(CDVInvokedUrlCommand *)command
{
    [[Appoxee shared] fetchDeviceTags:^(NSError *appoxeeError, id data) {
        
        NSArray *deviceTags = nil;
        NSDictionary *jsonObj = nil;
        
        if ([data isKindOfClass:[NSArray class]]) {
            
            deviceTags = (NSArray *)data;
            jsonObj = [MappPlugin successDictionaryWithParam:deviceTags];
        }
        
        [self sendPluginResults:jsonObj withError:appoxeeError toCommand:command];
    }];
}

- (void)fetchApplicationTagsCordova:(CDVInvokedUrlCommand *)command
{
    [[Appoxee shared] fetchApplicationTags:^(NSError *appoxeeError, id data) {
        
        NSArray *applicationTags = nil;
        NSDictionary *jsonObj = nil;
        
        if ([data isKindOfClass:[NSArray class]]) {
            
            applicationTags = (NSArray *)data;
            jsonObj = [MappPlugin successDictionaryWithParam:applicationTags];
        }
        
        [self sendPluginResults:jsonObj withError:appoxeeError toCommand:command];
    }];
}

- (void)addTagsToDeviceWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    if ([[command.arguments firstObject] isKindOfClass:[NSArray class]]) {
        
        NSArray *tags = [command.arguments firstObject];
        
        [[Appoxee shared] addTagsToDevice:tags withCompletionHandler:^(NSError *appoxeeError, id data) {
            
            [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:appoxeeError toCommand:command];
        }];
        
    } else {
        
        [self sendPluginResults:nil withError:[MappPlugin appoxeeWrongArgsError] toCommand:command];
    }
}

- (void)removeTagsFromDeviceWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    if ([[command.arguments firstObject] isKindOfClass:[NSArray class]]) {
        
        NSArray *tags = [command.arguments firstObject];
        
        [[Appoxee shared] removeTagsFromDevice:tags withCompletionHandler:^(NSError *appoxeeError, id data) {
            
            [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:appoxeeError toCommand:command];
        }];
        
    } else {
        
        [self sendPluginResults:nil withError:[MappPlugin appoxeeWrongArgsError] toCommand:command];
    }
}

- (void)addTagsToDeviceAndRemoveWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    if ([[command.arguments firstObject] isKindOfClass:[NSArray class]] && [[command.arguments lastObject] isKindOfClass:[NSArray class]]) {
        
        NSArray *tagsAddList = [command.arguments firstObject];
        
        NSArray *tagsRemoveList = [command.arguments lastObject];
        
        [[Appoxee shared] addTagsToDevice:tagsAddList andRemove:tagsRemoveList withCompletionHandler:^(NSError *appoxeeError, id data) {
            
            [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:appoxeeError toCommand:command];
        }];
        
    } else {
        
        [self sendPluginResults:nil withError:[MappPlugin appoxeeWrongArgsError] toCommand:command];
    }
}

#pragma mark - Inbox API

- (void)getRichMessagesWithHandlerCordova:(CDVInvokedUrlCommand *)command
{
    [[Appoxee shared] getRichMessagesWithHandler:^(NSError *appoxeeError, id data) {
        
        NSArray *messages = nil;
        NSMutableArray *messagesArr = [[NSMutableArray alloc] init];
        
        if ([data isKindOfClass:[NSArray class]]) {
            
            messages = (NSArray *)data;
            
            for (int i = 0 ;i < [messages count]; i++) {
                
                NSDictionary *dict = [MappPlugin dictionaryWithPropertiesOfObject:[messages objectAtIndex:i]];
                NSString *myString = [MappPlugin jsonStringFromDictionary:dict];
                [messagesArr addObject:myString];
            }
        }
        
        [self sendPluginResults:[MappPlugin successDictionaryWithParam:messagesArr] withError:appoxeeError toCommand:command];
    }];
}

- (void)deleteRichMessageWithHandlerCordova:(CDVInvokedUrlCommand *)command
{
    NSString *arg = [command.arguments firstObject];
    
    NSNumber *messageID = [[NSNumber alloc] initWithInteger:[arg integerValue]];
    
    if (messageID) {
        
        APXRichMessage *msg = [[APXRichMessage alloc] initWithKeyedValues:@{@"id" : messageID}];
        
        [[Appoxee shared] deleteRichMessage:msg withHandler:^(NSError *appoxeeError, id data) {
            
            [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:appoxeeError toCommand:command];
        }];
        
    } else {
        
        [self sendPluginResults:nil withError:[MappPlugin appoxeeWrongArgsError] toCommand:command];
        
    }
}

- (void)refreshInboxWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    [[Appoxee shared] refreshInboxWithCompletionHandler:^(NSError *appoxeeError, id data) {
        
        NSArray *messages = nil;
        NSMutableArray *messagesArr = [[NSMutableArray alloc] init];
        
        if ([data isKindOfClass:[NSArray class]]) {
            
            messages = (NSArray *)data;
            
            for (int i = 0 ;i < [messages count]; i++) {
                
                NSDictionary *dict = [MappPlugin dictionaryWithPropertiesOfObject:[messages objectAtIndex:i]];
                NSString *myString = [MappPlugin jsonStringFromDictionary:dict];
                [messagesArr addObject:myString];
            }
        }
        
        [self sendPluginResults:[MappPlugin successDictionaryWithParam:messagesArr] withError:appoxeeError toCommand:command];
    }];
}
    

#pragma mark - Push API

- (void)disablePushNotificationsWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    NSString *booleanArgument = [command.arguments firstObject];
    BOOL argument = [MappPlugin booleanFromStringArgument:booleanArgument];
    
    [[Appoxee shared] disablePushNotifications:argument withCompletionHandler:^(NSError *appoxeeError, id data) {
        
        [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:appoxeeError toCommand:command];
    }];
}

- (void)isPushEnabledCordova:(CDVInvokedUrlCommand *)command
{
    [[Appoxee shared] isPushEnabled:^(NSError *appoxeeError, id data) {
        
        BOOL state = [(NSNumber *)data boolValue];
        NSString *stateStr = [MappPlugin stringFromBooleanArgumet:state];
        
        [self sendPluginResults:[MappPlugin successDictionaryWithParam:stateStr] withError:appoxeeError toCommand:command];
    }];
}

- (void)showNotificationsOnForegroundCordova:(CDVInvokedUrlCommand *)command
{
    NSString *booleanArgument = [command.arguments firstObject];
    BOOL argument = [MappPlugin booleanFromStringArgument:booleanArgument];
    
    [[Appoxee shared] setShowNotificationsOnForeground:argument];
    
    [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:nil toCommand:command];
}

- (void)setApplicationBadgeNumberCordova:(CDVInvokedUrlCommand *)command
{
    NSString *stringValue = [command.arguments firstObject];
    
    NSNumber *badgeNumber = [MappPlugin numberFromStringArg:stringValue];
    
    if (badgeNumber) {
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[badgeNumber integerValue]];
    }
    
    [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:nil toCommand:command];
}

#pragma mark - Custom Fields API

- (void)setDateFieldWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    NSString *stringKey = [command.arguments firstObject];
    NSString *stringValue = [command.arguments lastObject];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *dateFromStr = (NSDate*)[dateFormatter dateFromString:stringValue];
    
    //Date formatter reuturns an NSTaggedDate and the SDK doesn't accept it so we need to hack our way to get a regular NSDate
    NSTimeInterval timeint = [dateFromStr timeIntervalSinceNow];
    NSDate *d = nil;
    
    if (timeint != 0) {
        
        d = [NSDate dateWithTimeIntervalSinceNow:timeint];
        
        [[Appoxee shared] setDateValue:d forKey:stringKey withCompletionHandler:^(NSError * _Nullable appoxeeError, id  _Nullable data) {
            
            [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:appoxeeError toCommand:command];
        }];
        
    } else {
        
        [self sendPluginResults:nil withError:[MappPlugin appoxeeWrongArgsError] toCommand:command];
    }
}

- (void)setNumericFieldWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    NSString *stringKey = [command.arguments firstObject];
    NSString *stringValue = [command.arguments lastObject];
    
    NSNumber *myNumber = [MappPlugin numberFromStringArg:stringValue];
    
    if (myNumber) {
        
        [[Appoxee shared] setNumberValue:myNumber forKey:stringKey withCompletionHandler:^(NSError * _Nullable appoxeeError, id  _Nullable data) {
            
            [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:appoxeeError toCommand:command];
        }];
        
    } else {
        
        [self sendPluginResults:nil withError:[MappPlugin appoxeeWrongArgsError] toCommand:command];
    }
}


- (void)setStringFieldWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    NSString *stringKey = [command.arguments firstObject];
    NSString *stringValue = [command.arguments lastObject];
    
    if (stringKey && stringValue) {
        
        [[Appoxee shared] setStringValue:stringValue forKey:stringKey withCompletionHandler:^(NSError * _Nullable appoxeeError, id  _Nullable data) {
            
            [self sendPluginResults:[MappPlugin successDictionaryWithParam:nil] withError:appoxeeError toCommand:command];
        }];
        
    } else {
        
        [self sendPluginResults:nil withError:[MappPlugin appoxeeWrongArgsError] toCommand:command];
    }
}

- (void)fetchCustomFieldByKeyWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    NSString *stringKey = [command.arguments firstObject];
    
    [[Appoxee shared] fetchCustomFieldByKey:stringKey withCompletionHandler:^(NSError *appoxeeError, id data) {
        
        NSDictionary *dictionary = nil;
        id value = nil;
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            dictionary = (NSDictionary *)data;
            NSString *key = [[dictionary allKeys] firstObject];
            value = dictionary[key]; // can be of the following types: NSString || NSNumber || NSDate
            
            if ([value isKindOfClass:[NSDate class]]) {
                
                value = [MappPlugin changeDateToDateStringLong:value];
            }
        }
        
        if (value) {
            
            [self sendPluginResults:[MappPlugin successDictionaryWithParam:value] withError:appoxeeError toCommand:command];
            
        } else {
            
            [self sendPluginResults:nil withError:[MappPlugin appoxeeWrongArgsError] toCommand:command];
        }
    }];
}

- (void)deviceInformationWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command
{
    [[Appoxee shared] deviceInformationwithCompletionHandler:^(NSError *appoxeeError, id data) {
        
        APXClientDevice *device = nil;
        
        if ([data isKindOfClass:[APXClientDevice class]]) {
            
            device = (APXClientDevice *)data;
            NSDictionary *dict = [MappPlugin dictionaryWithPropertiesOfObject:device];
            NSString *myString = [MappPlugin jsonStringFromDictionary:dict];
            
            [self sendPluginResults:[MappPlugin successDictionaryWithParam:myString] withError:appoxeeError toCommand:command];
            
        } else {
            
            [self sendPluginResults:nil withError:appoxeeError toCommand:command];
        }
    }];
}

#pragma mark - Last Push Payload

- (void)getLastPushPayloadCordova:(CDVInvokedUrlCommand *)command
{
    
    NSString *json = [MappPlugin loadJsonPayload];
    
    if (!json) {
        
        json = @"{}";
        
    } else {
        
        [MappPlugin saveJsonPayload:nil];
    }
    
    [self sendPluginResults:[MappPlugin successDictionaryWithParam:json] withError:nil toCommand:command];
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

- (void)appoxee:(nonnull Appoxee *)appoxee handledRichContent:(nonnull APXRichMessage *)richMessage didLaunchApp:(BOOL)didLaunch
{
    NSMutableDictionary *dictionary = [[MappPlugin dictionaryWithPropertiesOfObject:richMessage] mutableCopy];
    if (didLaunch) dictionary[@"didLaunch"] = @"true";
    else dictionary[@"didLaunch"] = @"false";
    
    if (dictionary) {
        
        NSString *json = [MappPlugin jsonStringFromDictionary:dictionary];
        
        if (json) {
            
            NSString *javascript = [NSString stringWithFormat:@"MappPlugin.richMessageReceived('%@')", json];
            
            [self.commandDelegate evalJs:javascript];
        }
    }
}


#pragma mark - Helpers

+ (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary
{
    NSString *jsonString = @"{}";
    
    if (dictionary) {
        
        NSError *err;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&err];
        
        if (!err) jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

+ (NSNumber *)numberFromStringArg:(NSString *)stringArg
{
    if (stringArg) {
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        return [f numberFromString:stringArg];
        
    } else {
        
        return @(0);
    }
}

+ (NSString *)stringFromBooleanArgumet:(BOOL)arg
{
    if (arg) {
        
        return @"true";
        
    } else {
        
        return @"false";
    }
}

+ (BOOL)booleanFromStringArgument:(NSString *)arg
{
    BOOL boolFromStr = NO;
    
    if ([arg isEqualToString:@"true"]) {
        
        boolFromStr = YES;
        
    } else if ([arg isEqualToString:@"false"]) {
        
        boolFromStr = NO;
    }
    
    return boolFromStr;
}

+ (NSDictionary *)successDictionaryWithParam:(id)param
{
    if (param) {
        
        return [[NSDictionary alloc] initWithObjectsAndKeys:param, @"result", @"true", @"success", nil];
        
    } else {
        
        return [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"success", nil];
    }
}

+ (NSError *)appoxeeWrongArgsError
{
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"Wrong data type returned from Appoxxee SDK" forKey:NSLocalizedDescriptionKey];
    NSError *appoxeeError = [NSError errorWithDomain:@"DataType" code:400 userInfo:details];
    
    return appoxeeError;
}

+ (NSDictionary *)dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        id possibleObj = [obj valueForKey:key];
        
        if (possibleObj) {
            
            if ([possibleObj isKindOfClass:[NSDate class]]) {
                
                [dict setObject:[MappPlugin changeDateToDateString:possibleObj] forKey:key];
                
            } else if ([possibleObj isKindOfClass:[APXPushNotificationAction class]] || [possibleObj isKindOfClass:[APXPushNotificationActionButton class]] || [possibleObj isKindOfClass:[APXPushNotificationActionButtonAction class]]){
                
                [dict setObject:[MappPlugin dictionaryWithPropertiesOfObject:possibleObj] forKey:key];
                
            } else if ([possibleObj isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (int j = 0; j < [possibleObj count]; j++) {
                    
                    [array addObject:[MappPlugin dictionaryWithPropertiesOfObject:possibleObj[j]]];
                }
                
                [dict setObject:array forKey:key];
                
            } else {
                
                [dict setObject:possibleObj forKey:key];
            }
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (NSString *)changeDateToDateString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"hh mm" options:kNilOptions locale:locale];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:locale];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)changeDateToDateStringLong:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

#define KEY_APPOXEE_LAST_PUSH_PAYLOAD @"com.appoxee.last.push.payload"

+ (void)saveJsonPayload:(NSString *)jsonPayload
{
    [[NSUserDefaults standardUserDefaults] setObject:jsonPayload forKey:KEY_APPOXEE_LAST_PUSH_PAYLOAD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)loadJsonPayload
{
    NSString *jsonPayload = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_APPOXEE_LAST_PUSH_PAYLOAD];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_APPOXEE_LAST_PUSH_PAYLOAD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return jsonPayload;
}


#pragma mark - AppoxeeLocationManager

#pragma mark - APXLocationManagerOperations

- (void)enableLocationMonitoringCordova:(CDVInvokedUrlCommand *)command
{
    [[APXLocationServices shared] startUpdatingLocation];
}

- (void)disableLocationMonitoringCordova:(CDVInvokedUrlCommand *)command
{
    [[APXLocationServices shared] stopUpdatingLocation];
}

- (void)stopUpdatingSignificantLocationCordova
{
    [[APXLocationServices shared] stopUpdatingSignificantLocation];
}

- (NSArray *)geoMonitoredRegionsCordova
{
    return [[APXLocationServices shared] geoMonitoredRegions];
}

- (void)removeMonitoredRegionsOfClassCordova:(id)regionInstance
{
    [[APXLocationServices shared] removeMonitoredRegionsOfClass: regionInstance];
}

- (void)addRegionsToMonitorCordova:(NSArray <CLRegion *> *)regions
{
    [[APXLocationServices shared] addRegionsToMonitor: regions];
}

- (void)removeMonitoredGeoRegionsCordova:(NSArray <CLCircularRegion *> *)geoRegions
{
    [[APXLocationServices shared] removeMonitoredGeoRegions:geoRegions];
}

- (void)startRangingBeaconsInRegionCordova:(CLBeaconRegion *)beaconRegion
{
   [[APXLocationServices shared] startRangingBeaconsInRegion: beaconRegion];
}

- (void)stopRangingBeaconsInRegionCordova:(CLBeaconRegion *)beaconRegion
{
    [[APXLocationServices shared] stopRangingBeaconsInRegion: beaconRegion];
}

- (void)stopRangingAllBeaconsCordova
{
    [[APXLocationServices shared] stopRangingAllBeacons];
}

#pragma mark - AppoxeeInapp

-(void)fireInAppEventCordova:(CDVInvokedUrlCommand *)command{

    NSString *name = [command.arguments firstObject];
    NSString *attr = @"";

    NSDictionary *dict = [MappPlugin dictionaryWithPropertiesOfObject:attr];

    [[AppoxeeInapp shared]  reportInteractionEventWithName: name andAttributes: dict];

    NSString *messages = [NSString stringWithFormat:@"fire inapp event!"];
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: messages];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];

}

-(void)fetchInboxMessagesCordova:(CDVInvokedUrlCommand *)command{

    [[AppoxeeInapp shared] fetchAPXInBoxMessages];
    self.callbackId = command.callbackId;

}



#pragma mark - AppoxeeInappDelegate

-(void)appoxeeInapp:(nonnull AppoxeeInapp *)appoxeeInapp didReceiveInappMessageWithIdentifier:(nonnull NSNumber *)identifier andMessageExtraData:(nullable NSDictionary <NSString *, id> *)messageExtraData{



    NSDictionary *dict = [[MappPlugin dictionaryWithPropertiesOfObject:messageExtraData] mutableCopy];

    if(dict){

        NSString *json = [MappPlugin jsonStringFromDictionary:dict];


        if (json) {

            [MappPlugin saveJsonPayload:json];
        }
    }
}

-(void)didReceiveCustomLinkWithIdentifier:(nonnull NSNumber *)identifier withMessageString:(nonnull NSString *)message{

    NSDictionary *dict = [[MappPlugin dictionaryWithPropertiesOfObject:message] mutableCopy];

    if(dict){

        NSString *json = [MappPlugin jsonStringFromDictionary:dict];


        if (json) {

            [MappPlugin saveJsonPayload:json];
        }

    }

}

-(void)didReceiveDeepLinkWithIdentifier:(nonnull NSNumber *)identifier withMessageString:(nonnull NSString *)message{

    if([message isKindOfClass: [NSString class]] && [identifier isKindOfClass:[NSNumber class]]){

        NSDictionary *dict = @{message:message,identifier:identifier};

        NSString *json = [MappPlugin jsonStringFromDictionary:dict];

        CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:(NSString *)json];

        [self.commandDelegate sendPluginResult:commandResult callbackId:self.callbackId];

    }
}



-(void)didReceiveInBoxMessage:(APXInBoxMessage *_Nullable)message{


    NSMutableDictionary *dict = [[MappPlugin dictionaryWithPropertiesOfObject:message] mutableCopy];

    if(dict){

        NSString *json = [MappPlugin jsonStringFromDictionary:dict];

        if (json) {

            [MappPlugin saveJsonPayload:json];
        }
    }

}


-(void)didReceiveInBoxMessages:(NSArray *)messages{

    NSMutableArray *msgAtr = [[NSMutableArray alloc] init];
    NSMutableArray *jsons = [[NSMutableArray alloc] init];

    if([messages isKindOfClass: [NSArray class]]){

        for (int i = 0;i <[messages count]; i++) {
            NSDictionary *dict = [(APXInBoxMessage* )[messages objectAtIndex:i] getDictionary];
            NSString *myString = [MappPlugin jsonStringFromDictionary:dict];
            [msgAtr addObject:myString];
            [jsons addObject:myString];
        }
    }
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsArray:(NSArray *)jsons];

    [self.commandDelegate sendPluginResult:commandResult callbackId:self.callbackId];

}

@end
