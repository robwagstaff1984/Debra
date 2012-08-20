//
//  InspectorMapViewController.h
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HelpImages.h"

@interface InspectorMapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *inspectorMapView;
@property (strong) CLLocationManager *locationManager;
@property(strong) NSMutableArray *listOfInspectorLocations;
@property (nonatomic, strong) HelpImages *helpImages;
@property (nonatomic, strong) IBOutlet UIButton *inspectorHelpImageButton;
@property (nonatomic, strong) IBOutlet UIImageView *inspectorCoachMarks;
@property (nonatomic) BOOL showingCoachMarks;


- (void) saveInspectorWithLocationCoordinate:(CLLocationCoordinate2D)inspectorLocationCoordinate; 
-(IBAction)inspectorHelpTapped:(id)sender;
@end
