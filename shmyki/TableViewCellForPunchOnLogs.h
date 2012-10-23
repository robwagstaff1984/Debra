//
//  TableViewCellForPunchOnLogs.h
//  shmyki
//
//  Created by Robert Wagstaff on 20/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellForPunchOnLogs : UITableViewCell


@property(nonatomic,retain)UILabel *messageLabel;
@property(nonatomic,retain)UILabel *locationLabel;
@property(nonatomic,retain)UILabel *dateLabel;
@property(nonatomic,retain)UIImageView *locationIconLabel;

@property float messageLabelHeight;

@end
