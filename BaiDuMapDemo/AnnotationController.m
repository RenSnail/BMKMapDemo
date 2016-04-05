//
//  AnnotationController.m
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/30.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import "AnnotationController.h"
#import "LocationManger.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "MyAnimatedAnnotationView.h"

@interface AnnotationController ()<BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
/**圆形*/
@property (nonatomic , strong) BMKCircle *circle;
/**多边形*/
@property (nonatomic , strong) BMKPolygon *polygon;
/**折线*/
@property (nonatomic , strong) BMKPolyline *colorPolygon;
/**弧线*/
@property (nonatomic , strong) BMKArcline  *arcline;
/**PointAnnotation*/
@property (nonatomic , strong) BMKPointAnnotation *annotation;
/**AnimatedAnnotation*/
@property (nonatomic , strong) BMKPointAnnotation *animatedAnnotation;
/**自定义图片图层*/
@property (nonatomic , strong) BMKGroundOverlay *ground;
@end

@implementation AnnotationController

#pragma mark - 懒加载
-(BMKCircle *)circle {
    if (_circle == nil) {
        
        __block  CLLocationCoordinate2D coor ;
        
        [[LocationManger shareManager] getLocationWithBlock:^(BMKUserLocation *userLocation) {
          coor = userLocation.location.coordinate;
        }];
        
        _circle = [BMKCircle circleWithCenterCoordinate:coor radius:5000];
    }
    return _circle;
}

-(BMKPolygon *)polygon{
    if (_polygon == nil) {
        CLLocationCoordinate2D coords[4];
        coords[0].latitude = 39.915;
        coords[0].longitude = 116.404;
        coords[1].latitude = 39.815;
        coords[1].longitude = 116.404;
        coords[2].latitude = 39.815;
        coords[2].longitude = 116.504;
        coords[3].latitude = 39.915;
        coords[3].longitude = 116.504;
        _polygon = [BMKPolygon polygonWithCoordinates:coords count:4];
    }
    return _polygon;
    
}

-(BMKPolyline *)colorPolygon {
    if (_colorPolygon == nil) {
        CLLocationCoordinate2D coords[5];
        coords[0].latitude = 39.965;
        coords[0].longitude = 116.404;
        coords[1].latitude = 39.925;
        coords[1].longitude = 116.454;
        coords[2].latitude = 39.955;
        coords[2].longitude = 116.494;
        coords[3].latitude = 39.905;
        coords[3].longitude = 116.554;
        coords[4].latitude = 39.965;
        coords[4].longitude = 116.604;
        //构建分段颜色索引数组
       NSArray *colorIndexs =  @[@(2),@(0),@(1),@(2)];
        //构建BMKPolyline,使用分段颜色索引，其对应的BMKPolylineView必须设置colors属性
        _colorPolygon = [BMKPolyline polylineWithCoordinates:coords count:5 textureIndex:colorIndexs];
    }
    return _colorPolygon;
}

-(BMKArcline *)arcline {
    if (_arcline ==nil) {
        CLLocationCoordinate2D coords[3];
        coords[0].latitude = 40.065;
        coords[0].longitude = 116.124;
        coords[1].latitude = 40.125;
        coords[1].longitude = 116.304;
        coords[2].latitude = 40.065;
        coords[2].longitude = 116.404;
        _arcline = [BMKArcline arclineWithCoordinates:coords];
    }
    return  _arcline;
}

-(BMKPointAnnotation *)annotation {
    if (_annotation == nil) {
        _annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 39.915;
        coor.longitude = 116.404;
        _annotation.coordinate = coor;
        _annotation.title = @"我是标题";
        _annotation.subtitle = @"我是子标题";
    }
    return _annotation;
}

-(BMKPointAnnotation *)animatedAnnotation {
    if (_animatedAnnotation ==  nil) {
        _animatedAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 40.115;
        coor.longitude = 116.404;
        _animatedAnnotation.coordinate = coor;
        _animatedAnnotation.title = @"我是动画Annotation";
    }
    return _animatedAnnotation;
}

-(BMKGroundOverlay *)ground {
    if (_ground == nil) {
        CLLocationCoordinate2D coords[2];
        coords[0].latitude = 39.910;
        coords[0].longitude = 116.370;
        coords[1].latitude = 39.950;
        coords[1].longitude = 116.430;
        
        BMKCoordinateBounds bound;
        bound.southWest = coords[0];
        bound.northEast = coords[1];
        _ground = [BMKGroundOverlay groundOverlayWithBounds:bound icon:[UIImage imageNamed:@"test.png"]];
        _ground.alpha = 0.3;
    }
    return _ground;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.segmented addTarget:self action:@selector(segmentedValueChange:) forControlEvents:UIControlEventValueChanged];
    self.segmented.selectedSegmentIndex = 0;
}

-(void)segmentedValueChange:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self removeAllOverlaysAndAnnotations];
            //加圆形
            [self.mapView addOverlay:self.circle];
            //加多边形
            [self.mapView addOverlay:self.polygon];
            //折线
            [self.mapView addOverlay:self.colorPolygon];
            //弧线
            [self.mapView addOverlay:self.arcline];
            break;
        case 1:
            [self removeAllOverlaysAndAnnotations];
            //大头针
            [self.mapView addAnnotation:self.annotation];
            //动画大头针
            [self.mapView addAnnotation:self.animatedAnnotation];
            break;
        case 2:
            [self removeAllOverlaysAndAnnotations];
            //自定义图片
            [self.mapView addOverlay:self.ground];
            break;
        default:
            break;
    }
}

-(void)removeAllOverlaysAndAnnotations {
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
}



#pragma mark - mapViewDelegate

-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:0.5];
        circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.5];
        circleView.lineWidth = 5.0;
        return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        if (overlay == self.colorPolygon) {
            polylineView.lineWidth = 5;
            /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
            polylineView.colors = [NSArray arrayWithObjects:
                                   [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:0.5], nil];
        } else {
            polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
            polylineView.lineWidth = 20.0;
            [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"texture_arrow.png"]];
        }
        return polylineView;
    }
    if ([overlay isKindOfClass:[BMKPolygon class]]){
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
        polygonView.lineWidth =2.0;
        polygonView.lineDash = YES;
        return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]]){
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        arclineView.strokeColor = [UIColor blueColor];
        arclineView.lineDash = YES;
        arclineView.lineWidth = 6.0;
        return arclineView;
    }
    return nil;
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    //普通annotation
   
    if (annotation == self.annotation) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            UIView *paopao = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 20, 20)];
            paopao.backgroundColor = [UIColor redColor];
            BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:paopao];
            annotationView.paopaoView = paopaoView;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
        }
        return annotationView;
    }
    
    //动画annotation
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    MyAnimatedAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
        [images addObject:image];
    }
    annotationView.annotationImages = images;
    return annotationView;
}

@end
