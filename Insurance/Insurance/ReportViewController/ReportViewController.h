//
//  ReportViewController.h
//  Insurance
//
//  Created by MonuRathor on 20/03/15.
//  Copyright (c) 2015 Monoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblQuotesFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblValueFirst;
@property (weak, nonatomic) IBOutlet UILabel *lblQuotesSecond;
@property (weak, nonatomic) IBOutlet UILabel *lblValuesecond;
@property (weak, nonatomic) IBOutlet UITableView *tblReports;

@property (nonatomic, retain) NSDictionary *root;
@property (nonatomic, retain) NSString *selectedDate;
@property (nonatomic, retain) NSString *strDisplayDate;

- (IBAction)clickedLogout:(id)sender;
- (IBAction)clickedDashboard:(id)sender;
- (IBAction)clickedCalander:(id)sender;

@end
