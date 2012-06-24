//
//  EnterLocationViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 23/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "EnterLocationViewController.h"
#import "ShmykiContstants.h"

@implementation EnterLocationViewController

@synthesize selectedTransportType, stationLocations, stationsTable, tramButton, trainButton, busButton;
@synthesize stationsForCurrentSelection;

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
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
    return [self.stationsForCurrentSelection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIdentifier = @"stationLocationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   // 
    if(cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                    reuseIdentifier:cellIdentifier];
        
        

        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    cell.textLabel.text = [self.stationsForCurrentSelection objectAtIndex:indexPath.row];
   
    return cell;
}


#pragma mark Actions

-(void) savePunchOnLog {
    
}

- (IBAction)tramButtonTapped:(id)sender {
    self.selectedTransportType = SELECTED_TRANSPORT_TRAM;
    self.stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
    [self.stationsTable reloadData];
}
- (IBAction)trainButtonTapped:(id)sender {
    self.selectedTransportType = SELECTED_TRANSPORT_TRAIN;
    self.stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
    [self.stationsTable reloadData];
}
- (IBAction)busButtonTapped:(id)sender {
    self.selectedTransportType = SELECTED_TRANSPORT_BUS;
    self.stationsForCurrentSelection = [stationLocations getStationsForSelectedTransport:selectedTransportType];
    [self.stationsTable reloadData];
}

@end
