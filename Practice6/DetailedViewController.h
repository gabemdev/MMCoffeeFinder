//
//  DetailedViewController.h
//  Practice6
//
//  Created by Rockstar. on 1/29/15.
//  Copyright (c) 2015 Gabe Morales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoffeePlace.h"

@interface DetailedViewController : UIViewController

@property CoffeePlace *coffeePlace;
@property CLLocation *currentLocation;
@end
