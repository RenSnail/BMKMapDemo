//
//  BasesShowController.m
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/29.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import "BasesShowController.h"
#import "LocationManger.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface BasesShowController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic ,strong) BMKUserLocation *userLocation;
@property (nonatomic ,strong) BMKLocationService *service;
@end

@implementation BasesShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMyPlaceButton];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        NSLog(@"没有开启通知");
    }
    
    
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc]init];
    param.accuracyCircleFillColor = [UIColor redColor];
    param.accuracyCircleStrokeColor = [UIColor yellowColor];
    [self.mapView updateLocationViewWithParam:param];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocation:) name:LocationNotification object:nil];
}

-(void)getLocation:(NSNotification *)noti {
    BMKUserLocation *userLocation = noti.userInfo[LocationKey];
    NSLog(@" 收到通知 %f   %f" ,userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude );
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
    LocationManger *locManager = [LocationManger shareManager];
    //self.mapView.centerCoordinate = locManager.currentUserLocation.location.coordinate;
    [locManager getLocationWithBlock:^(BMKUserLocation *userLocation) {
        self.mapView.centerCoordinate = userLocation.location.coordinate;
    }];
    
    self.service = [[BMKLocationService alloc]init];
    [self.service startUserLocationService];
    self.service.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    self.userLocation = userLocation;
    [self.mapView updateLocationData:userLocation];
    NSLog(@" ******%@",userLocation.title);

}

- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"定位失败－－－%@",error);
}

-(void)addMyPlaceButton {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"我" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor darkGrayColor];
    button.frame = CGRectMake(0, 0, 50, 50);
    [button addTarget:self action:@selector(myplaceClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:button];
    
    UISegmentedControl *control1 = [[UISegmentedControl alloc]initWithItems:@[@"标准",@"卫星"]];
    control1.selectedSegmentIndex = 0;
    control1.frame = CGRectMake(50, 10, [UIScreen mainScreen].bounds.size.width - 90, 30);
    [control1 addTarget:self action:@selector(controlClick1:) forControlEvents:UIControlEventValueChanged];
    [self.mapView addSubview:control1];
 
}


-(void)controlClick1:(UISegmentedControl *)sender{
    NSInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self.mapView setMapType:BMKMapTypeStandard];
            break;
        case 1:
            [self.mapView setMapType:BMKMapTypeSatellite];
            break;
        default:
            break;
    }
}

-(void)myplaceClick {
    if (self.userLocation.location != nil) {
        [self.mapView setCenterCoordinate:self.userLocation.location.coordinate animated:YES];
        [self.mapView setZoomLevel:17];
        self.mapView.showsUserLocation = NO;
        self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        self.mapView.showsUserLocation = YES;//显示定位图层
    }
}



@end
