//
//  InspectorMapViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "InspectorMapViewController.h"
#import "InspectorMapKitAnnotation.h"
#import "Parse/Parse.h"
#import "ShmykiContstants.h"

@implementation InspectorMapViewController

@synthesize inspectorMapView, locationManager, listOfInspectorLocations;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Inspectors", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"images/TabInspectOff"];
        self.listOfInspectorLocations = [[NSMutableArray alloc] initWithCapacity:MAX_INSPECTORS_DISPLAYED];
        self.locationManager = nil;
        self.locationManager = [[CLLocationManager alloc] init]; 
        self.locationManager.delegate = self; 
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    CLLocationCoordinate2D coord = {.latitude =  -37.813174, .longitude =  144.962219};
    MKCoordinateSpan span = {.latitudeDelta =  0.015, .longitudeDelta =  0.015};
    MKCoordinateRegion region = {coord, span};
    
    [inspectorMapView setRegion:region];
    [self.locationManager startUpdatingLocation];

    [inspectorMapView setShowsUserLocation:YES];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setInspectorMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark locationManager Delegate


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{

    [manager stopUpdatingLocation];
    MKCoordinateSpan span; 
    span.latitudeDelta = 0.02; 
    span.longitudeDelta = 0.02;
    MKCoordinateRegion region; 
    region.span = span;
    region.center = newLocation.coordinate;
    [inspectorMapView setRegion:region animated:TRUE];
}

#pragma mark mapViewDelegate 

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
        
    if ([annotation isKindOfClass:[InspectorMapKitAnnotation class]]) {
        static NSString*  inspectorAnnotationIdentifier = @"InspectorAnnotationIdentifier"; 

        MKPinAnnotationView* annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:inspectorAnnotationIdentifier]; 
            
        if (!annotationView) {
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                                     reuseIdentifier:inspectorAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorPurple; 
            if([(InspectorMapKitAnnotation*)annotation justSpotted]){
                customPinView.animatesDrop= YES;
                [(InspectorMapKitAnnotation*)annotation setJustSpotted:NO];
            }

            customPinView.canShowCallout = YES;
        
            return customPinView;
        } else{
            annotationView.annotation = annotation;
            return annotationView; 
        }
    } else {
        return nil;
    }
}



#pragma mark IBActions

- (IBAction)locateMeButtonPressed:(id)sender {
    [self.locationManager startUpdatingLocation];
}

-(IBAction)spotAnInspector:(id)sender {
    [self.locationManager startUpdatingLocation];
    CLLocationCoordinate2D inspectorLocationCoordinate = [self.locationManager.location coordinate];

    InspectorMapKitAnnotation *annotation = [[InspectorMapKitAnnotation alloc] initWithCoords:inspectorLocationCoordinate];
    
    [annotation setSpotDate:[NSDate date]];
    [annotation setJustSpotted:YES];
    [inspectorMapView addAnnotation:annotation];
    
    [self saveInspectorWithLocationCoordinate:inspectorLocationCoordinate];
}

-(IBAction)findInspectorsButtonPressed:(id)sender {
    [self findInspectors];    
}

-(void) findInspectors {
    PFQuery *query = [PFQuery queryWithClassName:@"InspectorLocation"];
    [query addDescendingOrder:@"createdAt"];
    query.limit = (NSInteger)[NSNumber numberWithInt:MAX_INSPECTORS_DISPLAYED];
    [query findObjectsInBackgroundWithBlock:^(NSArray *inspectorLocations, NSError *error) {
        
        int i;
        for(i=0; i < [inspectorLocations count]; i++) {
            PFObject *inspectorLocationObject =[inspectorLocations objectAtIndex:i];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[inspectorLocationObject objectForKey:@"latitude"] doubleValue];
            coordinate.longitude = [[inspectorLocationObject objectForKey:@"longitude"] doubleValue];
            
            InspectorMapKitAnnotation *inspectorAnnotation = [[InspectorMapKitAnnotation alloc] initWithCoords:coordinate];
            [inspectorAnnotation setSpotDate: inspectorLocationObject.createdAt];
            [listOfInspectorLocations addObject:inspectorAnnotation];
        }
        
        [self removeInspectorAnnotations];
        [self.inspectorMapView addAnnotations:listOfInspectorLocations];
    }];
}

-(void) removeInspectorAnnotations {
    NSMutableArray *annotationsToRemove = [NSMutableArray arrayWithCapacity:MAX_INSPECTORS_DISPLAYED];
    for (id annotation in inspectorMapView.annotations) {
        if(annotation != inspectorMapView.userLocation){
            [annotationsToRemove addObject:annotation];
        }
    }
    [inspectorMapView removeAnnotations:annotationsToRemove];
}

#pragma mark Parse saving
- (void) saveInspectorWithLocationCoordinate:(CLLocationCoordinate2D)inspectorLocationCoordinate  {
    PFObject *inspectorLocation = [PFObject objectWithClassName:@"InspectorLocation"];
    [inspectorLocation setObject:[NSNumber numberWithDouble:inspectorLocationCoordinate.latitude]  forKey:@"latitude"];
    [inspectorLocation setObject:[NSNumber numberWithDouble:inspectorLocationCoordinate.longitude] forKey:@"longitude"];
    [inspectorLocation saveInBackground];
}

@end
