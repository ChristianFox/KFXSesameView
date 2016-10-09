

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


#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

// Keys for cellData dictionaries
extern NSString *const kKFXSesameViewCellRowIndexKEY;
extern NSString *const kKFXSesameViewCellColumnIndexKEY;
extern NSString *const kKFXSesameViewCellTapsRequiredKEY;
extern NSString *const kKFXSesameViewCellSequencePositionKEY;
extern NSString *const kKFXSesameViewCellIdentifierKEY;

// Error codes that can be ran into when using -addCellToSequenceAtColumn:row:tapsRequired:identifier:error:
typedef NS_ENUM(NSInteger, KFXSesameViewErrorCode){
    KFXSesameViewErrorCodeUndefined = 0,
    KFXSesameViewErrorCodeRowIndexGreaterNumberOfRows,
    KFXSesameViewErrorCodeColumnIndexGreaterNumberOfColumns,
    KFXSesameViewErrorCodeTapsRequiredTooLow,
    KFXSesameViewErrorCodeNumberRowsIsZero,
    KFXSesameViewErrorCodeNumberColumnsIsZero
};




@class KFXSesameView;
@protocol KFXSesameViewDelegate <NSObject>
@required
/// Called when every cell in the sequence has been unlocked by the requistite number of taps.
-(void)sesameViewDidUnlockEntireSequence:(KFXSesameView*)sesameView;
@optional
/// Called when any cell in the sequence has been unlocked. cellData is a dictionary of data about the cell that has been unlocked, the keys are defined as constants in KFXSesameView.h
-(void)sesameView:(KFXSesameView*)sesameView didUnlockCell:(NSDictionary*)cellData;
/// Called if the first cell in the sequence has been unlocked but the remaining cells were not unlocked within the time limit..
-(void)sesameViewTimeDidExpireBeforeSequenceUnlockComplete:(KFXSesameView*)sesameView;

@end






@interface KFXSesameView : UIView

@property (weak, nonatomic, nullable) id<KFXSesameViewDelegate> delegate;
// Configurable Properties
/// How many rows of cells are required
@property (nonatomic) NSUInteger numberOfRows;
/// How many coloumns of cells are required
@property (nonatomic) NSUInteger numberOfColumns;
/// The time allowed between unlocking the first cell and unlocking the last. If all cells have not been unlocked in this time then any unlocked cells will reset to their locked state. This value can be 0 for unlimited time.
@property (nonatomic) NSTimeInterval timeLimit;
/// If YES then the cells will be visible and the backgroundColor property will be set to a random colour. If NO the cells will have the backgroundColor property set to -clearColor.
@property (nonatomic) BOOL showCells;
/// If YES then once the sequence has been unlocked all cells in the sequence will be re-locked.
@property (nonatomic) BOOL lockCellsAfterSequenceCompletion;


/**
 * @brief Set the cell at the given coordinates an being involved in the unlock sequence.
 * @warning Do not add a cell to the sequence more than once as there is no code to handle this situation correctly.
 * @param columnIdx The column index of the cell to be included as part of the unlock sequence. The index of the first row is 0. Must be less than the numberOfColums.
 * @param rowIdx The row index of the cell to be included as part of the unlock sequence. The index of the first row is 0. Must be less than the numberOfRows.
 * @param tapsRequired The number of times the cell must be tapped to unlock it. Must be greater than 0.
 * @param error An NSError reference that will be initilised if an error occurs
 * @return YES if the cell was configured, NO if there was an error.
 * @since 0.1.0
 *
 **/
-(BOOL)addCellToSequenceAtColumn:(NSUInteger)columnIdx
                             row:(NSUInteger)rowIdx
                    tapsRequired:(NSUInteger)tapsRequired
                      identifier:(NSString*_Nullable)identifier
                           error:(NSError*_Nullable*)error;




@end
NS_ASSUME_NONNULL_END
