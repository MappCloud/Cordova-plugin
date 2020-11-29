//
//  APXLocationServices.h
//  AppoxeeLocationServices
//
//  Created by Raz Elkayam on 8/6/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppoxeeLocationManager.h"

#define APPOXEE_SDK_IDENTIFIER @"some.unique.identifier.to.be.checked.for.every.api.call"

typedef NS_ENUM(NSInteger, APXLocatioError) {
    APXLocationErrorServicesAreNotEnabled = 0,
};

@class APXLocationServices;

@protocol APXLocationServicesDelegate <NSObject>

@required

/*!
 * geoDelegate is notified with CLCircularRegion && beaconDelegate is notified with CLBeaconRegion.
 */
- (void)locationService:(APXLocationServices *)service didEnterRegion:(CLRegion *)region;

/*!
 * geoDelegate is notified with CLCircularRegion && beaconDelegate is notified with CLBeaconRegion.
 */
- (void)locationService:(APXLocationServices *)service didExitRegion:(CLRegion *)region;

/*!
 * Notifes all delegates.
 */
- (void)locationService:(APXLocationServices *)service didUpdateLocations:(NSArray <CLLocation *> *)locations;

/*!
 * Notifes all delegates.
 */
- (void)locationService:(APXLocationServices *)service didFailWithError:(NSError *)error;

/*!
 * geoDelegate is notified with CLCircularRegion && beaconDelegate is notified with CLBeaconRegion.
 */
- (void)locationService:(APXLocationServices *)service monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error;

/*!
 * Notifes beaconDelegate delegate only, but implementation is mandatory for all delegates.
 */
- (void)locationService:(APXLocationServices *)service didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

/*!
 * geoDelegate is notified with CLCircularRegion && beaconDelegate is notified with CLBeaconRegion.
 */
- (void)locationService:(APXLocationServices *)service didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region;

@end

/*!
 * Class Designated for retreving locations, registering for Geo / Beacon regions.
 * All location updates are trasfered to the respected delegates.
 */
@interface APXLocationServices : NSObject

@property (nonatomic, strong, readonly) CLLocationManager *locationManager;
@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, weak) id <APXLocationServicesDelegate> geoDelegate;
@property (nonatomic, weak) id <APXLocationServicesDelegate> beaconDelegate;

+ (instancetype)shared;

/*!
 * Returns YES if location services 'always authorization' status, otherwize NO.
 */
- (BOOL)isAuthorizationStatusOK;

/* location API */

/*!
 * Calls startUpdatingLocation && startMonitoringSignificantLocationChanges.
 */
- (BOOL)startUpdatingLocation;

/*!
 * Only stops stopUpdatingLocation.
 */
- (void)stopUpdatingLocation;

/*!
 * Only stops stopMonitoringSignificantLocationChanges.
 */
- (void)stopUpdatingSignificantLocation;

/*!
 * will return an array of CLCircularRegion, or nil, if none available.
 */
- (NSArray *)geoMonitoredRegions;

/*!
 * Will remove ALL monitored regions of a given class. Should pass here CLCircularRegion || CLBeaconRegion instance.
 */
- (void)removeMonitoredRegionsOfClass:(id)regionInstance;

/*!
 * Adds an array of CLRegion objects to be monitored.
 */
- (void)addRegionsToMonitor:(NSArray <CLRegion *> *)regions;

/*!
 * Specifically for CLCircularRegion.
 */
- (void)removeMonitoredGeoRegions:(NSArray <CLCircularRegion *> *)geoRegions;


/* Beacons ranging */

- (void)startRangingBeaconsInRegion:(CLBeaconRegion *)beaconRegion;
- (void)stopRangingBeaconsInRegion:(CLBeaconRegion *)beaconRegion;
- (void)stopRangingAllBeacons;

@end