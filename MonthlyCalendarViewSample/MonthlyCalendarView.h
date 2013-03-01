//
//  MonthlyCalendarView.h
//  MonthlyCalendarViewSample
//
#import <UIKit/UIKit.h>

@protocol MonthlyCalendarViewDelegate <NSObject>
@required
-(void)dateSelected:(NSDate *)date;
@end


typedef enum {
    sunday = 1,
    monday = 2,
    tuesday = 3,
    wednesday = 4,
    thursday = 5,
    friday = 6,
    saturday = 7
} weekdays;

typedef enum {
	EFlickedNone = 0,		// フリックされていない
	EFlickedLeft,
	EFlickedRight,
	EFlickedUp,
	EFlickedDown
} EFlicked;

#define kFlickedDist 20.0
// 横フリックを有効にする横座標の移動値
// この数値以上X座標が移動していないと横フリックとはみなさない
#define kFLickedDiffX 100
// 横フリックを有効にする縦座標の範囲
// Y座業の移動値がこの数値以内でないと横フリックとはみなさない
#define kFilckedDiffXinDiffY	60

// カレンダーの余白
#define kCalOffsetX 5.0f
#define kCalOffsetY 5.0f
// 年月表示部分の高さ
#define kMonthLabelHeight   30.0f
// 曜日表示部分の高さ
#define kWeekLabelHeight    20.0f
// 線の太さ
#define kLineStroke 1.0f

@interface MonthlyCalendarView : UIView {
    id          delegate;
    NSDate      *displayMonth;    //現在表示しているカレンダーの月
    NSDate      *currentDate;     //カレンダーの上の本日日付
    NSInteger   selectedDay;      //現在選択されている日付
    
    //カレンダー本体の長さと高さ
    CGFloat     calWidth;
    CGFloat     calHeight;
    
    //フリック処理に必要な変数
	CGPoint beginTouchPoint;
	Float32 beginTouchContentY;
}

@property (nonatomic, retain)   id <MonthlyCalendarViewDelegate> delegate;
@property (nonatomic, retain)   NSDate  *displayMonth;
@property (nonatomic, retain)   NSDate  *currentDate;

- (void)refreshWithDate:(NSDate *)date;

@end
