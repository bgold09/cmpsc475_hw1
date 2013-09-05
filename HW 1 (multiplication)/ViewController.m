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
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
- (IBAction)nextButton:(id)sender;
- (IBAction)AnswerSelected:(id)sender;
- (void) CreateProblem;

@end

static NSString *kNextText = @"Next";
static NSString *kStartText = @"Start a Game";
static NSString *kResetText = @"Reset the Game";
static NSString *kCorrectText = @"Correct!";
static NSString *kIncorrectText = @"Incorrect";
static NSString *kStartNumberText = @"##";
static NSString *kStartAnswerText = @"**";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButton:(id)sender {
    if (self.currentProblemNumber == 0) {
        // have not started problems yet, pose the first question
        [sender setTitle:kNextText forState:UIControlStateNormal];
        self.nextButtonOutlet.enabled = NO;
        self.inProgress = YES;
        self.nextButtonOutlet.enabled = NO;
        [self CreateProblem];
    } else if (self.currentProblemNumber < kNumQuestions) {
        // create another question
        [self CreateProblem];
    } else if (self.currentProblemNumber == kNumQuestions) {
        // done with questions, set button to reset
        [sender setTitle:kNextText forState:UIControlStateNormal];
        [self ResetGame];
    }
}

- (IBAction)AnswerSelected:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *) sender;
    
    // no answer was selected yet
    if (!self.answerSelected && self.inProgress) {
        NSInteger selectedAnswer =
            [[control titleForSegmentAtIndex: [control selectedSegmentIndex]] integerValue];

        // was the correct answer selected?
        if (selectedAnswer == self.result) {
            self.correctLabel.text = kCorrectText;
            self.numberCorrect++;
        } else {
            self.correctLabel.text = kIncorrectText;
        }
        
        self.currentProblemNumber++;
        self.resultLabel.hidden = NO;
        
        self.correctLabel.hidden = NO;
        self.questionCorrectLabel.hidden = NO;
        self.questionCorrectLabel.text =
            [NSString stringWithFormat:@"%d/%d Questions Correct",
                                        self.numberCorrect, self.currentProblemNumber];
        
        self.nextButtonOutlet.enabled = YES;
        self.inProgress = NO;
        self.answerSelections.enabled = NO;
        
        [self.progressBar setProgress:(float) self.currentProblemNumber / (float) kNumQuestions animated:YES];
        
        if (self.currentProblemNumber == kNumQuestions) {
            [self.nextButtonOutlet setTitle:kResetText forState:UIControlStateNormal];
        }
    }
}

- (void) ResetGame {
    self.currentProblemNumber = 0;
    self.numberCorrect = 0;
    self.questionCorrectLabel.hidden = YES;
    self.correctLabel.hidden = YES;
    self.inProgress = YES;
    self.nextButtonOutlet.enabled = YES;
    self.multiplicandLabel.text = kStartNumberText;
    self.multiplierLabel.text = kStartNumberText;
    [self.nextButtonOutlet setTitle:kStartText forState:UIControlStateNormal];
    [self.answerSelections setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [self.progressBar setProgress:0.0 animated:NO];
    
    for (NSInteger i = 0; i < kNumAnswers; i++) {
        [self.answerSelections setTitle:kStartAnswerText forSegmentAtIndex:i];
    }
}

- (void) CreateProblem {
    // create problem and result
    self.multiplicand = arc4random_uniform(kMaxNumber) + 1;
    self.multiplier = arc4random_uniform(kMaxNumber) + 1;
    self.result = self.multiplier * self.multiplicand;
    self.multiplicandLabel.text = [NSString stringWithFormat:@"%d", self.multiplicand];
    self.multiplierLabel.text = [NSString stringWithFormat:@"%d", self.multiplier];
    
    NSMutableArray *answers = [NSMutableArray arrayWithCapacity:kNumAnswers];    
    answers[0] = [NSNumber numberWithInt:self.result];
    
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
            items = [answers subarrayWithRange:range];
        } while ([items containsObject:candidate] || candidate == 0);
        
        [answers insertObject:candidate atIndex:i];
    }
    
    // exchange the correct answer with another answer
    [answers exchangeObjectAtIndex:0 withObjectAtIndex:arc4random_uniform(kNumAnswers)];
    
    for (NSInteger i = 0; i < kNumAnswers; i++) {
        NSString *answerText = [NSString stringWithFormat:@"%d", [answers[i] integerValue]];
        [self.answerSelections setTitle:answerText forSegmentAtIndex:i];
    }
    
    [self.answerSelections setSelectedSegmentIndex:UISegmentedControlNoSegment];
    self.answerSelections.enabled = YES;
    self.resultLabel.hidden = YES;
    self.questionCorrectLabel.hidden = YES;
    self.correctLabel.hidden = YES;
    self.nextButtonOutlet.enabled = NO;
    self.inProgress = YES;
}

@end





