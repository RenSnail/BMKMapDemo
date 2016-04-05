//
//  LBSSearchController.m
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/31.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import "LBSSearchController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "LocationManger.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface LBSSearchController ()<BMKMapViewDelegate,BMKCloudSearchDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic , strong) BMKCloudSearch *search;
@property (nonatomic , strong) NSArray <BMKCloudPOIInfo *>* infoArray;
@property (nonatomic , strong) BMKPolygon *polygon;
@property (nonatomic , strong) BMKCircle *circle;
@end

@implementation LBSSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.search = [[BMKCloudSearch alloc]init];
    self.search.delegate = self;
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 15;
    self.mapView.isSelectedAnnotationViewFront = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LocationManger *locManager = [LocationManger shareManager];
    [locManager getLocationWithBlock:^(BMKUserLocation *userLocation) {
        self.mapView.centerCoordinate = userLocation.location.coordinate;
    }];
    
}

-(void)dealloc {
    self.mapView.delegate = nil;
    self.search.delegate = nil;
}

- (IBAction)cloudSearchClick:(id)sender {
    BMKCloudLocalSearchInfo *cloudLocalSearch = [[BMKCloudLocalSearchInfo alloc]init];
    cloudLocalSearch.ak = @"Qf8QHVPsazNCB9rOcC1QwYHxqw6u2Lbi";//token
    cloudLocalSearch.geoTableId = 137105;//主键
    cloudLocalSearch.pageIndex = 0;
    cloudLocalSearch.pageSize = 10;
    cloudLocalSearch.region = @"长春市";
    cloudLocalSearch.keyword = @"A";
    cloudLocalSearch.tags = @"rp";
    
    if([_search localSearchWithSearchInfo:cloudLocalSearch]){
        NSLog(@"本地云检索发送成功");
    }
    else{
        NSLog(@"本地云检索发送失败");
    }
}


#pragma mark - BMKCloudSearchDelegate
- (void)onGetCloudPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (error == BMK_CLOUD_NO_ERROR) {
        BMKCloudPOIList *result = [poiResultList firstObject];
        self.infoArray = result.POIs;
        
        for (int i = 0; i < result.POIs.count; i ++) {
            BMKCloudPOIInfo *poi = result.POIs[i];
            
            //poi.longitude -- 43.911186  43.910770 43.907875
            NSLog(@" ########## %f",poi.longitude);
            
            
            BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){poi.longitude , poi.latitude};
            item.coordinate = pt;
            item.title = poi.title;
            [self.mapView addAnnotation:item];
            
            BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:pt radius:200];
            [self.mapView addOverlay:circle];

            
            if (i == 0) {
                self.mapView.centerCoordinate = pt;
                
            }

        } 
    }else {
        NSLog(@"云检索回调失败--%d",error);
    }
}



- (void)onGetCloudPoiDetailResult:(BMKCloudPOIInfo*)poiDetailResult searchType:(int)type errorCode:(int)error {
    
    // 清楚屏幕中所有的annotation
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (error == BMKErrorOk) {
        BMKCloudPOIInfo* poi = poiDetailResult;
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){ poi.longitude,poi.latitude};
        item.coordinate = pt;
        item.title = poi.title;
        [_mapView addAnnotation:item];
        //将第一个点的坐标移到屏幕中央
        _mapView.centerCoordinate = pt;
    } else {
        NSLog(@"error ==%d",error);
    }
    
}

#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"AMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        BMKPointAnnotation *item = (BMKPointAnnotation *)annotation;
        if ([item.title isEqualToString:@"A1"]) {
            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        } else if ([item.title isEqualToString:@"A2"]) {
            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorGreen;
        } else {
            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorPurple;
        }
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    return annotationView;
}

//每画一个调一次
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(BMKCircle *)overlay {
    
    //poi.longitude -- 43.911186  43.910770 43.907875
    
    if ((float)overlay.coordinate.longitude == 43.911186) {
        BMKCircleView *view = [[BMKCircleView alloc]initWithCircle:overlay];
        view.fillColor = [UIColor colorWithRed:221/255.0 green:112/255.0 blue:212/255.0 alpha:0.5];
        view.strokeColor = [UIColor colorWithRed:121/255.0 green:112/255.0 blue:212/255.0 alpha:0.5];
        return view;
    }else if ((float)overlay.coordinate.longitude == 43.910770) {
        BMKCircleView *view = [[BMKCircleView alloc]initWithCircle:overlay];
        view.fillColor = [UIColor colorWithRed:231/255.0 green:192/255.0 blue:212/255.0 alpha:0.5];
        view.strokeColor = [UIColor colorWithRed:121/255.0 green:132/255.0 blue:212/255.0 alpha:0.5];
        return view;
    }else  {
        BMKCircleView *view = [[BMKCircleView alloc]initWithCircle:overlay];
        view.fillColor = [UIColor colorWithRed:231/255.0 green:192/255.0 blue:212/255.0 alpha:0.5];
        view.strokeColor = [UIColor colorWithRed:121/255.0 green:132/255.0 blue:212/255.0 alpha:0.5];
        return view;
    }

}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
}

@end