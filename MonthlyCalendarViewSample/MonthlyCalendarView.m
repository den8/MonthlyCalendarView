//
//  MonthlyCalendarView.m
//  MonthlyCalendarViewSample
//
#import "MonthlyCalendarView.h"
#import "NSDate+TKCategory.h"

@implementation MonthlyCalendarView
@synthesize delegate;
@synthesize displayMonth;
@synthesize currentDate;

- (void)setInitProperty {
    displayMonth = [[NSDate date] firstOfMonth];
    currentDate = [NSDate date];

    // カレンダーの大きさをviewの大きさから計算する
    CGFloat frameHeight = self.frame.size.height;
    CGFloat frameWidth = self.frame.size.width;
    calWidth = frameWidth - kCalOffsetX * 2; //カレンダー本体の長さ
    calHeight = frameHeight - kCalOffsetY * 2 - kMonthLabelHeight - kWeekLabelHeight;  //カレンダー本体の高さ
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInitProperty];
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self setInitProperty];
}

-(UIFont *)monthFont {
	UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:13.0f];
	return font;
}

-(UIFont *)weekdayFont {
	UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:11.0f];
	return font;
}

-(UIFont *)dateFont {
	UIFont *font = [UIFont fontWithName:@"HiraKakuProN-W6" size:11.0f];
	return font;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	self.userInteractionEnabled = YES;
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat offsetY = kCalOffsetY;       //現在の描画位置
	
	CGContextSetLineWidth(context, kLineStroke);
	CGContextSetRGBStrokeColor(context, 0.6, 0.6, 0.6, 1.0);
	CGContextSetRGBFillColor(context, 1.0, 0.9, 0.9, 1.0);

    
    //年月表示部分
    //年月表示
    CGRect monthFrame = CGRectMake(kCalOffsetX, offsetY, calWidth, kMonthLabelHeight);
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:monthFrame];
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.textAlignment = UITextAlignmentCenter;
    monthLabel.font = [self monthFont];
    monthLabel.text = [NSString stringWithFormat:@"%d年%d月", [displayMonth year], [displayMonth month]];
    [self addSubview:monthLabel];
    
    //矢印ボタン表示
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.frame = CGRectMake(kCalOffsetX, offsetY, calWidth / 7, kMonthLabelHeight);
    [prevButton setTitle:@"＜" forState:UIControlStateNormal];
    prevButton.titleLabel.font = [self monthFont];
    prevButton.titleLabel.textColor = [UIColor blackColor];
    [prevButton addTarget:self action:@selector(movePrevMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:prevButton];

    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(kCalOffsetX + calWidth / 7 * 6, offsetY, calWidth / 7, kMonthLabelHeight);
    [nextButton setTitle:@"＞" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [self monthFont];
    nextButton.titleLabel.textColor = [UIColor blackColor];
    [nextButton addTarget:self action:@selector(moveNextMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
    
    
    offsetY = offsetY + kMonthLabelHeight;
    
    //曜日表示部分
    //枠線の描画
	CGRect weekRect = CGRectMake(kCalOffsetX, offsetY, calWidth, kWeekLabelHeight);
	CGContextStrokeRect(context, weekRect);
    CGContextFillRect(context, weekRect);
    //縦線の描画
    for(int i = 1; i < 7; i++) {
        CGContextMoveToPoint(context, (calWidth / 7 + kLineStroke) * i , offsetY);
        CGContextAddLineToPoint(context, (calWidth / 7 + kLineStroke) * i, offsetY + kWeekLabelHeight);
        CGContextStrokePath(context);
    }
    //曜日のラベル描画
    NSArray *weekdayText = [[NSArray alloc] initWithObjects:@"日", @"月", @"火", @"水", @"木", @"金", @"土", nil];
    for(int i = 0; i < 7; i++) {
        CGRect labelFrame = CGRectMake((calWidth / 7 + kLineStroke) * i + kLineStroke, 
                                       offsetY + kLineStroke, 
                                       (calWidth / 7) - kLineStroke, 
                                       kWeekLabelHeight + kLineStroke);
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        if (i + 1 == saturday) weekLabel.textColor = [UIColor blueColor];
        if (i + 1 == sunday)   weekLabel.textColor = [UIColor redColor];
        
        weekLabel.backgroundColor = [UIColor clearColor];
        weekLabel.textAlignment = UITextAlignmentCenter;
        weekLabel.font = [self weekdayFont];
        weekLabel.text = [weekdayText objectAtIndex:i];
        [self addSubview:weekLabel];
    }
    
    
    offsetY = offsetY + kWeekLabelHeight;
    
    //カレンダー本体
    //枠線の描画
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGRect calRect = CGRectMake(kCalOffsetX, offsetY, calWidth, calHeight);
	CGContextStrokeRect(context, calRect);
    CGContextFillRect(context, calRect);
    
    //縦線の描画
    for(int i = 1; i < 7; i++) {
        CGContextMoveToPoint(context, (calWidth / 7 + kLineStroke) * i , offsetY);
        CGContextAddLineToPoint(context, (calWidth / 7 + kLineStroke) * i, offsetY + calHeight);
        CGContextStrokePath(context);
    }
    
    //横線の描画
    for(int i = 1; i < 6; i++) {
        CGContextMoveToPoint(context, kCalOffsetX, offsetY + (calHeight / 6) * i );
        CGContextAddLineToPoint(context, kCalOffsetX + calWidth, offsetY + (calHeight / 6) * i );
        CGContextStrokePath(context);
    }

    
    // 日付の描画
    NSDate *firstDate = [displayMonth firstOfMonth];
    
	NSInteger daysInMonth = [MonthlyCalendarView daysInMonth:firstDate];
    NSInteger firstWeekday = [firstDate weekday];

    //カレンダのセルの配置
	for(NSInteger i=1; i <= daysInMonth; i++){
        //　本日日付のもののマス目に色をつける
        if([[currentDate firstOfMonth] isSameDay:displayMonth] && [currentDate day] == i) {
            CGRect r = [self rectCellForDay:i];
            CGContextSetRGBFillColor(context, 1.0, 1.0, 0.8, 1.0);
            CGContextFillRect(context, r);
            CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
        }
        if(i == selectedDay) {
            CGRect r = [self rectCellForDay:i];
            CGContextSetRGBFillColor(context, 0.8, 0.8, 1.0, 1.0);
            CGContextFillRect(context, r);
            CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
        }
    }
    
    // 日付ラベルの描画
	for(NSInteger i=1; i <= daysInMonth; i++){
        NSInteger dateIndex = (i-1) + (firstWeekday-1);
        NSInteger row = dateIndex / 7;
        NSInteger col = dateIndex % 7;
        CGRect r = CGRectMake( (calWidth / 7 + kLineStroke) * col + kCalOffsetX,
                               (calHeight / 6 + kLineStroke) * row + offsetY, 
                               (calWidth / 7) - 5.0f, 
                               20.0f);
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:r];
        dateLabel.font = [self dateFont];
        dateLabel.text = [NSString stringWithFormat:@"%d ", i];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = UITextAlignmentRight;

        // 1,2,3,4,5,6,7 が欲しいが実質 1,2,3,4,5,6,0 が返るので土曜日は0とする
        NSInteger weekday = ((i - 1) + firstWeekday) % 7;
        if (weekday == 0 /*saturday*/) dateLabel.textColor = [UIColor blueColor];
        if (weekday == sunday)   dateLabel.textColor = [UIColor redColor];
            
        [self addSubview:dateLabel];
	}
    
}

//日付のマスのRectを返す
-(CGRect)rectCellForDay:(NSInteger)day {
    CGFloat calOffsetY = kCalOffsetY + kMonthLabelHeight + kWeekLabelHeight;
    
    NSDate *currentMonth = displayMonth ? displayMonth : [[NSDate date] firstOfMonth];
    NSDate *firstDate = [currentMonth firstOfMonth];
    
    NSInteger firstWeekday = [firstDate weekday];
    
    NSInteger dateIndex = (day-1) + (firstWeekday-1);
    NSInteger row = dateIndex / 7;
    NSInteger col = dateIndex % 7;
    CGRect r = CGRectMake( (calWidth / 7 + kLineStroke) * col + kLineStroke,
                          (calHeight / 6) * row + kLineStroke + calOffsetY, 
                          (calWidth / 7 + 1) - kLineStroke * 2, 
                          (calHeight / 6) - kLineStroke * 2
                          );
    return r;
}

//引数で与えられた座標に相当するマスの日付を返す（日付以外の座標が与えられた場合、0を返す）
-(NSInteger)dayFromPoint:(CGPoint)point {
    NSDate *currentMonth = displayMonth ? displayMonth : [[NSDate date] firstOfMonth];
    NSDate *firstDate = [currentMonth firstOfMonth];
	NSInteger daysInMonth = [MonthlyCalendarView daysInMonth:firstDate];
    
	for(NSInteger i=1; i <= daysInMonth; i++){
        CGRect r = [self rectCellForDay:i];
        if([self isPointInRect:point rect:r]) {
            return i;
        }
    }
    
    return 0;
}

// 引数のポイントがRectの中に入っているかどうかを判別する
-(BOOL)isPointInRect:(CGPoint)point rect:(CGRect)rect {
    if(rect.origin.x <= point.x && point.x <= rect.origin.x + rect.size.width &&
       rect.origin.y <= point.y && point.y <= rect.origin.y + rect.size.height) {
        return true;
    }
    return false;
}

//再描画を行う
-(void)reDraw {
    //いったん描画をすべてクリアする
    for(UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    [self setNeedsDisplay]; 
}


// 日付をセットして再描画を行う
- (void)refreshWithDate:(NSDate *)date {
    currentDate = date;
    [self reDraw];
}

- (void)movePrevMonth:(id)sender {
    displayMonth = [displayMonth previousMonth];
    selectedDay = 0;
    [self reDraw];
}

- (void)moveNextMonth:(id)sender {
    displayMonth = [displayMonth nextMonth];
    selectedDay = 0;
    [self reDraw];
}


// その月の日数を返す
+ (NSInteger) daysInMonth:(NSDate*)date {
	TKDateInformation info = [date dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info.day = 1;
	info.hour = 0;
	info.minute = 0;
	info.second = 0;
	
	NSDate *currentMonth = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	info = [currentMonth dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
	NSDate *nextMonth = [currentMonth nextMonth];
	NSInteger daysInMonth = [currentMonth daysBetweenDate:nextMonth];
    return daysInMonth;
}


// フリック処理
// 左右のフリックで前月と次月に移動する
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch*	touch = [touches anyObject];
	beginTouchPoint = [touch previousLocationInView:self];
	beginTouchContentY = self.frame.origin.y;
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	beginTouchPoint = CGPointMake(0,0);	// clear
	beginTouchContentY = 0.0f;
	[super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch*	touch = [touches anyObject];
	EFlicked flicked = [self wasFlicked:touch];
	if(flicked != EFlickedNone) {
		if(flicked == EFlickedRight) {
			[self movePrevMonth:nil];
			return;
		}
		else if(flicked == EFlickedLeft) {
			[self moveNextMonth:nil];
			return;
		}
	} else {
        //日付のセルのタップを拾う
        CGPoint p = [touch locationInView:self];
        selectedDay = [self dayFromPoint:p];
        
        TKDateInformation info = [displayMonth dateInformationWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        info.day = selectedDay;
        NSDate *date = [NSDate dateFromDateInformation:info timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        if([delegate respondsToSelector:@selector(dateSelected:)]) {
            [delegate dateSelected:date];
        }
        
        [self reDraw];
    }
	[super touchesEnded:touches withEvent:event];
}

-(EFlicked)wasFlicked:(UITouch *)touch {
    CGPoint endPoint = [touch locationInView:self];
    CGPoint startPoint = beginTouchPoint; //[touch previousLocationInView:self];
    //	if(startPoint.x == 0.0f && startPoint.y == 0.0f) startPoint = beginTouchPoint;
	if(startPoint.x == 0.0f && startPoint.y == 0.0f) return EFlickedNone;
	beginTouchPoint = CGPointZero;	// clear
	
	double diffX = endPoint.x - startPoint.x;
    double diffY = endPoint.y - startPoint.y;
	double diffContentY = self.frame.origin.y - beginTouchContentY;
	beginTouchContentY = 0.0f;
    double dist = sqrt(diffX * diffX + diffY * diffY);
	if(dist < kFlickedDist ||
	   abs(diffX) < kFLickedDiffX || 
	   abs(diffContentY) > kFilckedDiffXinDiffY ||
	   abs(diffX) < abs(diffY)) {
		
		return EFlickedNone;
	}
	if(endPoint.x > startPoint.x)	return EFlickedRight;
	else							return EFlickedLeft;
}

@end
