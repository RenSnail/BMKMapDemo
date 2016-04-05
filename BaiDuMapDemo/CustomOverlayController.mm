//
//  CustomOverlayController.m
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/30.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import "CustomOverlayController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "CustomOverlay.h"
#import "CustomOverlayView.h"

@interface CustomOverlayController ()<BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@end

@implementation CustomOverlayController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
}
-(void)dealloc {
    self.mapView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    CLLocationCoordinate2D coor1;
    coor1.latitude = 39.915;
    coor1.longitude = 116.404;
    BMKMapPoint pt1 = BMKMapPointForCoordinate(coor1);
    CLLocationCoordinate2D coor2;
    coor2.latitude = 40.015;
    coor2.longitude = 116.404;
    BMKMapPoint pt2 = BMKMapPointForCoordinate(coor2);
    BMKMapPoint * temppoints = new BMKMapPoint[2];
    temppoints[0].x = pt2.x;
    temppoints[0].y = pt2.y;
    temppoints[1].x = pt1.x;
    temppoints[1].y = pt1.y;
    CustomOverlay* custom = [[CustomOverlay alloc] initWithPoints:temppoints count:2];
    [self.mapView addOverlay:custom];
    delete temppoints;
    
    CLLocationCoordinate2D coor3;
    coor3.latitude = 39.915;
    coor3.longitude = 116.504;
    BMKMapPoint pt3 = BMKMapPointForCoordinate(coor3);
    CLLocationCoordinate2D coor4;
    coor4.latitude = 40.015;
    coor4.longitude = 116.504;
    BMKMapPoint pt4 = BMKMapPointForCoordinate(coor4);
    CLLocationCoordinate2D coor5;
    coor5.latitude = 39.965;
    coor5.longitude = 116.604;
    BMKMapPoint pt5 = BMKMapPointForCoordinate(coor5);
    BMKMapPoint * temppoints2 = new BMKMapPoint[3];
    temppoints2[0].x = pt3.x;
    temppoints2[0].y = pt3.y;
    temppoints2[1].x = pt4.x;
    temppoints2[1].y = pt4.y;
    temppoints2[2].x = pt5.x;
    temppoints2[2].y = pt5.y;
    CustomOverlay* custom2 = [[CustomOverlay alloc] initWithPoints:temppoints2 count:3];
    [self.mapView addOverlay:custom2];
    delete temppoints2;
    
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[CustomOverlay class]]){
        CustomOverlayView* cutomView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        cutomView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        cutomView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        cutomView.lineWidth = 5.0;
        return cutomView;
    }
    return nil;
}



@end
