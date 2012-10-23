//
//  TableViewCellForPunchOnLogs.m
//  shmyki
//
//  Created by Robert Wagstaff on 20/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "TableViewCellForPunchOnLogs.h"
#import "ShmykiContstants.h"

@implementation TableViewCellForPunchOnLogs
@synthesize messageLabel, locationLabel, locationIconLabel, dateLabel;
@synthesize messageLabelHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        messageLabel = [[UILabel alloc]init];
        messageLabel.textAlignment = UITextAlignmentLeft;
        messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:MESSAGE_FONT_SIZE];
        [messageLabel setLineBreakMode:UILineBreakModeWordWrap];
        [messageLabel setNumberOfLines:0];
        //[messageLabel setBackgroundColor:[UIColor redColor]];
        
        locationLabel = [[UILabel alloc]init];
        locationLabel.textAlignment = UITextAlignmentLeft;
        locationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:LOCATION_FONT_SIZE];
        [locationLabel setTextColor:[UIColor grayColor]];
       // [locationLabel setBackgroundColor:[UIColor purpleColor]];
        
        locationIconLabel = [[UIImageView alloc] init];
        //[locationIconLabel setBackgroundColor:[UIColor greenColor]];
        
        dateLabel = [[UILabel alloc]init];
        dateLabel.textAlignment = UITextAlignmentRight;
        dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:DATE_FONT_SIZE];
        [dateLabel setTextColor:[UIColor grayColor]];
        //[dateLabel setBackgroundColor:[UIColor orangeColor]];

        [self.contentView addSubview:messageLabel];
        [self.contentView addSubview:locationLabel]; 
        [self.contentView addSubview:locationIconLabel];
        [self.contentView addSubview:dateLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    messageLabel.frame = CGRectMake(CELL_CONTENT_HORIZONTAL_MARGIN,CELL_CONTENT_VERTICAL_MARGIN ,320.0 - (CELL_CONTENT_HORIZONTAL_MARGIN * 2), self.messageLabelHeight);
    
    locationIconLabel.frame = CGRectMake(CELL_CONTENT_HORIZONTAL_MARGIN - 4,self.messageLabelHeight + (CELL_CONTENT_VERTICAL_MARGIN * 2) - 2, 20.0f, 20.0f);

    locationLabel.frame = CGRectMake(CELL_CONTENT_HORIZONTAL_MARGIN + LOCATION_ICON_SIZE -1, self.messageLabelHeight + (CELL_CONTENT_VERTICAL_MARGIN * 2), LOCATION_LABEL_MAX_WIDTH, LOCATION_LABEL_HEIGHT);
    
    dateLabel.frame = CGRectMake(210 ,self.messageLabelHeight + (CELL_CONTENT_VERTICAL_MARGIN * 2), DATE_LABEL_MAX_WIDTH, DATE_LABEL_HEIGHT);;
}

@end
