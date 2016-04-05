//
//  LocationManger.h
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/29.
//  Copyright © 2016年 Snail. All rights reserved.
//




#import <Foundation/Foundation.h>

@class BMKUserLocation;

typedef void(^currentLocationBlock)(BMKUserLocation *userLocation);

@interface LocationManger : NSObject


+(LocationManger *)shareManager;
-(void)startService;
-(void)stopService;
-(void)getLocationWithBlock:(currentLocationBlock)block;

@end
