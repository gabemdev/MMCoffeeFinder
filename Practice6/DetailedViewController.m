//
//  DetailedViewController.m
//  Practice6
//
//  Created by Rockstar. on 1/29/15.
//  Copyright (c) 2015 Gabe Morales. All rights reserved.
//

#import "DetailedViewController.h"

@interface DetailedViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _coffeePlace.mapItem.name;
    [self getPathDirections:_currentLocation.coordinate withDestination:_coffeePlace.mapItem.placemark.location.coordinate];
}

- (void)getPathDirections:(CLLocationCoordinate2D)source withDestination:(CLLocationCoordinate2D)destination {
    MKPlacemark *placeMarkSrc = [[MKPlacemark alloc] initWithCoordinate:source addressDictionary:nil];
    MKMapItem *mapItemSrc = [[MKMapItem alloc] initWithPlacemark:placeMarkSrc];
    
    MKPlacemark *placeMarkDest = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    MKMapItem *mapItemDest = [[MKMapItem alloc] initWithPlacemark:placeMarkDest];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:mapItemSrc];
    [request setDestination:mapItemDest];
    
    [request setTransportType:MKDirectionsTransportTypeWalking];
    request.requestsAlternateRoutes = nil;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        MKRoute *route = response.routes.lastObject;
        NSString *allSteps = [NSString new];
        for (int i = 0; i < route.steps.count; i++) {
            MKRouteStep *step = [route.steps objectAtIndex:i];
            NSString *newStepString = step.instructions;
            allSteps = [allSteps stringByAppendingString:newStepString];
            allSteps = [allSteps stringByAppendingString:@"\n\n"];
        }
        _textView.text = allSteps;
    }];
    
}


@end
