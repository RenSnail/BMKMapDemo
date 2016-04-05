//
//  CustomOverlay.h
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/30.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface CustomOverlay : BMKShape<BMKOverlay>
{
    @package
    BMKMapPoint *_points;
    int _pointCount;
    BMKMapRect _boundingMapRect;
}
@property (nonatomic, readonly) BMKMapRect boundingMapRect;
@property (nonatomic, readonly) BMKMapPoint* points;
@property (nonatomic, readonly) int pointCount;
-(id)initWithPoints:(BMKMapPoint *)points count:(NSUInteger)count;
+ (CustomOverlay *)customWithPoints:(BMKMapPoint *)points count:(NSUInteger)count;
@end

