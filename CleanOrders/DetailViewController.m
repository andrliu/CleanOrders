//
//  DetailViewController.m
//  CleanOrders
//
//  Created by Andrew Liu on 6/13/15.
//  Copyright (c) 2015 Andrew Liu. All rights reserved.
//

#import "DetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *googleMap;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Detail";
    self.label.text = self.dic[@"cleanerName"];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.dic[@"latitude"] floatValue]
                                                            longitude:[self.dic[@"longitude"] floatValue]
                                                                 zoom:15];
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.googleMap.bounds camera:camera];
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = self.dic[@"address"];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;
    [self.googleMap addSubview: mapView];
}

@end
