//
//  PunchOnLog.m
//  shmyki
//
//  Created by Robert Wagstaff on 20/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import "PunchOnLog.h"
#import "ShmykiContstants.h"

@implementation PunchOnLog

@synthesize message, location, transportationType, dateLogged, cellHeight;

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:message forKey:@"message"];
    [encoder encodeObject:location forKey:@"location"];
    [encoder encodeInteger:transportationType forKey:@"transportationType"];
    [encoder encodeObject:dateLogged forKey:@"dateLogged"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.message = [decoder decodeObjectForKey:@"message"];
    self.location = [decoder decodeObjectForKey:@"location"];
    self.transportationType = [decoder decodeIntegerForKey:@"transportationType"];
    self.dateLogged = [decoder decodeObjectForKey:@"dateLogged"];
    
    CGSize constraint = CGSizeMake(320.0 - (CELL_CONTENT_HORIZONTAL_MARGIN * 2), 500.0);
    CGSize messageLabelSize = [self.message sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:MESSAGE_FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    self.cellHeight =  messageLabelSize.height + DATE_LABEL_HEIGHT + (CELL_CONTENT_VERTICAL_MARGIN * 3);
    
    
    return self;
}

@end
