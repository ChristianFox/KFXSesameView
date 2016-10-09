
/***************************
 
 Copyright (c) 2016 Christian Fox <christianfox890@icloud.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 
 ***************************/




#import "DEMOViewController.h"
#import <KFXSesameView/KFXSesameView.h>

@interface DEMOViewController () <KFXSesameViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *framingView;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (strong,nonatomic) KFXSesameView *sesameView;

@end

@implementation DEMOViewController



//--------------------------------------------------------
#pragma mark - Actions
//--------------------------------------------------------
-(IBAction)showCellsButtonTapped:(id)sender{
    
    self.sesameView.showCells = !self.sesameView.showCells;
}

-(IBAction)showInstructionsButtonTapped:(id)sender{
    
    self.instructionsLabel.hidden = !self.instructionsLabel.hidden;
    
    if (self.instructionsLabel.hidden) {
        self.instructionsLabel.text = @"";
    }else{
        NSString *instructions;
        switch (self.exampleNumber) {
            case 1:
                instructions = @"Tap each cell once. Start with top left, then bottom left, then top right and finally bottom right";
                break;
            case 2:
                instructions = @"Tap each cell twice starting with the top cell and moving down to the bottom cell";
                break;
            case 3:
                instructions = @" Tap x2 on R0;C0\n Tap x1 on R0;C1\n Tap x3 on R3;C3\n Tap x2 on R2:C2";
                break;
            default:
                break;
        }
        self.instructionsLabel.text = instructions;
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.sesameView setNeedsUpdateConstraints];
}


//======================================================
#pragma mark - ** Inherited Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - UIViewController
//--------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.instructionsLabel.text = @"";
    self.instructionsLabel.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    switch (self.exampleNumber) {
        case 1:
            [self addSesameViewForExample1];
            break;
        case 2:
            [self addSesameViewForExample2];
            break;
        case 3:
            [self addSesameViewForExample3];
            break;
        default:
            break;
    }
}




-(void)addSesameViewForExample1{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.framingView.bounds];
    imageView.image = [UIImage imageNamed:@"Forest"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    KFXSesameView *sesameView = [[KFXSesameView alloc]initWithFrame:self.framingView.bounds];
    sesameView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.framingView addSubview:imageView];
    [self.framingView addSubview:sesameView];

    
    sesameView.numberOfRows = 2;
    sesameView.numberOfColumns = 2;
    sesameView.showCells = NO;
    sesameView.delegate = self;
    sesameView.timeLimit = 10.0;
    
    NSError *error;
    if (![sesameView addCellToSequenceAtColumn:0
                                           row:0
                                  tapsRequired:1
                                    identifier:@"1top-left"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
    }
    if (![sesameView addCellToSequenceAtColumn:0
                                           row:1
                                  tapsRequired:1
                                    identifier:@"2bottom-left"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
    }
    if (![sesameView addCellToSequenceAtColumn:1
                                           row:0
                                  tapsRequired:1
                                    identifier:@"3top-right"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
    }
    if (![sesameView addCellToSequenceAtColumn:1
                                           row:1
                                  tapsRequired:1
                                    identifier:@"4bottom-right"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
    }

    self.sesameView = sesameView;
}

-(void)addSesameViewForExample2{
    
    
    CGRect frame = self.framingView.bounds;
    frame.size.width = 120.0;
    KFXSesameView *sesameView = [[KFXSesameView alloc]initWithFrame:frame];
    sesameView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.framingView addSubview:sesameView];
    
    sesameView.numberOfRows = 4;
    sesameView.numberOfColumns = 1;
    sesameView.showCells = YES;
    sesameView.delegate = self;
    sesameView.timeLimit = 10.0;
    
    NSError *error;
    if (![sesameView addCellToSequenceAtColumn:0
                                           row:0
                                  tapsRequired:2
                                    identifier:@"1"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
    }
    if (![sesameView addCellToSequenceAtColumn:0
                                           row:1
                                  tapsRequired:2
                                    identifier:@"2"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
    }
    if (![sesameView addCellToSequenceAtColumn:0
                                           row:2
                                  tapsRequired:2
                                    identifier:@"3"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
    }
    if (![sesameView addCellToSequenceAtColumn:0
                                           row:3
                                  tapsRequired:2
                                    identifier:@"4"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
    }
    
    self.sesameView = sesameView;

}

-(void)addSesameViewForExample3{
    
    KFXSesameView *sesameView = [[KFXSesameView alloc]initWithFrame:self.framingView.bounds];
    sesameView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    sesameView.numberOfRows = 4;
    sesameView.numberOfColumns = 4;
    sesameView.showCells = YES;
    sesameView.delegate = self;
    sesameView.timeLimit = 15.0;
    sesameView.lockCellsAfterSequenceCompletion = YES;
    
    NSError *error;
    if (![sesameView addCellToSequenceAtColumn:0
                                           row:0
                                  tapsRequired:2
                                    identifier:@"first"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
    }
    if (![sesameView addCellToSequenceAtColumn:1
                                           row:0
                                  tapsRequired:1
                                    identifier:@"second"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
        
    }
    if (![sesameView addCellToSequenceAtColumn:3
                                           row:3
                                  tapsRequired:3
                                    identifier:@"third"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
        
    }
    if (![sesameView addCellToSequenceAtColumn:2
                                           row:2
                                  tapsRequired:2
                                    identifier:@"forth"
                                         error:&error]){
        
        NSLog(@"ERROR: %@",error.localizedDescription);
        
    }
    
    
    [self.framingView addSubview:sesameView];
    self.sesameView = sesameView;
}


//--------------------------------------------------------
#pragma mark - KFXSesameViewDelegate
//--------------------------------------------------------
-(void)sesameViewTimeDidExpireBeforeSequenceUnlockComplete:(KFXSesameView *)sesameView{
    NSLog(@"Time did expire");
}

-(void)sesameView:(KFXSesameView *)sesameView didUnlockCell:(NSDictionary *)cellData{
    //    NSLog(@"Did unlock cell: %@",cellData);
    NSLog(@"Did unlock cell %@ with Identifier: %@",cellData[kKFXSesameViewCellSequencePositionKEY],cellData[kKFXSesameViewCellIdentifierKEY]);
    
}

-(void)sesameViewDidUnlockEntireSequence:(KFXSesameView *)sesameView{
    
    NSLog(@"Did complete unlock sequence ");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Open Sesame!"
                                                                   message:@"Sequence Complete.\n\n At this point we could unlock a secret part of the app or pull some data from a server or something else entirely - the choice is yours..."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cool!"
                                              style:UIAlertActionStyleDefault
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
