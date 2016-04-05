//
//  CustomOverlayView.m
//  BaiDuMapDemo
//
//  Created by Snail on 16/3/30.
//  Copyright © 2016年 Snail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomOverlayView.h"

@implementation CustomOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (CustomOverlay *)customOverlay
{
    return (CustomOverlay*)self.overlay;
}
- (id)initWithCustomOverlay:(CustomOverlay *)customOverlay;
{
    self = [super initWithOverlay:customOverlay];
    if (self)
    {
        
    }
    
    return self;
}

- (void)glRender
{
    //自定义overlay绘制
    CustomOverlay *customOverlay = [self customOverlay];
    if (customOverlay.pointCount >= 3) {
        self->keepScale = NO;
        
        [self renderLinesWithPoints:customOverlay.points pointCount:customOverlay.pointCount strokeColor:self.strokeColor lineWidth:self.lineWidth looped:YES lineDash:YES];
        [self renderRegionWithPoints:customOverlay.points pointCount:customOverlay.pointCount fillColor:self.fillColor usingTriangleFan:YES];
    } else {
        GLuint testureID = [self loadStrokeTextureImage:[UIImage imageNamed:@"texture_arrow.png"]];
        if (testureID) {
            [self renderTexturedLinesWithPoints:customOverlay.points pointCount:customOverlay.pointCount lineWidth:30 textureID:testureID looped:NO];
        } else {
            [self renderLinesWithPoints:customOverlay.points pointCount:customOverlay.pointCount strokeColor:self.strokeColor lineWidth:self.lineWidth looped:NO];
        }
    }
    
}


@end

