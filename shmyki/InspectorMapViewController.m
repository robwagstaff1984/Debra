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

@synthesize inspectorMapView, locationManager, listOfInspectorLocations, helpImages, inspectorHelpImageButton,
inspectorCoachMarks, showingCoachMarks, needToDropInspectorPin, zIndexOfFrontPoi;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Nearby", nil);
        if ([self.tabBarItem respondsToSelector:@selector(setFinishedSelectedImage:withFinishedUnselectedImage:)] ==YES) {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"images/TabInspectOn"] withFinishedUnselectedImage:[UIImage imageNamed:@"images/TabInspectOff"]];
        } else {
            self.tabBarItem.image = [UIImage imageNamed:@"images/TabInspectOff"];
        }
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
    
    self.helpImages = [[HelpImages alloc] init];
    [self.helpImages loadHelpImageRequiredInfo];
    [inspectorMapView setRegion:region];
    if (!self.helpImages.isInspectorHelpAlreadySeen) {
        [self showInspectorHelp];
    } else {
        [self.locationManager startUpdatingLocation];
        [inspectorMapView setShowsUserLocation:YES];
    }
    [self findInspectors];
    
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
    span.latitudeDelta = 0.0214265;
    span.longitudeDelta = 0.0214265;
    MKCoordinateRegion region; 
    region.span = span;
    region.center = newLocation.coordinate;

    if( [self firstDouble:oldLocation.coordinate.latitude isEqualTo:newLocation.coordinate.latitude] &&
       [self firstDouble:oldLocation.coordinate.longitude isEqualTo:newLocation.coordinate.longitude] &&
       [self firstDouble:region.center.latitude isEqualTo:inspectorMapView.region.center.latitude] &&
       [self firstDouble:region.center.longitude isEqualTo:inspectorMapView.region.center.longitude]){
        
        //   (region.center.longitude != inspectorMapView.region.center.longitude))
        [self dropInspectorPinIfRequired];
    } else {
        [inspectorMapView setRegion:region animated:TRUE];
    }
    

}

#pragma mark mapViewDelegate 

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
        
    if ([annotation isKindOfClass:[InspectorMapKitAnnotation class]]) {
        static NSString*  inspectorAnnotationIdentifier = @"InspectorAnnotationIdentifier"; 

       // MKAnnotationView* annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:inspectorAnnotationIdentifier]; 
        
        MKAnnotationView* customPinView;
       // if (!annotationView) {
            customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                                     reuseIdentifier:inspectorAnnotationIdentifier];
            
       // } //else{
        
        customPinView.image = [(InspectorMapKitAnnotation*)annotation getPoiImageForTime];
        customPinView.centerOffset = CGPointMake(0, POI_OFFSET_Y);
        customPinView.canShowCallout = YES;
        customPinView.annotation = annotation;
        
        return customPinView;
        
        //    annotationView.annotation = annotation;
          //  return annotationView; 
       // }
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation 
{

}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {   

    
   
    NSArray *sortedAnnotationViews = [views sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSDate *firstDate = [(InspectorMapKitAnnotation*) [((MKAnnotationView*) obj1) annotation] spotDate];
        NSDate *secondDate = [(InspectorMapKitAnnotation*) [((MKAnnotationView*) obj2) annotation] spotDate];
        
        NSComparisonResult result = [firstDate compare:secondDate];
        
        return result;
    }];
    
    float zIndexCounter = .001;
    for (MKAnnotationView *pin in sortedAnnotationViews) {
        
        if ([[pin annotation] isKindOfClass:[MKUserLocation class]]) {

            pin.layer.zPosition = 1.001;
            
        } else if ([[pin annotation] isKindOfClass:[InspectorMapKitAnnotation class]]){

            if([(InspectorMapKitAnnotation*)[pin annotation] justSpotted]){
                
                pin.layer.zPosition = self.zIndexOfFrontPoi + .001;
                
               // zIndexCounter = zIndexCounter + .001;
                self.zIndexOfFrontPoi = self.zIndexOfFrontPoi + .001;
                // NSLog(@"just spotted z index: %f", pin.layer.zPosition);
                [(InspectorMapKitAnnotation*)[pin annotation] setJustSpotted:NO];
                CGRect endFrame = pin.frame;
                pin.frame = CGRectOffset(pin.frame, 0, -230);
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:.45f];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                pin.frame = endFrame;
                [UIView commitAnimations];
            } else {
                pin.layer.zPosition = zIndexCounter;
                zIndexCounter = zIndexCounter + .001;
            }
            //NSLog(@"zindex: %f", pin.layer.zPosition);
        }
    }
    self.zIndexOfFrontPoi = MAX(zIndexCounter, zIndexOfFrontPoi);    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    view.layer.zPosition = view.layer.zPosition + 1;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    view.layer.zPosition = view.layer.zPosition - 1;
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self dropInspectorPinIfRequired];
}

-(void) dropInspectorPinIfRequired {
    if(self.needToDropInspectorPin) {
        CLLocationCoordinate2D inspectorLocationCoordinate = [self.locationManager.location coordinate];
        InspectorMapKitAnnotation *annotation = [[InspectorMapKitAnnotation alloc] initWithCoords:inspectorLocationCoordinate];
        
        [annotation setSpotDate:[NSDate date]];
        [annotation setJustSpotted:YES];
        [inspectorMapView addAnnotation:annotation];
        
        [self saveInspectorWithLocationCoordinate:inspectorLocationCoordinate];
    }
    self.needToDropInspectorPin = NO;
}


#pragma mark IBActions

- (IBAction)locateMeButtonPressed:(id)sender {
    [self.locationManager startUpdatingLocation];
}

-(IBAction)spotAnInspector:(id)sender {
    self.needToDropInspectorPin = YES;
    [self.locationManager startUpdatingLocation];

}

-(IBAction)findInspectorsButtonPressed:(id)sender {
    [self findInspectors];    
}

-(IBAction)inspectorHelpTapped:(id)sender {
    [self hideInspectorHelp];
    [self.locationManager startUpdatingLocation];
    [inspectorMapView setShowsUserLocation:YES];
    self.helpImages.isInspectorHelpAlreadySeen = YES;
    [self.helpImages saveHelpImageRequiredInfo];
}

-(void) hideInspectorHelp {
    
    [UIView animateWithDuration:.3 animations:^(void){
        [self.inspectorHelpImageButton setAlpha:0.0];
    }
                     completion:^(BOOL finished){[self.inspectorHelpImageButton setHidden:TRUE];}
     ];
    [self showInspectorCoachMarks];
    [self hideInspectorCoachMarksWithDelay:3.0 WithDuration:2.0];
}

-(void) showInspectorHelp {
    [self.inspectorHelpImageButton setAlpha:0.0];
    [self.inspectorHelpImageButton setHidden:FALSE];
    [UIView animateWithDuration:.5 animations:^(void){
        [self.inspectorHelpImageButton setAlpha:1.0];
    }
     ];
}


-(void) hideInspectorCoachMarksWithDelay:(float) delay WithDuration:(float) duration{
    
    [self.inspectorHelpImageButton setHidden:FALSE];
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        [self.inspectorCoachMarks setAlpha:0.0];
    } completion:^(BOOL finished){
        self.showingCoachMarks = NO;
    }];
}

-(void) showInspectorCoachMarks {
    
    [self.inspectorCoachMarks setHidden:FALSE];
    [self.inspectorCoachMarks setAlpha:1.0];
    self.showingCoachMarks = YES;
}


-(void) findInspectors {
    PFQuery *query = [PFQuery queryWithClassName:@"InspectorLocation"];
    [query addDescendingOrder:@"createdAt"];
    query.limit = MAX_INSPECTORS_DISPLAYED;
    [query findObjectsInBackgroundWithBlock:^(NSArray *inspectorLocations, NSError *error) {
        for(int i=0; i <[inspectorLocations count]; i++) {
            PFObject *inspectorLocationObject =[inspectorLocations objectAtIndex:i];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[inspectorLocationObject objectForKey:@"latitude"] doubleValue];
            coordinate.longitude = [[inspectorLocationObject objectForKey:@"longitude"] doubleValue];
            
            InspectorMapKitAnnotation *inspectorAnnotation = [[InspectorMapKitAnnotation alloc] initWithCoords:coordinate];
            [inspectorAnnotation setSpotDate: inspectorLocationObject.createdAt];
            [listOfInspectorLocations addObject:inspectorAnnotation];
        }
        
        [self removeInspectorAnnotations];
//        [self.inspectorMapView addAnnotations:[[listOfInspectorLocations reverseObjectEnumerator] allObjects]];
                [self.inspectorMapView addAnnotations:[[listOfInspectorLocations objectEnumerator] allObjects]];
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

#pragma compareDoubles

#define kVerySmallValue (0.000001)

- (BOOL)firstDouble:(double)first isEqualTo:(double)second {
    
    if(fabsf(first - second) < kVerySmallValue)
        return YES;
    else
        return NO;
}

@end
