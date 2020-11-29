//
//  MappPlugin.h
//  DemoCordova
//
//  Created by Saska Radosavljevic on 03/01/2019
//
//


#import <Cordova/CDV.h>
#import <CoreLocation/CoreLocation.h>

@interface MappPlugin : CDVPlugin

@property (nonatomic, copy) NSString *callbackId;
 

#pragma mark - Plugin Communication

- (void)sendPluginResults:(NSDictionary *)jsonObj withError:(NSError *)appoxeeError toCommand:(CDVInvokedUrlCommand *)command;

#pragma mark - Initialize

-(void)engage:(CDVInvokedUrlCommand *)command;
-(void)isAppoxeeReadyCordova:(CDVInvokedUrlCommand *)command;

#pragma mark - Push API

-(void)showNotificationsOnForegroundCordova:(CDVInvokedUrlCommand *)command;
-(void)setApplicationBadgeNumberCordova:(CDVInvokedUrlCommand *)command;
-(void)disablePushNotificationsWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)isPushEnabledCordova:(CDVInvokedUrlCommand *)command;

#pragma mark - Alias API

-(void)setDeviceAliasWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)removeDeviceAliasWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)getDeviceAliasWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;

#pragma mark - Device Tags API

-(void)fetchDeviceTagsCordova:(CDVInvokedUrlCommand *)command;
-(void)fetchApplicationTagsCordova:(CDVInvokedUrlCommand *)command;
-(void)addTagsToDeviceWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)removeTagsFromDeviceWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)addTagsToDeviceAndRemoveWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;

#pragma mark - Custom Fields API

-(void)setDateFieldWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)setNumericFieldWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)setStringFieldWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)fetchCustomFieldByKeyWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;

#pragma mark - Device Info API

-(void)deviceInformationWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;

#pragma mark - Inbox API

-(void)getRichMessagesWithHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)deleteRichMessageWithHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)refreshInboxWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)disableInboxWithCompletionHandlerCordova:(CDVInvokedUrlCommand *)command;
-(void)isInboxEnabledCordova:(CDVInvokedUrlCommand *)command;


#pragma mark - AppoxeeInapp

-(void)fireInAppEventCordova:(CDVInvokedUrlCommand *)command;
-(void)fetchInboxMessagesCordova:(CDVInvokedUrlCommand *)command;

#pragma mark - Last Push Payload

-(void)getLastPushPayloadCordova:(CDVInvokedUrlCommand *)command;


#pragma mark - Helpers

+ (NSDictionary *)dictionaryWithPropertiesOfObject:(id)obj;
+ (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary;
+ (void)saveJsonPayload:(NSString *)jsonPayload;
+ (NSString *)loadJsonPayload;


#pragma mark - AppoxeeLocationManager

- (void)enableLocationMonitoringCordova:(CDVInvokedUrlCommand *)command;
- (void)disableLocationMonitoringCordova:(CDVInvokedUrlCommand *)command;

#pragma mark - APXLocationServices

#pragma mark - Helpers
- (BOOL)isAuthorizationStatusOKCordova;

#pragma mark - APXLocationManagerOperations
- (void)stopUpdatingSignificantLocationCordova;
- (NSArray *)geoMonitoredRegionsCordova;
- (void)removeMonitoredRegionsOfClassCordova:(id)regionInstance;
- (void)addRegionsToMonitorCordova:(NSArray <CLRegion *> *)regions;
- (void)removeMonitoredGeoRegionsCordova:(NSArray <CLCircularRegion *> *)geoRegions;
- (void)startRangingBeaconsInRegionCordova:(CLBeaconRegion *)beaconRegion;
- (void)stopRangingBeaconsInRegionCordova:(CLBeaconRegion *)beaconRegion;
- (void)stopRangingAllBeaconsCordova;


@end
