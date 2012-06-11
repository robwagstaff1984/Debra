//
//  InspectorMapViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "InspectorMapViewController.h"
#import "InspectorMapKitAnnotation.h"

@implementation InspectorMapViewController

@synthesize inspectorMapView, locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Inspectors", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
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
    static NSString*  inspectorAnnotationIdentifier = @"InspectorAnnotationIdentifier"; 
    MKPinAnnotationView* annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:inspectorAnnotationIdentifier]; 
            
    if (!annotationView) {
        MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                                     reuseIdentifier:inspectorAnnotationIdentifier];
        customPinView.pinColor = MKPinAnnotationColorPurple; customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        //UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //customPinView.rightCalloutAccessoryView = rightButton;
        return customPinView;
    } else{
        annotationView.annotation = annotation;
        return annotationView; 
    }
}

#pragma mark IBActions

- (IBAction)locateMeButtonPressed:(id)sender {
    self.locationManager = nil;
    self.locationManager = [[CLLocationManager alloc] init]; 
    self.locationManager.delegate = self; 
    [self.locationManager startUpdatingLocation];
}

-(IBAction)spotAnInspector:(id)sender {
    CLLocationCoordinate2D pinlocation = [self.locationManager.location coordinate];
    
    
    InspectorMapKitAnnotation *annotation = [[InspectorMapKitAnnotation alloc] initWithCoords:pinlocation];
    [inspectorMapView addAnnotation:annotation];
 //   annotation = [annotation initWithCoords: coordinate];
    //= [InspectorMapKitAnnotation initWithCo];
    
  //  [mapView addAnnotation:annotation]; 
}

@end
