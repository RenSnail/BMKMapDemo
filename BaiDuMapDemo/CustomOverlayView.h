//
//  CustomOverlayView.h
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/30.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "CustomOverlay.h"

@interface CustomOverlayView : BMKOverlayGLBasicView
- (id)initWithCustomOverlay:(CustomOverlay *)customOverlay;
@property (nonatomic, readonly) CustomOverlay *customOverlay;
@end