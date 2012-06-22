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

+(UIView*) makeFullScreenHeaderWith:(int)numberOfPunchOns {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,80)];
                               
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:kCFNumberFormatterDecimalStyle]; // this line is important!
    NSString *header = [formatter stringFromNumber:[NSNumber numberWithInteger:numberOfPunchOns]];
                           
    CGSize constraint = CGSizeMake(320.0 - (CELL_CONTENT_HORIZONTAL_MARGIN * 2), 40000.0f);
    CGSize headerLabelSize = [header sizeWithFont:[UIFont systemFontOfSize:TABLE_HEADER_PUNCH_ONS_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                               
    //UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake((320-headerLabelSize.width)/2, (80-headerLabelSize.height)/2, headerLabelSize.width, headerLabelSize.height)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake((320-headerLabelSize.width)/2, 10, headerLabelSize.width, headerLabelSize.height)];

    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.text = header;
    headerLabel.font = [UIFont systemFontOfSize:TABLE_HEADER_PUNCH_ONS_FONT_SIZE];
    [headerLabel setTextColor:[UIColor blueColor]];

    
    UILabel *closeButton = [[UILabel alloc] initWithFrame:CGRectMake(240,5, 60, 25)];
    closeButton.text = @"Close";
    
    UIImageView *closeButtonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images/IconArrowDown"]];
    
    closeButtonImage.frame = CGRectMake(300, 12, 12, 12);
//    headerLabel.backgroundColor = [UIColor redColor];
//    headerView.backgroundColor = [UIColor greenColor];
//    closeButton.backgroundColor = [UIColor yellowColor];
    
    [headerView addSubview:headerLabel];
    [headerView addSubview:closeButton];
    [headerView addSubview:closeButtonImage];
    return headerView;
}

@end
