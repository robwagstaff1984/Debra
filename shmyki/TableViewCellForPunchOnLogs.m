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
@synthesize messageLabel, locationLabel, dateLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        messageLabel = [[UILabel alloc]init];
        messageLabel.textAlignment = UITextAlignmentLeft;
        messageLabel.font = [UIFont systemFontOfSize:MESSAGE_FONT_SIZE];
        [messageLabel setLineBreakMode:UILineBreakModeWordWrap];
        [messageLabel setNumberOfLines:0];
        //[messageLabel setBackgroundColor:[UIColor redColor]];
        
        
        locationLabel = [[UILabel alloc]init];
        locationLabel.textAlignment = UITextAlignmentLeft;
        locationLabel.font = [UIFont systemFontOfSize:LOCATION_FONT_SIZE];
        [locationLabel setTextColor:[UIColor grayColor]];
       // [locationLabel setBackgroundColor:[UIColor greenColor]];
        
        dateLabel = [[UILabel alloc]init];
        dateLabel.textAlignment = UITextAlignmentLeft;
        dateLabel.font = [UIFont systemFontOfSize:LOCATION_FONT_SIZE];
        [dateLabel setTextColor:[UIColor grayColor]];
        //[dateLabel setBackgroundColor:[UIColor orangeColor]];

        [self.contentView addSubview:messageLabel];
        [self.contentView addSubview:locationLabel];
        [self.contentView addSubview:dateLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
    CGSize constraint = CGSizeMake(320.0 - (CELL_CONTENT_HORIZONTAL_MARGIN * 2), 40000.0f);
    
    CGSize messageLabelSize = [messageLabel.text sizeWithFont:[UIFont systemFontOfSize:MESSAGE_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGSize locationLabelSize = [locationLabel.text sizeWithFont:[UIFont systemFontOfSize:LOCATION_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGSize dateLabelSize = [dateLabel.text sizeWithFont:[UIFont systemFontOfSize:LOCATION_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    frame= CGRectMake(boundsX+CELL_CONTENT_HORIZONTAL_MARGIN,CELL_CONTENT_VERTICAL_MARGIN ,320.0 - (CELL_CONTENT_HORIZONTAL_MARGIN * 2), messageLabelSize.height);
    messageLabel.frame = frame;
    
    frame= CGRectMake(boundsX+CELL_CONTENT_HORIZONTAL_MARGIN, messageLabelSize.height + (CELL_CONTENT_VERTICAL_MARGIN * 2), locationLabelSize.width, locationLabelSize.height);
    locationLabel.frame = frame;
    
    frame= CGRectMake(boundsX+320 - dateLabelSize.width - CELL_CONTENT_HORIZONTAL_MARGIN ,messageLabelSize.height + (CELL_CONTENT_VERTICAL_MARGIN * 2), dateLabelSize.width, dateLabelSize.height);
    dateLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
