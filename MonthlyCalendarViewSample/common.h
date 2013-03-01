//
//  common.h
//  MonthlyCalendarViewSample
//

#ifdef __DEBUG__
#define LOG(...) NSLog(__VA_ARGS__)
#define LOG_CURRENT_METHOD NSLog(NSStringFromSelector(_cmd))
#else
#define LOG(...) ;
#define LOG_CURRENT_METHOD ;
#endif

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0];  

#define RESOURCE_PATH [[NSBundle mainBundle] resourcePath]
