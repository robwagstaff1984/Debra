//
//  EnterIssueViewController.m
//  shmyki
//
//  Created by Robert Wagstaff on 6/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "EnterIssueViewController.h"
#import "EnterLocationViewController.h"
#import "ShmykiContstants.h"
#import "AppDelegate.h"
#import "YourMykiCustomButton.h"
#import <QuartzCore/QuartzCore.h>
#import "GANTracker.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation EnterIssueViewController {
    BOOL isFirstTimePageLoad;
}

@synthesize commentsTextView, punchOnIssues, punchOnIsValid, twitterButton, facebookButton, punchOnTableView, shadowWrapper, locationIcon, locationLabel, selectedProblem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"Add comment"];
        punchOnIssues = [[PunchOnIssues alloc] init];
        punchOnIsValid = NO;
        isFirstTimePageLoad = YES;
        self.selectedProblem = 1;
       // [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:@"TwitterCancelled" options:nil context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelTwitter) 
                                                     name:@"TwitterCancelled"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelFacebook) 
                                                     name:@"FacebookCancelled"
                                                   object:nil];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)cancelTwitter {
    [self.twitterButton setImage:[UIImage imageNamed: @"images/IconTwitterOff"] forState:UIControlStateNormal];
}

-(void)cancelFacebook {
    [self.facebookButton setImage:[UIImage imageNamed: @"images/IconFacebookOff"] forState:UIControlStateNormal];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [commentsTextView setDelegate:self];
   // [commentsTextView becomeFirstResponder];
    [self addHintTextToCommentsTextView];
    [commentsTextView resignFirstResponder];
    [commentsTextView setUserInteractionEnabled:YES];
    
   // self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Save" withTarget:self withAction:@selector(issueEntered)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.shadowWrapper.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.shadowWrapper.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.shadowWrapper.layer.shadowOpacity = .90f;
    self.shadowWrapper.layer.shadowRadius = 3.0f;

    [super viewDidLoad];
    
}



- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

-(void)viewDidAppear: (BOOL)animated { 
    [super viewDidAppear:animated];
    
    NSString *currentUsersLocation = [[(AppDelegate*)[[UIApplication sharedApplication]delegate] currentUsersPunchOnLog ] location];
    
    if([currentUsersLocation length] > 0) {
        self.locationLabel.text = [(AppDelegate*)[[UIApplication sharedApplication]delegate] convertLocationToShortLocation:currentUsersLocation]; 
        
        switch ([[(AppDelegate*)[[UIApplication sharedApplication]delegate] currentUsersPunchOnLog]transportationType]) {
            case SELECTED_TRANSPORT_TRAM:
                [self.locationIcon setImage:[UIImage imageNamed:@"/images/IconTram"]];
                break;
            case SELECTED_TRANSPORT_TRAIN:
                [self.locationIcon setImage:[UIImage imageNamed:@"/images/IconTrain"]];
                break;
            case SELECTED_TRANSPORT_BUS:
                [self.locationIcon setImage:[UIImage imageNamed:@"/images/IconBus"]];
                break;
            default:
                [self.locationIcon setImage:[UIImage imageNamed:@"/images/IconComment"]];
        } 
    }
}  

-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(popNavigationController)];
    [super viewWillAppear:animated];
    [[GANTracker sharedTracker] trackPageview:@"yourVoice" withError:nil];
}

-(void)popNavigationController {
    //[self.navigationController popViewControllerAnimated:YES];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] clearCurrentUsersPunchOnLog];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.punchOnIssues.issues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  /*  NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%i",indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                     reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.punchOnIssues.issues objectAtIndex:indexPath.row];
    
    if(indexPath.row == 0) {
        [cell.textLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        [cell.textLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;*/
    
    

     

     

     
    if(indexPath.row == 0) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"TitleCell"];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
            [cell.textLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        cell.textLabel.text = [self.punchOnIssues.issues objectAtIndex:indexPath.row];
        

         return cell;
    } else {
        NSString *cellIdentifier = [NSString stringWithFormat:@"problemCell"];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            
            
            cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier];
            [cell.textLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.textColor = [UIColor blackColor];
        
        }
        cell.textLabel.text = [self.punchOnIssues.issues objectAtIndex:indexPath.row];
        if(indexPath.row == self.selectedProblem) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"images/IconTick"]];
        } else {
            cell.accessoryView = nil;
        }
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 1 && isFirstTimePageLoad) {
        isFirstTimePageLoad = NO;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"images/IconTick"]];
    }
    
}



#pragma mark table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 0) {
        self.selectedProblem = indexPath.row;
        
        for(int i=0; i< [self.punchOnIssues.issues count]; i++ ) {
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [tableView cellForRowAtIndexPath:currentIndexPath].accessoryView = nil;
        }
        
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"images/IconTick"]];

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if(indexPath.row != 1) {
            double delayInSeconds = .4;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                UIViewController *enterLocationViewController = [[EnterLocationViewController alloc] initWithNibName:@"EnterLocationViewController" bundle:nil];
                [self.navigationController pushViewController:enterLocationViewController animated:YES];
            });
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView cellForRowAtIndexPath:indexPath].accessoryView = nil;
    //[[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}


#pragma mark textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView.text isEqualToString:PUNCH_ON_HINT_TEXT]){ 
        [self removeHintTextToCommentsTextView];
        
        return YES;
    } else if ([textView.text length] == 1 && [text isEqualToString:@""]){
        [self addHintTextToCommentsTextView];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

   /* if (commentsTextView.hasText && ![commentsTextView.text isEqualToString:PUNCH_ON_HINT_TEXT]){
       punchOnIsValid = YES;
       self.navigationItem.rightBarButtonItem.enabled = YES;
   } else {
       punchOnIsValid = NO;
       self.navigationItem.rightBarButtonItem.enabled = NO;
   }*/
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.navigationItem.leftBarButtonItem = nil;

    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Done" withTarget:self withAction:@selector(doneAddingComments)];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    
    if ([textView.text isEqualToString:PUNCH_ON_HINT_TEXT]){ 
        [self removeHintTextToCommentsTextView];
    }
}

-(void) textViewDidEndEditing:(UITextView *)textView { 

}

-(void) doneAddingComments {

    BOOL enableRightBarButton;
    
    if ([commentsTextView.text isEqualToString:PUNCH_ON_HINT_TEXT]) { 
        enableRightBarButton = NO;
    } else if([commentsTextView.text length] > 0) {
        enableRightBarButton = YES;
    } else {
        enableRightBarButton = NO;
        [self addHintTextToCommentsTextView];
    }
    [commentsTextView resignFirstResponder];

    self.navigationItem.rightBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Save" withTarget:self withAction:@selector(issueEntered)];
    self.navigationItem.leftBarButtonItem = [YourMykiCustomButton createYourMykiBarButtonItemWithText:@"Cancel" withTarget:self withAction:@selector(popNavigationController)];
    self.navigationItem.rightBarButtonItem.enabled = enableRightBarButton;
}
                                                                   
#pragma mark actions

- (void) issueEntered {
    NSString *savedComment = @"";
    if(![commentsTextView.text isEqualToString:PUNCH_ON_HINT_TEXT]) {
        savedComment = commentsTextView.text;
    }
    
    [[(AppDelegate*)[[UIApplication sharedApplication]delegate] currentUsersPunchOnLog] setMessage:savedComment];
    ((AppDelegate*)[[UIApplication sharedApplication]delegate]).currentUsersProblem = [self.punchOnIssues.issues objectAtIndex:selectedProblem];
    
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] postToFacebook];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] postToTwitter];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] saveCurrentUsersPunchOnLog];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] clearCurrentUsersPunchOnLog];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)toggleTwitterButton:(id)sender {
    BOOL twitterIsSelected =  [(AppDelegate*)[[UIApplication sharedApplication]delegate] isTwitterRequired];
    if (twitterIsSelected) {
        [sender setImage:[UIImage imageNamed: @"images/IconTwitterOff"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed: @"images/IconTwitterOn"] forState:UIControlStateNormal];
        [self presentTwitterLoginIfRequired];
    }
    [(AppDelegate*)[[UIApplication sharedApplication]delegate] setIsTwitterRequired:!twitterIsSelected];
}

- (IBAction)toggleFacebookButton:(id)sender {
    BOOL facebookIsSelected =  [(AppDelegate*)[[UIApplication sharedApplication]delegate] isFaceBookRequired];
    if (facebookIsSelected) {
        [sender setImage:[UIImage imageNamed: @"images/IconFacebookOff"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed: @"images/IconFacebookOn"] forState:UIControlStateNormal];
        //[(AppDelegate*)[[UIApplication sharedApplication] delegate] logInToFacebook];
        
        NSArray *permissions =
        [NSArray arrayWithObjects:@"publish_actions", nil];
        
        /*[FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          
                                      }];*/
        
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:true completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            
            NSLog(@"facebook publishactions request, erro: %@ status, %d", error, status);
            // Now call FBRequestConnection to post in the stream
            
        }];
        
    }
    [(AppDelegate*)[[UIApplication sharedApplication]delegate] setIsFaceBookRequired:!facebookIsSelected];
}

#pragma  mark helper methods 

- (void) addHintTextToCommentsTextView {
    [commentsTextView resignFirstResponder];
    commentsTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [commentsTextView becomeFirstResponder];
    [commentsTextView setText: PUNCH_ON_HINT_TEXT];
    [commentsTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
	[commentsTextView setTextColor:[UIColor lightGrayColor]];
    commentsTextView.selectedRange = NSMakeRange(0, 0);
    
}

- (void) removeHintTextToCommentsTextView {
//    [commentsTextView setUserInteractionEnabled:YES];
    [commentsTextView resignFirstResponder];
    commentsTextView.autocorrectionType = UITextAutocorrectionTypeDefault;
    [commentsTextView becomeFirstResponder];
    [commentsTextView setText: @""];
    [commentsTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
	[commentsTextView setTextColor:[UIColor blackColor]];
}

-(void) presentTwitterLoginIfRequired {
    UIViewController* loginViewController = [(AppDelegate*)[[UIApplication sharedApplication]delegate] getlogInToTwitterViewController];  
    //[(SA_OAuthTwitterController*)loginViewController setDelegate:self];
    if (loginViewController != nil) {
        [self presentModalViewController: loginViewController animated: YES]; 
    }
}

@end
