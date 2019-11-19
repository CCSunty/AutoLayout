//
//  ViewController.m
//  Autolayout
//
//  Created by Ducky on 2019/11/11.
//  Copyright © 2019 Ducky. All rights reserved.
//

#import "ViewController.h"
#import "BDPanThreadSafeDictionary.h"
#import "ALView.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) UILabel *aLabel;

@property (nonatomic, strong) ALView *redView;

@property (nonatomic, strong) MASConstraint *constraint;

@property (nonatomic, strong) BDPanThreadSafeDictionary *mDictionary;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view.
    _aLabel = [[UILabel alloc] init];
    _aLabel.font = [UIFont systemFontOfSize:20];
    _aLabel.numberOfLines = 3;
    _aLabel.textColor = [UIColor redColor];
    [self.view addSubview:_aLabel];
    [_aLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(@(10));
        make.leftMargin.and.rightMargin.equalTo(self.view).inset(10);
    }];
    _aLabel.text = @"10086";
    _redView = [[ALView alloc] init];
    _redView.backgroundColor = [UIColor redColor];
    _redView.preservesSuperviewLayoutMargins = YES;
    [self.view addSubview:_redView];
    [_redView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self.view.mas);
        self.constraint = make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.left.and.right.equalTo(self.view);
        //self.constraint = make.top.equalTo(self.aLabel.mas_lastBaseline).offset(10);
        //make.height.equalTo(self.view).dividedBy(3).priorityLow();
        //make.height.equalTo(self.view).with.priorityMedium();
        //make.leftMargin.and.rightMargin.equalTo(self.view).inset(30).with.priorityHigh();
    }];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.constraint.inset(100);
//        [self.view setNeedsUpdateConstraints];
//        [UIView animateWithDuration:.3 animations:^{
//            [self.view layoutIfNeeded];
//        }];
//    });
    self.view.backgroundColor = [UIColor blackColor];
    
    _mDictionary = [BDPanThreadSafeDictionary dictionary];
}

- (void)injected {
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    dispatch_apply(2000000, dispatch_get_main_queue(), ^(size_t size) {
//    });
    
    for (int i = 0; i < 2000000; i ++) {
        if (arc4random() % 2 == 0) {
            NSLog(@"Thread = %@ %@ index = %d",[NSThread currentThread] , @"写入",i);
            [self.mDictionary setObject:@(i) forKey:[@(i) stringValue]];
        } else {
            NSLog(@"Thread = %@ %@ index = %d",[NSThread currentThread] , @"读取",i);
            [self.mDictionary objectForKey:[@(i) stringValue]];
        }
    }
}


@end
