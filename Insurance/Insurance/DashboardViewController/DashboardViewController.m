//
//  DashboardViewController.m
//  Insurance
//
//  Created by MonuRathor on 18/03/15.
//  Copyright (c) 2015 Monoo. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardTableViewCell.h"
#import "RequestConnection.h"
#import "ReportViewController.h"

@interface DashboardViewController ()<RequestConnectionDelegate, DSLCalendarViewDelegate>
@property (nonatomic, retain) NSArray *arrRecords;
@property (nonatomic, retain) RequestConnection *connection;
@property (nonatomic, retain) NSDateFormatter *dateFormatter, *displayDateFormatter;
@property (nonatomic, retain) NSString *strdate;
@end

@implementation DashboardViewController

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
    
    self.calendarView.delegate = self;
    self.calendarView.hidden = YES;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.displayDateFormatter = [[NSDateFormatter alloc] init];
    [self.displayDateFormatter setDateFormat:@"EEEE, d MMMM, yyyy"];
    
    self.lbldate.text = [self.displayDateFormatter stringFromDate:[NSDate date]];
    
    [self.btnDashboard setBackgroundColor:[UIColor colorWithRed:120.0/255.0 green:178.0/255.0 blue:227.0/255.0 alpha:1.0]];
    self.connection = [[RequestConnection alloc] init];
    self.connection.delegate = self;
    NSString *currentDate = [self.dateFormatter stringFromDate:[NSDate date]];
    self.strdate = currentDate;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[AppDelegate sharedAppDelegate] startLoadingView];
    [self.connection getRecordByDate:self.strdate];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedDashboard:(id)sender {
    [self.btnDashboard setBackgroundColor:[UIColor colorWithRed:120.0/255.0 green:178.0/255.0 blue:227.0/255.0 alpha:1.0]];
    [self.btnReport setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)clickedReport:(id)sender {
//    [self.btnDashboard setBackgroundColor:[UIColor clearColor]];
//    [self.btnReport setBackgroundColor:[UIColor colorWithRed:120.0/255.0 green:178.0/255.0 blue:227.0/255.0 alpha:1.0]];
}

- (IBAction)clickedLogout:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"KeepMeLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickedViewYesterday:(id)sender {
    [[AppDelegate sharedAppDelegate] startLoadingView];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    self.lbldate.text = [self.displayDateFormatter stringFromDate:yesterday];
    NSString *currentDate = [self.dateFormatter stringFromDate:yesterday];
    self.strdate = currentDate;
    [self.connection getRecordByDate:currentDate];
}

- (IBAction)clickedCalander:(id)sender {
    self.calendarView.hidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DashboardTableViewCell *cell = (DashboardTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"dashboard_cell" forIndexPath:indexPath];
    NSDictionary *dict = [self.arrRecords objectAtIndex:indexPath.row];
    
    cell.lblType.text = [dict valueForKey:@"product"];
    cell.lblQuetsFirst.text = [[dict valueForKey:@"quotes"] stringByAppendingString:@" quotes"];
    cell.lblValueFirst.text = [NSString stringWithFormat:@"£%0.2f value",[[dict valueForKey:@"value"] floatValue]];
    cell.lblQuotesSecond.text = [[dict valueForKey:@"quotes_purchased"] stringByAppendingString:@" policies"];
    cell.lblValueSecond.text = [NSString stringWithFormat:@"£%0.2f value",[[dict valueForKey:@"value_purchased"] floatValue]];
    cell.lblQoutesThird.text = [[dict valueForKey:@"quotes_month"] stringByAppendingString:@" quotes"];
    cell.lblValueThird.text = [NSString stringWithFormat:@"£%0.2f value",[[dict valueForKey:@"value_month"] floatValue]];
    cell.lblQoutesFourth.text = [[dict valueForKey:@"quotes_month_purchased"] stringByAppendingString:@" policies"];
    cell.lblValueFourth.text = [NSString stringWithFormat:@"£%0.2f value",[[dict valueForKey:@"value_month_purchased"] floatValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.arrRecords objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"report" sender:dict];
}

- (void)requestResultSuccess:(id)response andError:(NSError *)error{
    [[AppDelegate sharedAppDelegate] stopLoadingView];
    if (!error) {
        if ([[response valueForKeyPath:@"status"] boolValue] == YES) {
            self.arrRecords = (NSArray *)[response valueForKey:@"record"];
            [self.tblRecords reloadData];
        }
        else{
            [[AppDelegate sharedAppDelegate] showAlertWithTitle:@"Error!!!" Message:[response valueForKey:@"message"]];
        }
    }
    else{
        [[AppDelegate sharedAppDelegate] showAlertWithTitle:@"Error!!!" Message:error.localizedDescription];
    }
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     ReportViewController *rvc = (ReportViewController *)[segue destinationViewController];
     rvc.root = (NSDictionary *)sender;
     rvc.selectedDate = self.strdate;
     rvc.strDisplayDate = self.lbldate.text;
 }

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        NSString *day = @"";
        if (range.endDay.day > 0 && range.endDay.day <= 9) {
            day = [NSString stringWithFormat:@"0%ld",(long)range.endDay.day];
        }
        else{
            day = [NSString stringWithFormat:@"%ld",(long)range.endDay.day];
        }
        
        NSString *month = @"";
        if (range.endDay.month > 0 && range.endDay.month <= 9) {
            month = [NSString stringWithFormat:@"0%ld",(long)range.endDay.month];
        }
        else{
            month = [NSString stringWithFormat:@"%ld",(long)range.endDay.month];
        }
        self.strdate = [NSString stringWithFormat:@"%ld-%@-%@",(long)range.endDay.year,month,day];
        NSLog(@"Selected date ::::::: %@",self.strdate);
        
        self.lbldate.text = [self.displayDateFormatter stringFromDate:range.endDay.date];
        [[AppDelegate sharedAppDelegate] startLoadingView];
        [self.connection getRecordByDate:self.strdate];
    }
    self.calendarView.hidden = YES;
}

@end
