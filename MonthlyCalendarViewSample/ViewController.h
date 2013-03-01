//
//  ViewController.h
//  MonthlyCalenderViewSample
//
#import <UIKit/UIKit.h>
#import "MonthlyCalendarView.h"

@interface ViewController : UIViewController <MonthlyCalendarViewDelegate, UITextFieldDelegate> {
    IBOutlet    MonthlyCalendarView     *calenderView;
    IBOutlet    UITextField             *inputField;
    
    CGRect      keyboardRect;
}

@end
