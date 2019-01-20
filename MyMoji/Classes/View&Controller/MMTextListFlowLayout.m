//
//  MMTextListFlowLayout.m
//  MyMoji
//
//  Created by Xingfa Zhou on 2019/1/4.
//  Copyright © 2019 BeterLife. All rights reserved.
//

#import "MMTextListFlowLayout.h"

static float kItemSpace = 3.f;

@interface MMTextListFlowLayout ()
@property (nonatomic,strong) NSMutableArray *attributesArray;
@end

@implementation MMTextListFlowLayout


-(instancetype)initWithItemSizeArray:(NSArray<NSArray *> *)widthArray{
    if (self = [super init]) {
        self.itemSizeArray = widthArray;
        NSLog(@"==***==%p",self.itemSizeArray);
    }
    return self;
}


/**
 *另外需要了解的是，在初始化一个UICollectionViewLayout实例后，会有一系列准备方法被自动调用，以保证layout实例的正确。
 
 *首先，将被调用，默认下该方法什么没做，但是在自己的子类实现中，一般在该方法中设定一些必要的layout的结构和初始需要的参数等。
 
 */

-(void)prepareLayout{
    
    NSLog(@"---------1");
    
    ///和init相似，必须call super的prepareLayout以保证初始化正确
    [super prepareLayout];
    ///1.首先被调用
    
    [self.attributesArray removeAllObjects];

    for (int section = 0; section < self.itemSizeArray.count; section++) {
        NSArray *rows = self.itemSizeArray[section];
        
        NSMutableArray *rowsAttributes = [NSMutableArray arrayWithCapacity:rows.count];
         [self.attributesArray addObject:rowsAttributes];
        
        for (int row = 0; row < rows.count ; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self caculateLayoutAttributesForItemAtIndexPath:indexPath];
            [rowsAttributes addObject:attributes];
        }
        
       
    }
    NSLog(@"self.attributesArray:%@",self.attributesArray);
    
}

- (UICollectionViewLayoutAttributes *)caculateLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSValue *theSizeValue =[self.itemSizeArray[indexPath.section] objectAtIndex:indexPath.item];
    CGSize theSize = [theSizeValue CGSizeValue];
    
    CGFloat width = theSize.width ;
    CGFloat height = theSize.height;
    
    
    CGFloat collectionWidth = self.collectionView.frame.size.width  ;
    
    CGFloat oneSpace = (collectionWidth - kItemSpace)/3.0 - kItemSpace ;
    CGFloat twoSpace = oneSpace * 2 + kItemSpace ;
    CGFloat threeSpace = twoSpace +oneSpace + kItemSpace;
   
    CGFloat yOffset = 0 ;
    CGFloat xOffset = kItemSpace;
    
     CGRect currentFrame = CGRectZero;
    
    if (indexPath.item == 0) {
        if (indexPath.section == 0) {
             yOffset = 30;
        }else{
            //
             UICollectionViewLayoutAttributes *lastSectionlastAttributs = [self.attributesArray[indexPath.section - 1] objectAtIndex:[self.itemSizeArray[indexPath.section -1] count]-1];
            //换一行
            yOffset = CGRectGetMaxY(lastSectionlastAttributs.frame) +30 ;
        }
       
        //第一个cell
        if (width > twoSpace ){
            width = threeSpace ;
        }else if (width > oneSpace){
            width = twoSpace ;
        }else{
            width = oneSpace;
        }
    }else if(indexPath.item <  (self.itemSizeArray[indexPath.section].count)){
        // 从第二个cell开始 参考前一个布局的位置
        UICollectionViewLayoutAttributes *lastAttributs = [self.attributesArray[indexPath.section] objectAtIndex:indexPath.item - 1];
        
        CGRect lastFrame = lastAttributs.frame;
        
        CGFloat leftWidth = collectionWidth - CGRectGetMaxX(lastFrame) - 2* kItemSpace;
        
        if (leftWidth > oneSpace){
            //剩下的空间可以摆放当前item
            
            if(width < oneSpace){
                width = oneSpace;
                yOffset = lastFrame.origin.y ;
                xOffset = CGRectGetMaxX(lastFrame) + kItemSpace;
            }else if (width < twoSpace){
                width =twoSpace;
                yOffset = lastFrame.origin.y ;
                xOffset = CGRectGetMaxX(lastFrame) + kItemSpace;
            }else{
                //换一行
                yOffset = CGRectGetMaxY(lastFrame) + self.minimumLineSpacing ;
                width = threeSpace ;
                xOffset =  kItemSpace;
            }
        }else if ((leftWidth > kItemSpace)&&(width < oneSpace)){
                width = oneSpace;
                yOffset = lastFrame.origin.y ;
                xOffset = CGRectGetMaxX(lastFrame) + kItemSpace;
        }else{
            //换一行
            yOffset = CGRectGetMaxY(lastFrame) + self.minimumLineSpacing ;
            xOffset =  kItemSpace;
            
            if(width < oneSpace){
                width = oneSpace;
            }else if (width < twoSpace){
                width =twoSpace;
            }else{
                width = threeSpace ;
            }
        }
    }
    
    currentFrame.origin.x = xOffset;
    currentFrame.origin.y =  yOffset;
    currentFrame.size.width = width;
    currentFrame.size.height = height;
    attributs.frame = currentFrame;
    
    
    return attributs;
}




/////返回collectionView的内容的尺寸
//-(CGSize)collectionViewContentSize{
//    ///2.其次被调用(layoutAttributesForElementsInRect 调用后会在此调用此方法)
//    NSLog(@"---%f------2",self.maxY);
//    return CGSizeMake(self.collectionView.bounds.size.width, self.maxY);
//}

///返回rect中的所有的元素的布局属性,返回的是包含UICollectionViewLayoutAttributes的NSArray
///UICollectionViewLayoutAttributes可以是cell，追加视图或装饰视图的信息，通过不同的UICollectionViewLayoutAttributes初始化方法可以得到不同类型的
///初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定。

///rect 为collectionview 的rect，（高度超出当前屏幕的高度后，rect的height会翻倍）
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    ///3.被调用
    NSLog(@"---------3");

    NSMutableArray *all = [NSMutableArray array];
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    [all addObjectsFromArray:array];

    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [all removeObject:attributes];
           
//            for (UICollectionViewLayoutAttributes *theAttributes in self.attributesArray) {
//                if (theAttributes.indexPath.section == attributes.indexPath.section && theAttributes.indexPath.item == attributes.indexPath.item) {
//
//                    [all addObject:theAttributes];
//                    break ;
//                }
//            }
        }
    }
    
    for (NSArray *arr in self.attributesArray) {
        [all addObjectsFromArray:arr];
    }
    return all;
}


///返回对应于indexPath的位置的cell的布局属性,返回指定indexPath的item的布局信息。子类必须重载该方法,该方法只能为cell提供布局信息，不能为补充视图和装饰视图提供。
-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath{
    
    return [self.attributesArray[indexPath.section] objectAtIndex:indexPath.item];
    
    /*
    UICollectionViewLayoutAttributes *attributs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
//    NSNumber *currentWidthNumber = self.widthArray[indexPath.row];
//    CGFloat width = currentWidthNumber.floatValue;
    
    NSValue *theSizeValue =[self.widthArray[indexPath.section] objectAtIndex:indexPath.item];
    CGSize theSize = [theSizeValue CGSizeValue];
    CGFloat width = theSize.width ;
    
    ///没有换行所以超出部分不显示（不写下面的代码也不会报错，不知道为啥）
//    if (width>[UIScreen mainScreen].bounds.size.width-(self.left+self.right)) {
//        width = [UIScreen mainScreen].bounds.size.width - (self.left+self.right);
//    }
    
    CGFloat height = 30;
    CGRect currentFrame = CGRectZero;
    
    if (1) {
        if (self.attributesArray.count!=0) {
            ///1.取出上一个item的attributes
            UICollectionViewLayoutAttributes *lastAttributs = [self.attributesArray lastObject];
            CGRect lastFrame = lastAttributs.frame;
            
            ///判断当前item和上一个item是否在同一个row
            if (CGRectGetMaxX(lastAttributs.frame)+self.right==self.collectionView.bounds.size.width) {
                ///不在同一row
                currentFrame.origin.x = self.left;
                currentFrame.origin.y = CGRectGetMaxY(lastFrame) +self.top;
                currentFrame.size.width = width;
                currentFrame.size.height = height;
                attributs.frame = currentFrame;
                
            }else{
                ///上一个item的最大x值+当前item的宽度和左边距
                CGFloat totleWidth = CGRectGetMaxX(lastFrame)+(self.between+width+self.right);
                ///判断上一个item所在row的剩余宽度是否还够显示当前item
                if (totleWidth>=self.collectionView.bounds.size.width) {
                    ///不足以显示当前item的宽度
                    
                    ///将和上一个item在同一个row的item的放在同一个数组
                    NSMutableArray *sameYArray = [NSMutableArray array];
                    for (UICollectionViewLayoutAttributes *subAttributs in self.attributesArray) {
                        if (subAttributs.frame.origin.y==lastFrame.origin.y) {
                            [sameYArray addObject:subAttributs];
                        }+ 
                    }
                    
                    ///判断出上一row还剩下多少宽度
                    CGFloat sameYWidth = 0.0;
                    for (UICollectionViewLayoutAttributes *sameYAttributs in sameYArray) {
                        sameYWidth += sameYAttributs.size.width;
                    }
                    sameYWidth = sameYWidth + (self.left+self.right+(sameYArray.count-1)*self.between);
                    ///上一个row所剩下的宽度
                    CGFloat sameYBetween = (self.collectionView.bounds.size.width-sameYWidth)/sameYArray.count;
                    
                    for (UICollectionViewLayoutAttributes *sameYAttributs in sameYArray) {
                        CGFloat sameAttributeWidth = sameYAttributs.size.width;
                        CGFloat sameAttributeHeight = sameYAttributs.size.height;
                        
                        CGRect sameYAttributsFrame = sameYAttributs.frame;
                        ///更新sameYAttributs宽度使之均衡显示
                        sameAttributeWidth += sameYBetween;
                        sameYAttributs.size = CGSizeMake(sameAttributeWidth, sameAttributeHeight);
                        NSInteger index = [sameYArray indexOfObject:sameYAttributs];
                        
                        sameYAttributsFrame.origin.x += (sameYBetween*index);
                        sameYAttributsFrame.size.width = sameAttributeWidth;
                        sameYAttributs.frame = sameYAttributsFrame;
                    }
                    currentFrame.origin.x = self.left;
                    currentFrame.origin.y = CGRectGetMaxY(lastFrame)+self.top;
                    currentFrame.size.width = width;
                    currentFrame.size.height = height;
                    attributs.frame = currentFrame;
                    
                }else{
                    currentFrame.origin.x = CGRectGetMaxX(lastFrame)+self.between;
                    currentFrame.origin.y = lastFrame.origin.y;
                    currentFrame.size.width = width;
                    currentFrame.size.height = height;
                    attributs.frame = currentFrame;
                }
            }
        }else{
            currentFrame.origin.x = self.left;
            currentFrame.origin.y = self.top+30;
            currentFrame.size.width = width;
            currentFrame.size.height = height;
            attributs.frame = currentFrame;
        }
    }
    
    //    attributs.size = CGSizeMake(width, 30);
    self.maxY = CGRectGetMaxY(attributs.frame)+10;
    
    NSLog(@"%f===%f===%f===%f",attributs.frame.origin.x,attributs.frame.origin.y,attributs.frame.size.width,attributs.frame.size.height);
    
    return attributs;
     */
}

///当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}


/**
 另外，在需要更新layout时，需要给当前layout发送 -invalidateLayout，该消息会立即返回，并且预约在下一个loop的时候刷新当前layout，这一点和UIView的setNeedsLayout方法十分类似。在-invalidateLayout后的下一个collectionView的刷新loop中，又会从prepareLayout开始，依次再调用-collectionViewContentSize和-layoutAttributesForElementsInRect来生成更新后的布局。
 */


/*
-(void)loadOldAttributes:(CGRect)lastFrame{
    ///将和上一个item在同一个row的item的放在同一个数组
    NSMutableArray *sameYArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *subAttributs in self.attributesArray) {
        if (subAttributs.frame.origin.y==lastFrame.origin.y) {
            [sameYArray addObject:subAttributs];
        }
    }
    
    ///判断出上一row还剩下多少宽度
    CGFloat sameYWidth = 0.0;
    for (UICollectionViewLayoutAttributes *sameYAttributs in sameYArray) {
        sameYWidth += sameYAttributs.size.width;
    }
    sameYWidth = sameYWidth + (self.left+self.right+(sameYArray.count-1)*self.between);
    ///上一个row所剩下的宽度
    CGFloat sameYBetween = (self.collectionView.bounds.size.width-sameYWidth)/sameYArray.count;
    
    for (UICollectionViewLayoutAttributes *sameYAttributs in sameYArray) {
        CGFloat sameAttributeWidth = sameYAttributs.size.width;
        CGFloat sameAttributeHeight = sameYAttributs.size.height;
        
        CGRect sameYAttributsFrame = sameYAttributs.frame;
        ///更新sameYAttributs宽度使之均衡显示
        sameAttributeWidth += sameYBetween;
        sameYAttributs.size = CGSizeMake(sameAttributeWidth, sameAttributeHeight);
        NSInteger index = [sameYArray indexOfObject:sameYAttributs];
        
        sameYAttributsFrame.origin.x += (sameYBetween*index);
        sameYAttributsFrame.size.width = sameAttributeWidth;
        sameYAttributs.frame = sameYAttributsFrame;
    }
}
*/
-(NSMutableArray*)attributesArray{
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}


@end
