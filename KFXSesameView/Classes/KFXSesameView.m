

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



#import "KFXSesameView.h"

NSString *const kKFXSesameViewCellRowIndexKEY = @"rowIndex";
NSString *const kKFXSesameViewCellColumnIndexKEY = @"columnIndex";
NSString *const kKFXSesameViewCellTapsRequiredKEY = @"tapsRequired";
NSString *const kKFXSesameViewCellSequencePositionKEY = @"sequencePosition";
NSString *const kKFXSesameViewCellIdentifierKEY = @"identifier";
NSString *const kKFXSesameViewErrorDomain = @"com.kfxtech.sesameview";



@interface KFXSesameView () <UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableDictionary *cells;
@property (strong,nonatomic) NSMutableDictionary *unlockGestures;
@property (strong,nonatomic) NSMutableArray *locks;
@property (strong,nonatomic) NSTimer *timer;

@end









@implementation KFXSesameView

//======================================================
#pragma mark - ** Public Methods **
//======================================================
//--------------------------------------------------------
#pragma mark -
//--------------------------------------------------------
-(BOOL)addCellToSequenceAtColumn:(NSUInteger)columnIdx
                             row:(NSUInteger)rowIdx
                    tapsRequired:(NSUInteger)tapsRequired
                      identifier:(NSString*_Nullable)identifier
                           error:(NSError * _Nullable __autoreleasing *)error{
    
    NSError *localError;
    
    // ## Defensive ##
    if (self.numberOfRows == 0) {
        
        localError = [NSError errorWithDomain:kKFXSesameViewErrorDomain
                                         code:KFXSesameViewErrorCodeNumberRowsIsZero
                                     userInfo:@{NSLocalizedDescriptionKey:@"SesameView has 0 rows. You need to set the number of rows and columns before adding a cell to the sequence"}];
        
    }else if (self.numberOfColumns == 0){
        
        localError = [NSError errorWithDomain:kKFXSesameViewErrorDomain
                                         code:KFXSesameViewErrorCodeNumberColumnsIsZero
                                     userInfo:@{NSLocalizedDescriptionKey:@"SesameView has 0 columns. You need to set the number of rows and columns before adding a cell to the sequence"}];
        
        
    }else if (rowIdx+1 > self.numberOfRows) {
        
        localError = [NSError errorWithDomain:kKFXSesameViewErrorDomain
                                         code:KFXSesameViewErrorCodeRowIndexGreaterNumberOfRows
                                     userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The given rowIdx '%lu' is higher than the numberOfRows '%ld'",(unsigned long)rowIdx,(unsigned long)self.numberOfRows]}];
        
    }else if (columnIdx+1 > self.numberOfColumns){
        
        localError = [NSError errorWithDomain:kKFXSesameViewErrorDomain
                                         code:KFXSesameViewErrorCodeColumnIndexGreaterNumberOfColumns
                                     userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"The given columnIdx '%lu' is higher than the numberOfColumss '%ld'",(unsigned long)columnIdx,(unsigned long)self.numberOfColumns]}];
        
    }else if (tapsRequired == 0){
        
        localError = [NSError errorWithDomain:kKFXSesameViewErrorDomain
                                         code:KFXSesameViewErrorCodeTapsRequiredTooLow
                                     userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"You have specified 0 taps required, you must specify a positive integer"]}];
        
    }
    
    
    if (localError != nil) {
        if (error != nil) {
            *error = localError;
        }
        return NO;
    }
    
    
    // ## ** Passed Defenses ** ##
    // Make Cell Dictionary
    NSMutableDictionary *cellDict = [@{
                                       kKFXSesameViewCellRowIndexKEY:@(rowIdx),
                                       kKFXSesameViewCellColumnIndexKEY:@(columnIdx),
                                       kKFXSesameViewCellTapsRequiredKEY:@(tapsRequired),
                                       kKFXSesameViewCellSequencePositionKEY:@(self.cells.count),
                                       } mutableCopy];
    if (identifier != nil) {
        [cellDict setObject:identifier forKey:kKFXSesameViewCellIdentifierKEY];
    }
    
    [self.cells setObject:cellDict forKey:[self cellKeyWithColumnIndex:columnIdx rowIndex:rowIdx]];
    
    // Add lock
    [self.locks addObject:@(YES)];
    
    return YES;
}


//--------------------------------------------------------
#pragma mark - Public Accessors
//--------------------------------------------------------
-(void)setShowCells:(BOOL)showCells{
    _showCells = showCells;
    [self.collectionView reloadData];
}


//======================================================
#pragma mark - ** Inherited Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - UIView
//--------------------------------------------------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self sharedInitiliser];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInitiliser];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self sharedInitiliser];
    }
    return self;
}


-(void)updateConstraints{
    [super updateConstraints];
    if (self.collectionView.visibleCells.count >= 1) {
        [self.collectionView reloadData];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.collectionView.visibleCells.count >= 1) {
        [self.collectionView reloadData];
    }
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    if (self.collectionView.visibleCells.count >= 1) {
        [self.collectionView reloadData];
    }
}

//======================================================
#pragma mark - ** Protocol Methods **
//======================================================
//--------------------------------------------------------
#pragma mark - UICollectionViewDataSource
//--------------------------------------------------------
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.numberOfColumns;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numberOfRows;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SesameCell" forIndexPath:indexPath];
    
    if (self.showCells) {
        cell.backgroundColor = [self randomColourWithRandomAlpha:NO alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    NSString *cellKey = [self cellKeyWithColumnIndex:indexPath.section rowIndex:indexPath.row];
    NSDictionary *cellDict = self.cells[cellKey];
    
    if (cellDict != nil) {
        // This cell is part of the unlock sequence so add a gesture recogniser
        // First see if GR has already been created and use that if available, otherwise create a new one and store so we work out which gesture was tapped later
        UITapGestureRecognizer *gesture = self.unlockGestures[cellKey];
        if (gesture == nil) {
            gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didRecogniseTapGesture:)];
            gesture.numberOfTapsRequired = [cellDict[kKFXSesameViewCellTapsRequiredKEY] unsignedIntegerValue];
            [self.unlockGestures setObject:gesture forKey:cellKey];
        }
        
        [cell addGestureRecognizer:gesture];
        
    }else{
        // If cell is not a lockable cell then incase it has been reused from a lockable cell we want to make sure the gesture recogniser/s are not hanging around
        for (UIGestureRecognizer *oldGesture in cell.gestureRecognizers) {
            [cell removeGestureRecognizer:oldGesture];
            
        }
    }
    
    return cell;
}


//--------------------------------------------------------
#pragma mark - UICollectionViewDelegate
//--------------------------------------------------------

//--------------------------------------------------------
#pragma mark - UICollectionViewDelegateFlowLayout
//--------------------------------------------------------
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (self.bounds.size.width * 1.0) / self.numberOfColumns;
    CGFloat height = (self.bounds.size.height * 1.0) / self.numberOfRows;
    return CGSizeMake(width, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}



//======================================================
#pragma mark - ** Private Methods **
//======================================================
//--------------------------------------------------------
#pragma mark -
//--------------------------------------------------------
-(void)sharedInitiliser{
    
    self.timeLimit = 0.0;
    self.numberOfRows = 0;
    self.numberOfColumns = 0;
    self.showCells = NO;
    self.lockCellsAfterSequenceCompletion = YES;
    [self configureCollectonView];
    self.backgroundColor = [UIColor clearColor];
    
}

//--------------------------------------------------------
#pragma mark - Configure
//--------------------------------------------------------
-(void)configureCollectonView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SesameCell"];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.collectionView];
    
    NSDictionary *viewsDict = @{@"collectionView":self.collectionView};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:viewsDict]];
}


-(void)timerDidFire:(NSTimer*)timer{
    
    [timer invalidate];
    self.timer = nil;
    if ([self.delegate respondsToSelector:@selector(sesameViewTimeDidExpireBeforeSequenceUnlockComplete:)]) {
        [self.delegate sesameViewTimeDidExpireBeforeSequenceUnlockComplete:self];
    }
    [self lockAllCells];
    
}

//--------------------------------------------------------
#pragma mark - Gesture Recognisers
//--------------------------------------------------------
-(void)didRecogniseTapGesture:(UITapGestureRecognizer*)recogniser{
    /*
     // Use the recogniser to find the corresponding cellKey and then get the cellDict
     // Then inform delegate of cell unlock
     // If first in sequence then set timer
     // If last in sequence then end timer and inform delegate
     */
    
    for (NSString *cellKey in self.unlockGestures) {
        
        UIGestureRecognizer *storedRecogniser = self.unlockGestures[cellKey];
        if (recogniser == storedRecogniser) {
            
            NSMutableDictionary *cellDict = self.cells[cellKey];
            NSUInteger sequencePosition = [cellDict[kKFXSesameViewCellSequencePositionKEY] unsignedIntegerValue];
            
            // Has the previous cell in the sequence been unlocked. If not then we don't want to unlock the cell out of order so return
            if (sequencePosition != 0) {
                BOOL previousIsLocked = [self.locks[sequencePosition-1]boolValue];
                if (previousIsLocked) {
                    return;
                }
            }
            
            // Unlock
            self.locks[sequencePosition] = @NO;
            
            if (sequencePosition == 0) {
                
                // If it is the first cell in the sequence then we must set a timer if one has not been set already
                [self.timer invalidate];
                if (self.timeLimit > 0.01) {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeLimit
                                                                  target:self
                                                                selector:@selector(timerDidFire:)
                                                                userInfo:nil
                                                                 repeats:NO];
                    
                }
                
            }
            if ([self.delegate respondsToSelector:@selector(sesameView:didUnlockCell:)]) {
                [self.delegate sesameView:self didUnlockCell:[cellDict copy]];
            }
            
            if (sequencePosition+1 == self.cells.count) {
                [self.timer invalidate];
                [self.delegate sesameViewDidUnlockEntireSequence:self];
                if (self.lockCellsAfterSequenceCompletion) {
                    [self lockAllCells];
                }
                
            }
            
        }
    }
}



//--------------------------------------------------------
#pragma mark - Helpers
//--------------------------------------------------------
-(NSString*)cellKeyWithColumnIndex:(NSUInteger)columnIdx rowIndex:(NSUInteger)rowIdx{
    
    NSString *cellKey = [NSString stringWithFormat:@"Cell-%ld-%ld",(long)columnIdx,(long)rowIdx];
    return cellKey;
}


-(UIColor*)randomColourWithRandomAlpha:(BOOL)useRandomAlpha alpha:(CGFloat)alpha{
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    CGFloat finalAlpha;
    if (useRandomAlpha) {
        finalAlpha = ( arc4random() % 128 / 256.0 );
    }else{
        finalAlpha = alpha;
    }
    
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:finalAlpha];
    return color;
}


-(void)lockAllCells{
    
    [self.locks removeAllObjects];
    
    for (NSUInteger idx = 0; idx < self.cells.count; idx++) {
        [self.locks addObject:@YES];
    }
}


//--------------------------------------------------------
#pragma mark - Lazy Load
//--------------------------------------------------------
-(NSMutableDictionary *)cells{
    if (!_cells) {
        _cells = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _cells;
}

-(NSMutableDictionary *)unlockGestures{
    if (!_unlockGestures) {
        _unlockGestures = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _unlockGestures;
}

-(NSMutableArray *)locks{
    if (!_locks) {
        _locks = [NSMutableArray arrayWithCapacity:1];
    }
    return _locks;
}



@end


























