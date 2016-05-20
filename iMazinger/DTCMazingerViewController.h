//
//  DTCMazingerViewController.h
//  iMazinger
//
//  Created by David de Tena on 20/05/16.
//  Copyright © 2016 David de Tena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DTCMazingerViewController : UIViewController

#pragma mark - Init
-(id) initWithAnnotationObject:(id<MKAnnotation>) model;

@end
