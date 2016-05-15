//
//  SobelFilter.m
//  Milk
//
//  Created by TOO on 13/03/16.
//  Copyright © 2016 Lucian Todorovici. All rights reserved.
//

#import "SobelFilter.h"

#define RED 1
#define GREEN 2
#define BLUE 3

@implementation SobelFilter
{
    size_t width,height;
}

const int gx[3][3] = { { -1, 0, 1 },
                       { -2, 0, 2 },
                       { -1, 0, 1 }};

const int gy[3][3] = { { -1,-2,-1 },
                       {  0, 0, 0 },
                       {  1, 2, 1 }};

-(UIImage*)filteredImageFromImage:(UIImage*)srcImage {
    width = srcImage.size.width;
    height = srcImage.size.height;
    UInt8 **sobelMatrix = [self applySobelFilterOnImagePixels:[self convertImageToPixelData:srcImage]];
    UInt8 *imgData = [self arrayFromMatrix:sobelMatrix];
    CGImageRef cgImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CFDataRef imageData = CFDataCreate(NULL, imgData, width*height);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(imageData);
    cgImage = CGImageCreate(width, height, 8, 8, width, colorSpace, kCGBitmapByteOrderDefault, dataProvider, NULL, 0, kCGRenderingIntentDefault);
    
    return [UIImage imageWithCGImage:cgImage];
}

-(uint32_t *)convertImageToPixelData:(UIImage*)srcImage {
    CGImageRef cgImageRef = srcImage.CGImage;
    
    uint32_t *pixels = (uint32_t *) calloc(width*height,sizeof(uint32_t));

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width*sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImageRef);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[x + y * width];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    CGContextRelease(context);
    return pixels;
}

- (UIImage *)toGrayscale:(UIImage *)img
{
    height = img.size.height;
    width = img.size.width;
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [img CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint8_t gray = (uint8_t) ((30 * rgbaPixel[RED] + 59 * rgbaPixel[GREEN] + 11 * rgbaPixel[BLUE]) / 100);
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:img.scale
                                           orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}


/**
 *  Method that actually applies the sobel filter on the image it receives as parameter
 *
 *  @param pixels - pointer to an array representing the image to be filtered
 *
 *  @return A heap allocated matrix representing the filtered image, with UInt8 elements (typealias char) ; range of values in the array : 0 - 255
 */
-(UInt8 **)applySobelFilterOnImagePixels:(uint32_t *)pixels {
    UInt8 **matrix = [self matrixFromArray:pixels];
    UInt8 **result_matrix = (UInt8**) calloc(height, sizeof(UInt8*));
    
    //copy the borders, for which the algorithm is not applied
    //allocate memory for the first and last rows
    result_matrix[0] = (UInt8*) calloc(width, sizeof(UInt8));
    result_matrix[height-1] = (UInt8*) calloc(width, sizeof(UInt8));

    //copy the contents of the first and last rows
    for(int i=0; i<width ; i++) {
        result_matrix[0][i] = matrix[0][i];
        result_matrix[height-1][i] = matrix[height-1][i];
    }
    
    for(int i=1; i<height -1 ; i++) {
        //allocate memory for the rest of the rows
        result_matrix[i] = (UInt8*) calloc(width, sizeof(UInt8));
        //copy the contents of the first and last columns
        result_matrix[i][0] = matrix[i][0];
        result_matrix[i][width-1] = matrix[i][width-1];
    }
    
    for(int y = 1; y < height - 1; y++) {
        for(int x = 1; x < width - 1; x++){
            int32_t gx_result,gy_result;
            
//            gx_result = matrix[y-1][x-1] * gx[0][0] +
//                        matrix[y-1][x  ] * gx[0][1] +
//                        matrix[y-1][x+1] * gx[0][2] +
//            
//                        matrix[y  ][x-1] * gx[1][0] +
//                        matrix[y  ][x  ] * gx[1][1] +
//                        matrix[y  ][x+1] * gx[1][2] +
//            
//                        matrix[y+1][x-1] * gx[2][0] +
//                        matrix[y+1][x  ] * gx[2][1] +
//                        matrix[y+1][x+1] * gx[2][2] ;
            //perform computations for Ox axis
            gx_result = - matrix[y-1][x-1]
                        - matrix[y-1][x+1]
                        
                        - 2*matrix[y-1][x] +
                          2*matrix[y+1][x] +
                        
                        matrix[y+1][x-1] +
                        matrix[y+1][x+1];
            
            //perform computations for Oy axis
            gy_result = +  matrix[y-1][x-1]
                        +2*matrix[y][x-1] +
                        matrix[y+1][x-1] -
                        
                          matrix[y-1][x+1]-
                        2*matrix[y][x+1] -
                        matrix[y+1][x+1];
//            gy_result = matrix[y-1][x-1] * gy[0][0] +
//                        matrix[y-1][x  ] * gy[0][1] +
//                        matrix[y-1][x+1] * gy[0][2] +
//                        
//                        matrix[y  ][x-1] * gy[1][0] +
//                        matrix[y  ][x  ] * gy[1][1] +
//                        matrix[y  ][x+1] * gy[1][2] +
//                        
//                        matrix[y+1][x-1] * gy[2][0] +
//                        matrix[y+1][x  ] * gy[2][1] +
//                        matrix[y+1][x+1] * gy[2][2] ;

            //compute the magnitude
            double magnitude = (double) abs(gx_result)+abs(gy_result);
            
            //perform a normalization
            if(magnitude>255){
                magnitude = 255;
            }
            
            //the edges will get highlighted in white
            // 0 is black, 255 is white
            result_matrix[y][x] = (UInt8)magnitude;
        }
    }
    return result_matrix;
}

/**
 *  Converts an array into a matrix by using the global variables width and height
 *
 *  @param array the array to be converted is of length width * height
 *
 *  @return A heap allocated matrix representing the array , but with UInt8 elements (typealias char) ; range of values in the array : 0 - 255
 *  
 *  !!! Memory must be freed !!!
 */
-(UInt8 **)matrixFromArray:(uint32_t *)array {
    UInt8 **matrix = (UInt8 **) calloc(height, sizeof(UInt8 *));
    
    for (int y = 0; y < height; y++) {
        UInt8 *row = (UInt8 *) calloc(width, sizeof(UInt8));

        for (int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &array[x + y * width];
            row[x] = rgbaPixel[RED];
        }
        matrix[y] = row;
    }
    
    return matrix;
}

/**
 *  Converts a matrix into an aray
 *
 *  @param matrix the matrix to be converted (of height:height and width:width)
 *
 *  @return pointer to heap allocated array
 *
 *  !!! Memory must be freed !!!
 */
-(UInt8 *)arrayFromMatrix:(UInt8 **)matrix {
    UInt8 *arr = (UInt8 *) calloc(width*height, sizeof(UInt8));
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            arr[x + y * width] = matrix[y][x];
        }
    }
    return arr;
}

@end
