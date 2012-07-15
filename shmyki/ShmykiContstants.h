//
//  ShmykiContstants.h
//  shmyki
//
//  Created by Robert Wagstaff on 12/06/12.
//  Copyright (c) 2012 DWS Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_NAME @"yourMyki"

#define TAG_FOR_CLOSE_BUTTON_LABEL 88 
#define TAG_FOR_CLOSE_BUTTON_IMAGE 89
#define TOTAL_PUNCH_ONS_SUBVIEW_NUMBER 0

#define SCREEN_HEIGHT_MINUS_BARS 367
#define COMMENTS_ORIGIN_TO_ANCHOR_TOP 213.0 
//#define COMMENTS_ORIGIN_TO_ANCHOR_TOP 184.0
#define COMMENTS_ORIGIN_TO_ANCHOR_BOTTOM 432.0
#define COMMENTS_EXTRA_BOTTOM_SCROLL 110
#define CELL_CONTENT_VERTICAL_MARGIN 10.0f
#define CELL_CONTENT_MIDDLE_MARGIN 3.0f
#define CELL_CONTENT_HORIZONTAL_MARGIN 20.0f
#define MESSAGE_FONT_SIZE 16.0f
#define LOCATION_FONT_SIZE 12.0f
#define TABLE_HEADER_PUNCH_ONS_FONT_SIZE 30.0f

#define SECONDS_IN_A_MINUTE 60
#define SECONDS_IN_TEN_MINUTE 60
#define SECONDS_IN_AN_HOUR 3600
#define SECONDS_IN_AN_DAY 86400
#define SECONDS_IN_AN_WEEK 86400

#define SECONDS_FOR_RED_POI 600
#define SECONDS_FOR_AMBER_POI 3600

#define MAX_INSPECTORS_DISPLAYED 30
#define MAX_PUNCH_ON_LOGS_RETRIEVED 30
#define PUNCH_ON_HINT_TEXT @"Have your voice heard! Tell us all what you think of Myki"
#define FEEDBACK_EMAIL_ADDRESS @"yourMyki@gmail.com"

#define MYKI_LOGIN_URL @"https://www.mymyki.com.au/NTSWebPortal/Login.aspx"
#define MYKI_ACCOUNT_INFO_URL @"https://www.mymyki.com.au/NTSWebPortal/Registered/ManageMyCard.aspx?menu=Manage%20my%20card";
#define JAVASCRIPT_ENTER_USERNAME @"var usernameField = document.getElementById(\"ctl00_uxContentPlaceHolder_uxUsername\"); usernameField.value ='%@';"
#define JAVASCRIPT_ENTER_PASSWORD @"var passwordField = document.getElementById(\"ctl00_uxContentPlaceHolder_uxPassword\"); passwordField.value ='%@';"
#define JAVASCRIPT_CLICK_SUBMIT @"var submitButton = document.getElementById(\"ctl00_uxContentPlaceHolder_uxLogin\"); submitButton.click();"

#define REG_EX_CARD_HOLDER @"<strong>Card holder</strong></td>\\s+<td>\\s+(.+)</td>"
#define REG_EX_CARD_TYPE @"<strong>Card type</strong>\\s+</td>\\s+<td>\\s+(.*?)\\s+</td>"
#define REG_EX_CARD_EXPIRY @"<strong>Card expiry</strong></td>\\s+<td>\\s+(.+)</td>"
#define REG_EX_CARD_STATUS @"<strong>Card status</strong></td>\\s+<td>\\s+(.+)</td>"
#define REG_EX_CURRENT_MYKI_MONEY_BALANCE @"<strong>Current myki money balance</strong></td>\\s+<td>\\s+(.+)</td>"
#define REG_EX_MYKI_MONEY_TOP_UP_IN_PROGRESS @"<strong>myki money top up in progress</strong></td>\\s+<td>\\s+(.+)</td>"
#define REG_EX_TOTAL_MYKI_MONEY_BALANCE @"<strong>Total myki money balance</strong></td>\\s+<td>\\s+(.+)</td>"
#define REG_EX_CURRENT_MYKI_PASS_ACTIVE @"<strong>Current myki pass \\(active\\)</strong></td>\\s+<td>\\s+(.+)<br />"
#define REG_EX_CURRENT_MYKI_PASS_NOT_YET_ACTIVE @"<strong>Current myki pass \\(not yet active\\)</strong></td>\\s+<td>\\s+(.+)<br />"
#define REG_EX_LAST_MYKI_TRANSACTION_DATE @"<strong>Last myki transaction date</strong></td>\\s+<td>\\s+(.+)</td>"
#define REG_EX_CURRENT_MYKI_PASS_ACTIVE_IN_DAYS @".*Valid to (.+)"
#define REG_EX_ERROR_LOGGING_IN @"<title>\\s*(Myki-Session Expired)\\s*</title>"

#define DEFAULT_HEADER_LABEL @"Sign in to see your account details"
#define DEFAULT_BOTTOM_LABEL_ONE @"You need to have a registered account with"
#define DEFAULT_BOTTOM_LABEL_TWO @"myki to show your balance"

#define USERNAME_TEXTFIELD_TAG 200
#define PASSWORD_TEXTFIELD_TAG 201

#define SELECTED_TRANSPORT_TRAM 0
#define SELECTED_TRANSPORT_TRAIN 1
#define SELECTED_TRANSPORT_BUS 2

#define kOAuthConsumerKey				@"XpVsm04szjaPMBRuelQsQ"
#define kOAuthConsumerSecret			@"BhYG56Bjlt7nlHL0JrVllZziH9dDCPB0GMUju7GIBM"

@interface ShmykiContstants


@end
