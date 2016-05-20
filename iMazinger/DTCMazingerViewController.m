//
//  DTCMazingerViewController.m
//  iMazinger
//
//  Created by David de Tena on 20/05/16.
//  Copyright © 2016 David de Tena. All rights reserved.
//

#import "DTCMazingerViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DTCMazingerViewController ()

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) id<MKAnnotation> model;

@end

@implementation DTCMazingerViewController

#pragma mark - Init
-(id) initWithAnnotationObject:(id<MKAnnotation>) model{
    if (self = [super initWithNibName:nil bundle:nil]) {
        // Save annotation
        _model = model;
        self.title = @"iMazinger";
    }
    return self;
}

#pragma mark - View lifecycle

// Add annotation (model) to our mapView before showing the map
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mapView addAnnotation:self.model];
}

// Once the map is displayed, set region to display, animating, in 2 steps:
// 1.- Center region in Spain
// 2.- After a delay, center in the model coordinates
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    MKCoordinateRegion regionSpain = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 1000000, 1000000);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 200, 200);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mapView setRegion:regionSpain animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mapView setRegion:region animated:YES];
        });
    });
    
    
}


#pragma mark - Actions
- (IBAction)vectorialMap:(id)sender {
    
}

- (IBAction)satelliteMap:(id)sender {
    
}

- (IBAction)hybridMap:(id)sender {
    
}

@end
