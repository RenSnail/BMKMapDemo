//
//  GeoController.m
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/29.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import "GeoController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface GeoController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *adress;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic ,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic,assign) BOOL isGeoSearch;
@end

@implementation GeoController

-(BMKGeoCodeSearch *)geoCodeSearch {
    if (_geoCodeSearch == nil) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    }
    return _geoCodeSearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setZoomLevel:18];
    self.city.text = @"长春市";
    self.adress.text = @"同志街1893号";
    self.longitude.text = @"43.878118";
    self.latitude.text = @"125.3243";
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
    self.geoCodeSearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    self.geoCodeSearch.delegate = nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.city resignFirstResponder];
    [self.adress resignFirstResponder];
    [self.longitude resignFirstResponder];
    [self.latitude resignFirstResponder];
}

#pragma mark -BMKMapViewDelelgate
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    return annotationView;
}


#pragma mark -BMKGeoCodeSearchDelelgate
/**
 *返回地址信息搜索结果
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"geo成功 --- %@",result);
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.latitude,item.coordinate.longitude];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
    
    
}

/**
 *返回反地理编码搜索结果
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}


- (IBAction)geo:(id)sender {
    if (self.city.text != nil && self.adress.text != nil) {
        self.isGeoSearch = YES;
        BMKGeoCodeSearchOption *option = [[BMKGeoCodeSearchOption alloc]init];
        option.city = self.city.text;
        option.address = self.adress.text;
        if ([self.geoCodeSearch geoCode:option]) {
            NSLog(@"geo成功");
        }else {
            NSLog(@"geo失败");
        }
    }
}

- (IBAction)reversGeo:(id)sender {
    self.isGeoSearch = NO;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0,0};
    if (self.longitude.text != nil && self.latitude.text != nil) {
        pt = (CLLocationCoordinate2D){[self.longitude.text floatValue],[self.latitude.text floatValue]};
        BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
        option.reverseGeoPoint = pt;
        if ([self.geoCodeSearch reverseGeoCode:option]) {
            NSLog(@"反geo检索发送成功");
        }else {
            NSLog(@"反geo检索发送失败");
        }
    }
}

@end
