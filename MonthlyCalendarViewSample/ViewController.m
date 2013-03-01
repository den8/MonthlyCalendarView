//
//  ViewController.m
//  MonthlyCalenderViewSample
//
#import "ViewController.h"
#import "NSDate+TKCategory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    inputField.frame = CGRectMake(0.0f, self.view.frame.size.height, inputField.frame.size.width, inputField.frame.size.height);
    calenderView.delegate = self;
    
    // キーボード表示の通知を取得する定義
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    NSDate *date = [NSDate date];
    [calenderView refreshWithDate:date];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// MonthlyCalenderViewは今のところ横向きには対応していない
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
/*
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
*/
}

-(void)dateSelected:(NSDate *)date {
    LOG(@"===== date = [%@]", date);
    [self showInputField];
}

// キーボードの高さを取得する
- (void)keyboardWillShow:(NSNotification *)aNotification {
    keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //TODO: 入力値の保存
    
    [inputField resignFirstResponder];
    [self hideInputField];
    return YES;
}

-(void)showInputField {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
    [inputField becomeFirstResponder];
    CGFloat inputFieldOrigin = self.view.frame.size.height - keyboardRect.size.height - inputField.frame.size.height;
	inputField.frame = CGRectMake(0.0f, inputFieldOrigin, inputField.frame.size.width, inputField.frame.size.height);
	[UIView commitAnimations];    
}

-(void)hideInputField {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
    inputField.text = @"";
	inputField.frame = CGRectMake(0.0f, self.view.frame.size.height, inputField.frame.size.width, inputField.frame.size.height);
	[UIView commitAnimations];    
}

@end
