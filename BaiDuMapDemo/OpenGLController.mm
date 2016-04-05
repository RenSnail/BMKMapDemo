//
//  OpenGLController.m
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/30.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import "OpenGLController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

typedef struct {
    GLfloat x;
    GLfloat y;
}GLPoint;

@interface OpenGLController ()<BMKMapViewDelegate>
{
    GLPoint glPoint[4];
    BOOL mapDidFinishLoad;
    BMKMapPoint mapPoints[4];
}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@end


@implementation OpenGLController

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
    mapDidFinishLoad = NO;
}

#pragma - mark  mapViewDelegate

-(void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    mapPoints[0] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.965, 116.604));
    mapPoints[1] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.865, 116.604));
    mapPoints[2] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.865, 116.704));
    mapPoints[3] = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.965, 116.704));
    mapDidFinishLoad = YES;
    [self glRender:[mapView getMapStatus]];
    [self.mapView mapForceRefresh];
}

/**地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口*/
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {
    if (mapDidFinishLoad) {
        [self glRender:status];
    }
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"当前的zoomlevel%f",mapView.zoomLevel);
}

- (void)glRender:(BMKMapStatus *)status {
    const CGFloat *components = CGColorGetComponents([UIColor colorWithRed:40/255.0 green:200/255.0 blue:50/255.0 alpha:0.5].CGColor);
    CGFloat red,green,blue,alpha;
    
    red = components[0];
    green = components[1];
    blue = components[2];
    alpha = components[3];
    //坐标系原点为地图中心点，此处转换坐标为相对坐标
    
    for (NSInteger i = 0; i < 4; i++) {
        CGPoint tempPt = [_mapView glPointForMapPoint:mapPoints[i]];
        glPoint[i].x = tempPt.x;
        glPoint[i].y = tempPt.y;
    }
    
    //获取缩放比例，18级比例尺为1:1基准
    float fZoomUnites = pow(2.f, 18.f - status.fLevel );
    
    glPushMatrix();
    glRotatef(status.fOverlooking, 1.0f, 0.0f, 0.0f);
    glRotatef(status.fRotation, 0.0f, 0.0f, 1.0f);
    
    fZoomUnites = 1/fZoomUnites;
    //缩放使随地图放大或缩小
    glScalef( fZoomUnites, fZoomUnites, fZoomUnites );
    glEnableClientState (GL_VERTEX_ARRAY);
    glEnable( GL_BLEND );
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    
    glColor4f(red, green, blue, alpha);
    glVertexPointer(2, GL_FLOAT, 0, glPoint);
    //绘制的点个数
    glDrawArrays( GL_TRIANGLE_FAN, 0, 4);
    
    glDisable( GL_BLEND );
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
    glColor4f( 1.0, 1.0, 1.0, 1.0 );
}

@end
