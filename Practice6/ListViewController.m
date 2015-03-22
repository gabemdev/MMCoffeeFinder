//
//  ListViewController.m
//  Practice6
//
//  Created by Rockstar. on 1/29/15.
//  Copyright (c) 2015 Gabe Morales. All rights reserved.
//

#import "ListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "CoffeePlace.h"
#import "DetailedViewController.h"

@interface ListViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) NSArray *coffeePlacesArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    [self updateCurrentLocation];
    
}

#pragma mark - Helper Methods
- (void)updateCurrentLocation {
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    _currentLocation =  locations[0];
    NSLog(@"%@", _currentLocation);
    [_locationManager stopUpdatingLocation];
    
    [self findCoffeePlaces:_currentLocation];
}

- (void)findCoffeePlaces:(CLLocation *)location {
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"Coffee";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.05, .05));
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSArray *mapItems = response.mapItems;
        NSMutableArray *temporaryArray = [NSMutableArray new];
        
        for (int i = 0; i < 5; i++) {
            MKMapItem *mapItem = [mapItems objectAtIndex:i];
            
            CLLocationDistance metersAway = [mapItem.placemark.location distanceFromLocation:location];
            float milesDifference = metersAway / 1609.34;
            
            CoffeePlace *coffeePlace = [[CoffeePlace alloc] init];
            coffeePlace.mapItem = mapItem;
            coffeePlace.milesDifference = milesDifference;
            
            [temporaryArray addObject:coffeePlace];
        }
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"milesDifference" ascending:YES];
        NSArray *sortedArray = [temporaryArray sortedArrayUsingDescriptors:@[sortDescriptor]];
        _coffeePlacesArray = [NSArray arrayWithArray:sortedArray];
        [_tableView reloadData];
       
    }];
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _coffeePlacesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [[[_coffeePlacesArray objectAtIndex:indexPath.row] mapItem] name];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailedViewController *detailedVC = [segue destinationViewController];
    detailedVC.coffeePlace = [_coffeePlacesArray objectAtIndex:_tableView.indexPathForSelectedRow.row];
    detailedVC.currentLocation = _currentLocation;
    
    
}
@end
