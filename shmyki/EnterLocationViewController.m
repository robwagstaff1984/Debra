//
//  EnterLocationViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 23/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "EnterLocationViewController.h"
#import "ShmykiContstants.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "YourMykiCustomButton.h"
#import "GANTracker.h"
#import <QuartzCore/QuartzCore.h>

@implementation EnterLocationViewController

@synthesize selectedTransportType, stationLocations, stationsTable, tramButton, trainButton, busButton, stationsSearchBar;
@synthesize stationsForCurrentSelection, filteredStationsForCurrentSelection, isFiltered, selectedLocation, shadowWrapper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedTransportType = SELECTED_TRANSPORT_TRAM;
        stationLocations = [[StationLocations alloc] init];
        stationsForCurrentSelection = [[NSMutableArray alloc] init];
        stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
        selectedLocation = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(popNavigationController)];
    
    self.stationsSearchBar.delegate = self;
    self.stationsSearchBar.placeholder = @"Search Trams";
    self.navigationItem.title = @"yourLocation";
    
    self.shadowWrapper.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.shadowWrapper.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.shadowWrapper.layer.shadowOpacity = .90f;
    self.shadowWrapper.layer.shadowRadius = 2.0f;
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[GANTracker sharedTracker] trackPageview:@"enter location" withError:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) popNavigationController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int rowCount;
    if(self.isFiltered)
        rowCount = filteredStationsForCurrentSelection.count;
    else
        rowCount = stationsForCurrentSelection.count;
    
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIdentifier = @"stationLocationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                    reuseIdentifier:cellIdentifier];
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cell.textLabel setTextColor:[UIColor grayColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    if(isFiltered) {
        cell.textLabel.text = [self.filteredStationsForCurrentSelection objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [self.stationsForCurrentSelection objectAtIndex:indexPath.row];
    }
   
    NSIndexPath* selection = [tableView indexPathForSelectedRow];
    if (selection && selection.row == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark; 
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;  
    }
    
    return cell;
}


#pragma mark table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    selectedLocation = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] currentUsersPunchOnLog] setLocation:selectedLocation];
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] currentUsersPunchOnLog] setTransportationType:self.selectedTransportType];    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

#pragma mark search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
  //  NSLog(@"%@", [searchBar tintColor]);
    [UIView animateWithDuration:.2 animations:^(void){
            [self.stationsSearchBar setFrame:CGRectMake(0, searchBar.frame.origin.y, 320, 44)];
            
        } 
        completion:^(BOOL finished){
           
            //[stationsSearchBar setShowsCancelButton:YES animated:YES];
        }
     ];
    [stationsSearchBar setShowsCancelButton:YES animated:YES];
    UIButton *cancelButton = [[stationsSearchBar subviews] objectAtIndex:2]; 
   
    cancelButton.tintColor = [UIColor colorWithHue:0.6 saturation:0.20 brightness:0.67 alpha:1.0];
//     cancelButton.tintColor=[UIColor colorWithHue:150 saturation:150 brightness:30 alpha:1];
  //  cancelButton.tintColor = [UIColor blueColor];
   // cancelButton.tintColor=[UIColor colorWithRed:0.976471 green:0.976471 blue:0.976471 alpha:1];
  //  [[UIButton appearanceWhenContainedIn:[self.stationsSearchBar class], nil] setBackgroundImage:[UIImage imageNamed:@"images/ButtonHeader"] forState:UIControlStateNormal];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:.2 animations:^(void){
            [self.stationsSearchBar setFrame:CGRectMake(140, searchBar.frame.origin.y, 180, 44)];
        }
        completion:^(BOOL finished){
            //[stationsSearchBar setShowsCancelButton:YES animated:NO];
        }
    ];
    
}


-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    } else {
        isFiltered = true;
        filteredStationsForCurrentSelection = [[NSMutableArray alloc] init];
        
        for (NSString* stationLocation in stationsForCurrentSelection)
        {
            NSRange stationLocationRange = [stationLocation rangeOfString:text options:NSCaseInsensitiveSearch];
            if(stationLocationRange.location != NSNotFound)
            {
                [filteredStationsForCurrentSelection addObject:stationLocation];
            }
        }
    }
    [self.stationsTable reloadData];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [searchBar resignFirstResponder];
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [stationsSearchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:.2 animations:^(void){
        [self.stationsSearchBar setFrame:CGRectMake(140, searchBar.frame.origin.y, 180, 44)];
    }
         completion:^(BOOL finished){
             [searchBar resignFirstResponder];
         }
    ];
    
}

#pragma mark Actions

- (IBAction)tramButtonTapped:(id)sender {
    self.selectedTransportType = SELECTED_TRANSPORT_TRAM;
    [self updateTransportButtons];
    self.stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
    self.filteredStationsForCurrentSelection = nil;
    self.stationsSearchBar.text = @"";
    [self.stationsSearchBar resignFirstResponder];
    [self.stationsTable reloadData];
}
- (IBAction)trainButtonTapped:(id)sender {
    
    self.selectedTransportType = SELECTED_TRANSPORT_TRAIN;
    [self updateTransportButtons];
    self.stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
    self.filteredStationsForCurrentSelection = nil;
    self.stationsSearchBar.text = @"";
    [self.stationsSearchBar resignFirstResponder];
    [self.stationsTable reloadData];
}
- (IBAction)busButtonTapped:(id)sender {
    self.selectedTransportType = SELECTED_TRANSPORT_BUS;
    [self updateTransportButtons];
    self.stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
    self.filteredStationsForCurrentSelection = nil;
    self.stationsSearchBar.text = @"";
    [self.stationsSearchBar resignFirstResponder];
    [self.stationsTable reloadData];
}

-(void) updateTransportButtons {
    switch (self.selectedTransportType) {
        case SELECTED_TRANSPORT_TRAM:
            self.tramButton.selected=YES;
            self.trainButton.selected=NO;
            self.busButton.selected=NO;
            self.stationsSearchBar.placeholder = @"Search Trams";
            break;
        case SELECTED_TRANSPORT_TRAIN:
            self.tramButton.selected=NO;
            self.trainButton.selected=YES;
            self.busButton.selected=NO;
            self.stationsSearchBar.placeholder = @"Search Trains";
            break;
        case SELECTED_TRANSPORT_BUS:
            self.tramButton.selected=NO;
            self.trainButton.selected=NO;
            self.busButton.selected=YES;
            self.stationsSearchBar.placeholder = @"Search Buses";
        default:
            break;
    }
}


@end
