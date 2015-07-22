//
//  DashboardViewController.h
//  Insurance
//
//  Created by MonuRathor on 18/03/15.
//  Copyright (c) 2015 Monoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"

@interface DashboardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnDashboard;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet UITableView *tblRecords;
@property (weak, nonatomic) IBOutlet UILabel *lbldate;
@property (weak, nonatomic) IBOutlet DSLCalendarView *calendarView;



- (IBAction)clickedDashboard:(id)sender;
- (IBAction)clickedReport:(id)sender;
- (IBAction)clickedLogout:(id)sender;
- (IBAction)clickedViewYesterday:(id)sender;
- (IBAction)clickedCalander:(id)sender;

@end
