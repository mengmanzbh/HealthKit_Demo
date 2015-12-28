//
//  ViewController.m
//  WTHealth
//
//  Created by wadewade on 15/9/30.
//  Copyright (c) 2015年 WT. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>

@interface ViewController ()
{
    UILabel *stepLabel;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, self.view.frame.size.height/2 + 100, self.view.frame.size.width - 10, 200)];
    stepLabel.numberOfLines = 0;
    stepLabel.backgroundColor = [UIColor purpleColor];
    stepLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:stepLabel];
    [self createButton];
    
}
- (void)createButton{
    UIButton *getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    getButton.frame = CGRectMake(self.view.bounds.size.width/2 - 40, self.view.bounds.size.height/2 - 20, 80, 40);
    [getButton setTitle:@"获取步数" forState:UIControlStateNormal];
    [getButton setBackgroundColor:[UIColor orangeColor]];
    [getButton addTarget:self action:@selector(getStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getButton];
    
}
- (void)getStep{
    HKHealthStore *healthStore = [[HKHealthStore alloc]init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc]init];
    interval.day = 7;
    //设置一个计算的时间点
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth |NSCalendarUnitYear | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    NSInteger offset = (7 + anchorComponents.weekday - 2)%7;
    anchorComponents.day -= offset;
    //设置从几点开始计时
    anchorComponents.hour = 3;
    interval.day = 1;
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
//    HKQuantityType *qiantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];//步数
    HKQuantityType *qiantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    //创建查询   intervalcomponents:按照多少时间间隔查询
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc]initWithQuantityType:qiantityType quantitySamplePredicate:nil options:HKStatisticsOptionCumulativeSum anchorDate:anchorDate intervalComponents:interval];
    
    
    //查询结果
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query,HKStatisticsCollection *results,NSError *error){
        if (error) {
            NSLog(@"error = %@",error.description);
        }
        
        NSLog(@"%@",results);
        NSDate *endDate = [NSDate date];
        /*value 这个参数很重要  －5：表示从今天开始逐步查询后面五天的步数
         NSCalendarUnitDay  表示按照什么类型输出
         */
        NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-5 toDate:endDate options:0];
        
        [results enumerateStatisticsFromDate:startDate toDate:endDate withBlock:^(HKStatistics * _Nonnull result, BOOL * _Nonnull stop) {
            HKQuantity *quantity = result.sumQuantity;
            //            if (quantity) {
            NSDate *date = result.startDate;
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            //设置时区
            [outputFormatter setLocale:[NSLocale currentLocale]];
            [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
            NSString *str = [outputFormatter stringFromDate:date];
            
            double value = [quantity doubleValueForUnit:[HKUnit meterUnit]];//移动距离
//            double value = [quantity doubleValueForUnit:[HKUnit countUnit]];// 步数
            NSLog(@"date = %@,value = %f\n",str,value);
            dispatch_async(dispatch_get_main_queue(), ^{
                stepLabel.text = [NSString stringWithFormat:@"%@\ndate = %@,value = %f\n",stepLabel.text,str,value];
                
            });
            
        }];
        
    };
    [healthStore executeQuery:query];
}
- (void)viewDidAppear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
