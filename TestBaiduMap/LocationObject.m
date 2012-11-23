//
//  LocationObject.m
//  TestBaiduMap
//
//  Created by GuanQinglong on 12-11-21.
//  Copyright (c) 2012年 GuanQinglong. All rights reserved.
//

#import "LocationObject.h"

@implementation LocationObject
@synthesize coordinate = _coordinate;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize titleString = _titleString;
@synthesize subTitleString = _subTitleString;

- (id) initWithTitle:(NSString *)atitle latitue:(float)alatitude longitude:(float)alongitude
{
    if(self=[super init])
    {
        self.titleString = atitle;
        self.latitude = alatitude;
        self.longitude = alongitude;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D currentCoordinate;
    currentCoordinate.latitude = self.latitude ;
    currentCoordinate.longitude = self.longitude;
    return currentCoordinate;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return self.titleString;
}
// optional
- (NSString *)subtitle
{
    return self.subTitleString;
}

- (void)dealloc
{
    [_titleString release];
    [_subTitleString release];
    [super dealloc];
}

@end
