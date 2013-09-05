//
//  ViewController.m
//  HW 1 (multiplication)
//
//  Created by BRIAN J GOLDEN on 9/4/13.
//  Copyright (c) 2013 BRIAN J GOLDEN. All rights reserved.
//

#import "ViewController.h"

#define kNumAnswers   4
#define kNumQuestions 10
#define kMaxNumber    15
#define kRange        5

@interface ViewController ()
@property NSInteger multiplicand;
@property NSInteger multiplier;
@property NSInteger result;
@property (strong, nonatomic) NSMutableArray *answers;
@property NSInteger numberCorrect;
@property NSInteger currentProblemNumber;
@property BOOL inProgress;
@property BOOL answerSelected;
@property (weak, nonatomic) IBOutlet UILabel *multiplicandLabel;
@property (weak, nonatomic) IBOutlet UILabel *multiplierLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *answerSelections;
@property (weak, nonatomic) IBOutlet UILabel *questionCorrectLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButtonOutlet;
- (IBAction)nextButton:(id)sender;
- (IBAction)AnswerSelected:(id)sender;
- (void) CreateProblem;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.answers = [NSMutableArray arrayWithCapacity:kNumAnswers];
    for (NSInteger i = 0; i < kNumAnswers; i++) {
        [self.answers insertObject:[NSNumber numberWithInt:0] atIndex:i];
    }
    
    self.answerSelections.selectedSegmentIndex = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButton:(id)sender {
    if (self.currentProblemNumber == 0) {
        // have not started problems yet, pose the first question
        [sender setTitle:@"Next" forState:UIControlStateNormal];
        self.nextButtonOutlet.enabled = NO;
        self.inProgress = YES;
        self.nextButtonOutlet.enabled = NO;
        [self CreateProblem];                                  //create the first problem
    } else if (self.currentProblemNumber < kNumQuestions) {
        // create another question
        [self CreateProblem];
        self.resultLabel.hidden = YES;
        self.questionCorrectLabel.hidden = YES;
        self.correctLabel.hidden = YES;
        self.nextButtonOutlet.enabled = NO;
        self.inProgress = YES;
    } else if (self.currentProblemNumber == kNumQuestions) {
        // done with questions
        // set button to reset
        [sender setTitle:@"Next" forState:UIControlStateNormal];
        [self ResetGame];
    }
}

- (IBAction)AnswerSelected:(id)sender {

    UISegmentedControl *control = (UISegmentedControl *) sender;
    
    // no answer was selected yet
    if (!self.answerSelected && self.inProgress) {
        NSString *text = [control titleForSegmentAtIndex: [control selectedSegmentIndex]];
        NSInteger selectedAnswer = [text integerValue];
        self.resultLabel.text = [NSString stringWithFormat:@"%d", selectedAnswer];
        
        if (selectedAnswer == self.result) {
            // correct answer selected
            self.correctLabel.text = @"Correct!";
            self.numberCorrect++;
        } else {
            self.correctLabel.text = @"Incorrect";
        }
        
        self.currentProblemNumber++;
        
        self.resultLabel.text = [NSString stringWithFormat:@"%d", self.result];
        self.resultLabel.hidden = NO;
        
        self.correctLabel.hidden = NO;
        self.questionCorrectLabel.hidden = NO;
        self.questionCorrectLabel.text =
            [NSString stringWithFormat:@"%d/%d Questions Correct",
                                        self.numberCorrect, self.currentProblemNumber];
        
        self.nextButtonOutlet.enabled = YES;
        self.inProgress = NO;
        self.answerSelections.enabled = NO;
    }
}

- (void) ResetGame {
    self.currentProblemNumber = 0;
    self.numberCorrect = 0;
    self.questionCorrectLabel.hidden = YES;
    self.correctLabel.hidden = YES;
    self.nextButtonOutlet.titleLabel.text = @"Reset";
    self.nextButtonOutlet.enabled = YES;
    [self.answerSelections setSelectedSegmentIndex:UISegmentedControlNoSegment];
    self.nextButtonOutlet.enabled = NO;
    self.inProgress = YES;
    self.nextButtonOutlet.enabled = NO;
    [self CreateProblem];
}

- (void) CreateProblem {
    // create problem and result
    self.multiplicand = arc4random_uniform(kMaxNumber) + 1;
    self.multiplier = arc4random_uniform(kMaxNumber) + 1;
    self.result = self.multiplier * self.multiplicand;
    self.multiplicandLabel.text = [NSString stringWithFormat:@"%d", self.multiplicand];
    self.multiplierLabel.text = [NSString stringWithFormat:@"%d", self.multiplier];
    
    self.answers[0] = [NSNumber numberWithInt:self.result];
    
    // set label for correct answer
    NSString *resultText = [NSString stringWithFormat:@"%d", self.result];
    self.resultLabel.text = resultText;

    NSInteger min = self.result - kRange;
    NSInteger max = self.result + kRange;
    
    if (min < 1) {
        min = 1;
    }
    
    for (NSInteger i = 1; i < kNumAnswers; i++) {
        NSRange range = NSMakeRange(0, i);
        NSArray *items;
        NSNumber *candidate;
        
        do {
            NSInteger newNumber = min + arc4random() % (max - min);
            candidate = [NSNumber numberWithInt:newNumber];
            items = [self.answers subarrayWithRange:range];
        } while ([items containsObject:candidate] || candidate == 0);
        
        [self.answers insertObject:candidate atIndex:i];
    }
    
    // exchange the correct answer with another answer
    NSInteger index = arc4random_uniform(kNumAnswers);
    [self.answers exchangeObjectAtIndex:0 withObjectAtIndex:index];
    
    for (NSInteger i = 0; i < kNumAnswers; i++) {
        NSString *answerText = [NSString stringWithFormat:@"%d", [self.answers[i] integerValue]];
        [self.answerSelections setTitle:answerText forSegmentAtIndex:i];
    }
    
    [self.answerSelections setSelectedSegmentIndex:UISegmentedControlNoSegment];
    self.answerSelections.enabled = YES;
}

@end





