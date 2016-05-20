//
//  DTCMazingerZ.m
//  iMazinger
//
//  Created by David de Tena on 20/05/16.
//  Copyright © 2016 David de Tena. All rights reserved.
//

#import "DTCMazingerZ.h"

@implementation DTCMazingerZ

-(id) init{
    if (self = [super init]) {
        // Assign value to instance variable _coordinate instead of self.coordinate
        // to avoid implementing method setCoordinate from protocol when initializing
        _coordinate = CLLocationCoordinate2DMake(41.3828722, 1.3291443);
    }
    return self;
}


#pragma mark - MKAnnonation
@synthesize coordinate = _coordinate;

-(NSString *) title{
    return @"Estatua de Mazinger Z";
}

-(NSString *) subtitle{
    return @"Meca de frikis y otakus";
}


@end
