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

@synthesize selectedTransportType, stationLocations, stationsTable;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedTransportType = SELECTED_TRANSPORT_TRAM;
        stationLocations = [[StationLocations alloc] init];
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
  return [stationLocations getNumberOfStationsForSelectedTransport:selectedTransportType];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIdentifier = @"stationLocationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:cellIdentifier];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [[stationLocations getStationsForSelectedTransport:selectedTransportType] objectAtIndex:indexPath.row];
        
    }
    return cell;
    
    
}


#pragma mark Actions

-(void) savePunchOnLog {
    
}

@end
