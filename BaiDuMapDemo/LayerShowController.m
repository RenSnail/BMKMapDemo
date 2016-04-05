//
//  LayerShowController.m
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/29.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import "LayerShowController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "LocationManger.h"

@interface LayerShowController ()
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@end

@implementation LayerShowController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LocationManger *locManager = [LocationManger shareManager];
    [locManager getLocationWithBlock:^(BMKUserLocation *userLocation) {
        self.mapView.centerCoordinate = userLocation.location.coordinate;
    }];
    
    self.mapView.zoomLevel = 18;
   
    
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc]init];
    param.accuracyCircleFillColor = [UIColor redColor];
    param.accuracyCircleStrokeColor = [UIColor yellowColor];
    [self.mapView updateLocationViewWithParam:param];
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)lukuang:(UISwitch *)sender {
    if (sender.isOn) {
        [self.mapView setTrafficEnabled:YES];
    }else {
        [self.mapView setTrafficEnabled:NO];
    }
}


- (IBAction)heatMap:(UISwitch *)sender {
    if (sender.isOn) {
        [self.mapView setBaiduHeatMapEnabled:YES];
    }else {
        [self.mapView setBaiduHeatMapEnabled:NO];
    }

}
- (IBAction)diceng:(UISwitch *)sender {
    if (sender.isOn) {
        [self.mapView setShowMapPoi:YES];
    }else {
        [self.mapView setShowMapPoi:NO];
    }
}

@end
