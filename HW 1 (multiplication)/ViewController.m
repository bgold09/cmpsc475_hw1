//
//  ViewController.m
//  HW 1 (multiplication)
//
//  Created by BRIAN J GOLDEN on 9/4/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "ViewController.h"

#define NUMANSWERS 4
#define NUMQUESTIONS 7

@interface ViewController ()
@property NSInteger multiplicand;
@property NSInteger multiplier;
@property NSInteger result;
@property (strong, nonatomic) NSMutableArray *answers;
@property NSString *buttonText;
@property NSInteger numberCorrect;
@property NSInteger numberProblems;
@property NSInteger currentProblemNumber;
@property (weak, nonatomic) IBOutlet UILabel *multiplicandLabel;
@property (weak, nonatomic) IBOutlet UILabel *multiplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *answerSelections;
@property (weak, nonatomic) IBOutlet UILabel *questionCorrectLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButtonOutlet;
- (IBAction)nextButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.answers = [NSMutableArray arrayWithCapacity:NUMANSWERS];
    self.buttonText = @"Start";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButton:(id)sender {

}
@end
