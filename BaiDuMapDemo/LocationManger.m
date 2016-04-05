//
//  LocationManger.m
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/29.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import "LocationManger.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface LocationManger ()<BMKLocationServiceDelegate>
@property (nonatomic, strong) BMKUserLocation *currentUserLocation;
@end

static LocationManger *manager;
static BMKLocationService *service;
@implementation LocationManger

+(LocationManger *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LocationManger alloc]init];
    });
    return manager;
}

-(void)startService{
    service = [[BMKLocationService alloc]init];
    service.delegate = manager;
    [service startUserLocationService];
}

-(void)getLocationWithBlock:(currentLocationBlock)block{
    block(self.currentUserLocation);
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    self.currentUserLocation = userLocation;
    [[NSNotificationCenter defaultCenter]postNotificationName:LocationNotification object:nil userInfo:@{LocationKey:userLocation}];
}

-(void)stopService {
    [service stopUserLocationService];
    service = nil;
    manager = nil;
}

@end
