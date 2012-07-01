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

@implementation EnterLocationViewController

@synthesize selectedTransportType, stationLocations, stationsTable, tramButton, trainButton, busButton, stationsSearchBar;
@synthesize stationsForCurrentSelection, filteredStationsForCurrentSelection, isFiltered;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedTransportType = SELECTED_TRANSPORT_TRAM;
        stationLocations = [[StationLocations alloc] init];
        stationsForCurrentSelection = [[NSMutableArray alloc] init];
        stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self
                                              action:@selector(savePunchOnLog)];
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [cell.textLabel setTextColor:[UIColor grayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

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
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}

#pragma mark search bar delegate

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

#pragma mark Actions

-(void) savePunchOnLog {
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] postToFacebook];
}

- (IBAction)tramButtonTapped:(id)sender {
    self.selectedTransportType = SELECTED_TRANSPORT_TRAM;
    self.stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
    self.filteredStationsForCurrentSelection = nil;
    self.stationsSearchBar.text = @"";
    [self.stationsSearchBar resignFirstResponder];
    [self.stationsTable reloadData];
}
- (IBAction)trainButtonTapped:(id)sender {
    self.selectedTransportType = SELECTED_TRANSPORT_TRAIN;
    self.stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
    self.filteredStationsForCurrentSelection = nil;
    self.stationsSearchBar.text = @"";
    [self.stationsSearchBar resignFirstResponder];
    [self.stationsTable reloadData];
}
- (IBAction)busButtonTapped:(id)sender {
    self.selectedTransportType = SELECTED_TRANSPORT_BUS;
    self.stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
    self.filteredStationsForCurrentSelection = nil;
    self.stationsSearchBar.text = @"";
    [self.stationsSearchBar resignFirstResponder];
    [self.stationsTable reloadData];
}

@end
