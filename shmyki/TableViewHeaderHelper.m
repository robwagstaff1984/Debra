//
//  TableViewHeaderHelper.m
//  shmyki
//
//  Created by Robert Wagstaff on 20/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "TableViewHeaderHelper.h"
#import "ShmykiContstants.h"

@implementation TableViewHeaderHelper

+(UIView*) makeTableUpHeaderWith:(int)numberOfPunchOns {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,25)];
                               
    UILabel *closeButton = [[UILabel alloc] initWithFrame:CGRectMake(263,4, 90, 25)];
    closeButton.text = @"close";
    closeButton.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    [closeButton setTextColor:[UIColor grayColor]];
    closeButton.tag = TAG_FOR_CLOSE_BUTTON_LABEL;
    closeButton.userInteractionEnabled = YES;
    
    UIImageView *closeButtonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images/IconArrowDown"]];
    
    closeButtonImage.frame = CGRectMake(300, 12, 12, 12);

 //   headerLabel.backgroundColor = [UIColor redColor];
  //  headerView.backgroundColor = [UIColor greenColor];
    //closeButton.backgroundColor = [UIColor yellowColor];
    //closeButtonImage.backgroundColor = [UIColor purpleColor];

    [headerView addSubview:closeButton];
    [headerView addSubview:closeButtonImage];

    return headerView;
}

+(UIView*) makeTableDownHeaderWith:(int)numberOfPunchOns {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,25)];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:kCFNumberFormatterDecimalStyle]; // this line is important!
    NSString *numberOfPunchOnsFormatted = [formatter stringFromNumber:[NSNumber numberWithInteger:numberOfPunchOns]];
    
    
    UILabel *closeButton = [[UILabel alloc] initWithFrame:CGRectMake(240,5, 90, 25)];
    closeButton.text = [NSString stringWithFormat:@"%@         ",numberOfPunchOnsFormatted];
    closeButton.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    closeButton.tag = TAG_FOR_CLOSE_BUTTON_LABEL;
    closeButton.userInteractionEnabled = YES;
    closeButton.textAlignment = UITextAlignmentRight; 
    [closeButton setTextColor:[UIColor grayColor]];
    //closeButton.backgroundColor = [UIColor yellowColor];
    
    UIImageView *closeButtonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images/IconArrowUp"]];
    
    closeButtonImage.frame = CGRectMake(300, 12, 12, 12);
    
  //  headerView.backgroundColor = [UIColor greenColor];
    //closeButton.backgroundColor = [UIColor yellowColor];
    //closeButtonImage.backgroundColor = [UIColor purpleColor];
    
    [headerView addSubview:closeButton];
    [headerView addSubview:closeButtonImage];
    return headerView;
}


@end
