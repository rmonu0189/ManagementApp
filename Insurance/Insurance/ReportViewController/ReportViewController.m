//
//  ReportViewController.m
//  Insurance
//
//  Created by MonuRathor on 20/03/15.
//  Copyright (c) 2015 Monoo. All rights reserved.
//

#import "ReportViewController.h"
#import "RequestConnection.h"
#import "ReportCell.h"

@interface ReportViewController ()<RequestConnectionDelegate>
@property (nonatomic, retain) RequestConnection *connection;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@property (nonatomic, retain) NSArray *arrRecords;
@end

@implementation ReportViewController
@synthesize root;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setdata];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.connection = [[RequestConnection alloc] init];
    self.connection.delegate = self;
    [[AppDelegate sharedAppDelegate] startLoadingView];
    [self.connection getRecordByDate:self.selectedDate Category:[self.root valueForKey:@"product"] andPage:1];
}

- (void)setdata{
    self.lblDate.text = self.strDisplayDate;
    self.lblType.text = [self.root valueForKey:@"product"];
    self.lblQuotesFirst.text = [[self.root valueForKey:@"quotes"] stringByAppendingString:@" quotes"];
    self.lblValueFirst.text = [NSString stringWithFormat:@"£%0.2f value",[[self.root valueForKey:@"value"] floatValue]];
    self.lblQuotesSecond.text = [[self.root valueForKey:@"quotes_purchased"] stringByAppendingString:@" policies"];
    self.lblValuesecond.text = [NSString stringWithFormat:@"£%0.2f value",[[self.root valueForKey:@"value_purchased"] floatValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickedLogout:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"KeepMeLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)clickedDashboard:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedCalander:(id)sender {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReportCell *cell = (ReportCell*)[tableView dequeueReusableCellWithIdentifier:@"report_cell" forIndexPath:indexPath];
    NSDictionary *dict = [self.arrRecords objectAtIndex:indexPath.row];
    if ([[dict valueForKeyPath:@"purchased"] isEqualToString:@"YES"]) {
        cell.imgView.image = [UIImage imageNamed:@"imgPurchaed.png"];
    }
    else{
        cell.imgView.image = [UIImage imageNamed:@"imgNotPurchased.png"];
    }
    cell.lblTitle.text = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"title"],[dict valueForKey:@"surname"]];
    cell.lblAmount.text = [@"£" stringByAppendingString:[dict valueForKey:@"value"]];
    return cell;
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (!error) {
        if ([[response valueForKeyPath:@"status"] boolValue] == YES) {
            self.arrRecords = (NSArray *)[response valueForKey:@"record"];
            [self.tblReports reloadData];
        }
        else{
            [[AppDelegate sharedAppDelegate] showAlertWithTitle:@"Error!!!" Message:[response valueForKey:@"message"]];
        }
    }
    else{
        if (error.code != 1001) {
            [[AppDelegate sharedAppDelegate] showAlertWithTitle:@"Error!!!" Message:error.localizedDescription];
        }
    }
}

@end
