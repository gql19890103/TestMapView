//
//  LocationObject.h
//  TestBaiduMap
//
//  Created by GuanQinglong on 12-11-21.
//  Copyright (c) 2012年 GuanQinglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationObject : NSObject <MKAnnotation>
{
//    CLLocationCoordinate2D coordinate;
//    NSString *_titleString; //title值
//    NSString *_subTitleString;
//    float _latitude; // 经度值
//    float _longitude; //纬度值
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property float latitude; // 经度值
@property float longitude; //纬度值
@property (nonatomic, copy) NSString *titleString; //title值
@property (nonatomic, copy) NSString *subTitleString;

- (id)initWithTitle:(NSString *)atitle latitue:(float)alatitude longitude:(float)alongitude;

@end
