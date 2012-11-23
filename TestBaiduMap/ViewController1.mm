//
//  ViewController1.m
//  TestBaiduMap
//
//  Created by GuanQinglong on 12-11-21.
//  Copyright (c) 2012年 GuanQinglong. All rights reserved.
//

#import "ViewController1.h"


@interface ViewController1 ()

@property (nonatomic , retain) MKMapView *myMapView;
@property (nonatomic , retain) CLLocationManager *locManager;
@property (nonatomic , retain) NSMutableArray *mapAnnotations_arr;
@property (nonatomic , retain) id <MKAnnotation> myAnnotation;
@property (nonatomic , retain) MKAnnotationView * newAnnotation;

@end

@implementation ViewController1
@synthesize myMapView = _myMapView;
@synthesize locManager = _locManager;
@synthesize mapAnnotations_arr = _mapAnnotations_arr;

- (void)dealloc
{
    [_myMapView release];
    [_mapAnnotations_arr release];
    
    [super dealloc];
}

- (void)searchWords:(NSString *)string
{   
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    [geocoder geocodeAddressString:string completionHandler:
     ^(NSArray *placemarks, NSError *error)
    {
         //得到自己当前最近的地名
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        [self.myMapView setCenterCoordinate:placemark.location.coordinate animated:YES];
        
        LocationObject *objct = [[LocationObject alloc] initWithTitle:locatedAt latitue:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
        [self.myMapView removeAnnotations:self.myMapView.annotations];
        [self.mapAnnotations_arr removeAllObjects];
        [self.mapAnnotations_arr addObject:objct];
        [self.myMapView addAnnotations:self.mapAnnotations_arr];
        [objct release];
        
     }];


}

- (void)rightBarButtonAction
{
    [self searchWords:@"长春市长春西站"];
}

- (void)getTapPositionAddressWithLocation:(CLLocation *)locations
{
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    [geocoder reverseGeocodeLocation: locations completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //得到自己当前最近的地名
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         LocationObject *objct = [[LocationObject alloc] initWithTitle:locatedAt latitue:locations.coordinate.latitude longitude:locations.coordinate.longitude];
         [self.myMapView removeAnnotations:self.myMapView.annotations];
         [self.mapAnnotations_arr removeAllObjects];
         [self.mapAnnotations_arr addObject:objct];
         [self.myMapView addAnnotations:self.mapAnnotations_arr];
         [objct release];
         

     }];
}

- (NSString *)getCurrentLocationAdrressWithLocation:(CLLocation *)locations
{
    NSString *adressStr = nil;
    
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    [geocoder reverseGeocodeLocation: locations completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //得到自己当前最近的地名
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         [adressStr stringByAppendingFormat:@"%@",locatedAt];
         
     }];
    
    return adressStr;
}

- (void)reset_myLocation
{
    [self.myMapView setCenterCoordinate:self.myMapView.userLocation.location.coordinate animated:YES];
//    [self getTapPositionAddressWithLocation:self.myMapView.userLocation.location];
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer
{
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.myMapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.myMapView convertPoint:touchPoint toCoordinateFromView:self.myMapView];//这里touchMapCoordinate就是该点的经纬度了
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    [self getTapPositionAddressWithLocation:loc];
    [loc release];
    
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
//    if (annotationa) {
//        
//        [self.mapView   removeAnnotation:annotationa];
//        
//    }
//    annotationa =[[[DisplayMap alloc]  initWithCoordinate:touchMapCoordinate]  autorelease];
//    
//    
//    [self.myMapView   addAnnotation:annotationa];
    
    
    
    
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    // Initialize each view
    for (MKPinAnnotationView *mkaview in views)
    {
        if ([mkaview isKindOfClass:[MKPinAnnotationView class]])
        {
            // 当前位置 的大头针设为紫色，并且没有右边的附属按钮
//            TSLog(mkaview.annotation.title);
            NSString *localStr = [self getCurrentLocationAdrressWithLocation:self.myMapView.userLocation.location];
            if ([mkaview.annotation.title isEqualToString:localStr])
            {
                mkaview.pinColor = MKPinAnnotationColorPurple;
                
            }else{
                
                mkaview.pinColor = MKPinAnnotationColorRed;

            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            mkaview.rightCalloutAccessoryView = button;
        }
        
        
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    ///// 自动显示 Callout

    _myAnnotation = annotation;
    [self performSelector:@selector(showCallout) withObject:self afterDelay:0.1];
    
    return _newAnnotation;
}

- (void)showCallout
{
    [self.myMapView selectAnnotation:_myAnnotation animated:YES];
}

- (void)viewDidLoad
{
    _mapAnnotations_arr = [[NSMutableArray alloc] init];
   	_myMapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	_myMapView.delegate = self;
    //在这里先让地图视图隐藏起来，
    //等获取当前经纬度完成后在把整个地图显示出来
    _myMapView.hidden = true;
    self.view = self.myMapView;
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.myMapView addGestureRecognizer:mTap];
    [mTap release];
    
    //创建定位管理器，
    _locManager = [[CLLocationManager alloc] init];
    [_locManager setDelegate:self];
    [_locManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"my location" style:UIBarButtonItemStyleDone target:self action:@selector(reset_myLocation)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"search" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction)] autorelease];
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    //开始使用手机定位，这是一个回调方法，
    //一旦定位完成后程序将进入
    //- (void)locationManager:(CLLocationManager *)manager
    //didUpdateToLocation:(CLLocation *)newLocation
    //fromLocation:(CLLocation *)oldLocation
    //方法中
    
    [_locManager startUpdatingLocation];
    
}

//定位成功后将进入此方法
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    //得到当前定位后的经纬度，当前经纬度是有一定偏移量的，
    //使用另一种方法可以很好的解决这个问题
//    CLLocationCoordinate2D loc = [newLocation coordinate];
//    float lat =  loc.latitude;
//    float lon = loc.longitude;
    
    //让MapView使用定位功能。
    self.myMapView.showsUserLocation =YES;
    
    //更新地址，
    [manager stopUpdatingLocation];
    
    //设置定位后的自定义图标。
    MKCircle* circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(self.myMapView.userLocation.location.coordinate.latitude, self.myMapView.userLocation.location.coordinate.longitude) radius:500];
    
    //一定要使用addAnnotation 方法把MKCircle加入进视图，
    // 否则下面刷新图标的方法是永远不会进入的 - (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
    //切记！！！！
    [self.myMapView addAnnotation:circle];
    
    //我们需要通过当前用户的经纬度换成出它现在在地图中的地名
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    [geocoder reverseGeocodeLocation: _locManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //得到自己当前最近的地名
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         //locatedAt就是当前我所在的街道名称
         //上图中的中国北京市朝阳区慧中北路
         [self.myMapView.userLocation setTitle:locatedAt];
         
         //这里是设置地图的缩放，如果不设置缩放地图就非常的尴尬，
         //只能光秃秃的显示中国的大地图，但是我们需要更加精确到当前所在的街道，
         //那么就需要设置地图的缩放。
         MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
         theRegion.center= self.myMapView.userLocation.location.coordinate;
         
         //缩放的精度。数值越小约精准
         theRegion.span.longitudeDelta = 0.01f;
         theRegion.span.latitudeDelta = 0.01f;
         //让MapView显示缩放后的地图。
         [self.myMapView setRegion:theRegion animated:YES];
         
         //最后让MapView整体显示， 因为截至到这里，我们已经拿到用户的经纬度，
         //并且已经换算出用户当前所在街道的名称。
         self.myMapView.hidden = false;
     }];
    
}

//定位失败后将进入此方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if ( [error code] == kCLErrorDenied )
    {
        
        //第一次安装含有定位功能的软件时
        //程序将自定提示用户是否让当前App打开定位功能，
        //如果这里选择不打开定位功能，
        //再次调用定位的方法将会失败，并且进到这里。
        //除非用户在设置页面中重新对该软件打开定位服务，
        //否则程序将一直进到这里。
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务已经关闭"
                                                        message:@"请您在设置页面中打开本软件的定位服务"
                                                       delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        [manager stopUpdatingHeading];
    }
    else if ([error code] == kCLErrorHeadingFailure)
    {
        
    }
}



@end





