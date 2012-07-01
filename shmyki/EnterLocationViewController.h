//
//  EnterLocationViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 23/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StationLocations.h"

@interface EnterLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSIndexPath* lastIndexPath; 
}

@property NSInteger selectedTransportType;
@property (nonatomic, strong) StationLocations *stationLocations;
@property (nonatomic, strong) IBOutlet UITableView *stationsTable;

@property (nonatomic, strong) IBOutlet UIButton *tramButton;
@property (nonatomic, strong) IBOutlet UIButton *trainButton;
@property (nonatomic, strong) IBOutlet UIButton *busButton;
@property (nonatomic, strong) NSMutableArray *stationsForCurrentSelection;
@property (nonatomic, strong) NSMutableArray *filteredStationsForCurrentSelection;

@property (nonatomic, strong) IBOutlet UISearchBar *stationsSearchBar;
@property (nonatomic, strong) NSString *selectedLocation;

@property BOOL isFiltered;

- (IBAction)tramButtonTapped:(id)sender;
- (IBAction)trainButtonTapped:(id)sender;
- (IBAction)busButtonTapped:(id)sender;

@end
