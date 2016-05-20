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
@import MessageUI;

@interface DTCMazingerViewController ()<MKMapViewDelegate, MFMailComposeViewControllerDelegate>

#pragma mark - Properties
@property (nonatomic) BOOL isFirstDisplayed;
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
    self.mapView.delegate = self;
}

// Once the map is displayed, set region to display, animating, in 2 steps:
// 1.- Center region in Spain
// 2.- After a delay, center in the model coordinates
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Make the animation to the region only once
    if (!self.isFirstDisplayed) {
        self.isFirstDisplayed = !self.isFirstDisplayed;
        MKCoordinateRegion regionSpain = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 1000000, 1000000);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 200, 200);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mapView setRegion:regionSpain animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mapView setRegion:region animated:YES];
            });
        });
    }
}


#pragma mark - Actions
- (IBAction)vectorialMap:(id)sender {
    self.mapView.mapType = MKMapTypeStandard;
}

- (IBAction)satelliteMap:(id)sender {
    self.mapView.mapType = MKMapTypeSatellite;
}

- (IBAction)hybridMap:(id)sender {
    self.mapView.mapType = MKMapTypeHybrid;
}


#pragma mark - MKMapViewDelegate
-(MKAnnotationView *) mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *reuseID = @"Mazinger";
    
    // Recycle if possible
    MKPinAnnotationView *mazingerPin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    
    if (mazingerPin == nil) {
        mazingerPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        
        // Change color
        mazingerPin.pinColor = MKPinAnnotationColorPurple;
        
        // Callout with left image and right button
        mazingerPin.canShowCallout = YES;
        
        UIImageView *mz = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mazinger.png"]];
        // Buton with action nil because we set action in proper Delegate method
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [btn addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        
        mazingerPin.leftCalloutAccessoryView = mz;
        mazingerPin.rightCalloutAccessoryView = btn;
    }
    return mazingerPin;
}


// What to do when tapping the MapAnnotationAccessoryControl
-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    // Compose AlertController with an activity indicator while loading Mail composer
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading..." preferredStyle:UIAlertControllerStyleAlert];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(10, 5, 50, 50);
    activityView.hidesWhenStopped = YES;
    [activityView startAnimating];
    [alert.view addSubview:activityView];
    [self presentViewController:alert animated:YES completion:nil];
    
    // Create Snapshot with the current region to send by email
    MKMapSnapshotOptions *options = [MKMapSnapshotOptions new];
    options.region = self.mapView.region;
    options.mapType = MKMapTypeHybrid;
    
    MKMapSnapshotter *shotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [shotter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error while creating the snapshot\n%@", error);
        }
        else{
            // Dismiss loader
            [self dismissViewControllerAnimated:YES completion:^{
                // Send by email with specific modal VC
                MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
                [mailVC setSubject:self.model.title];
                mailVC.mailComposeDelegate = self;
                
                // Create attached file with snapshot
                NSData *imageData = UIImageJPEGRepresentation(snapshot.image, 0.9);
                [mailVC addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"mazingerMap.jpg"];
                [self presentViewController:mailVC animated:YES completion:nil];
            }];
        }
    }];
}


#pragma mark - MFMailComposeViewControllerDelegate
-(void) mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
