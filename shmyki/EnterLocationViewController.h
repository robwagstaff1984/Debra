//
//  EnterLocationViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 23/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationLocations.h"

@interface EnterLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSInteger selectedTransportType;
@property (nonatomic, strong) StationLocations *stationLocations;
@property (nonatomic, strong) IBOutlet UITableView *stationsTable;

@property (nonatomic, strong) IBOutlet UIButton *tramButton;
@property (nonatomic, strong) IBOutlet UIButton *trainButton;
@property (nonatomic, strong) IBOutlet UIButton *busButton;
@property (nonatomic, strong) IBOutlet NSMutableArray *stationsForCurrentSelection;

- (IBAction)tramButtonTapped:(id)sender;
- (IBAction)trainButtonTapped:(id)sender;
- (IBAction)busButtonTapped:(id)sender;

@end
