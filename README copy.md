# 4611 Assignment1
```
  Name: Clara Huang
  UserId: huan2089
```
## Main design decisions

  1. For creating the debugger view of the video, I define a new PImage named  debuggerImage. I set it up in the same way as in the sample code that how to set up the InputImage. Then I create a function called debugger to go through every pixel in the image and update each of them to black or white.
  Comparing to the debuggerview, the normal view in my code is called finalImage.<br>
  2. To grayscale the video, I implement a function called grayscale. It extracts every pixel's red, green and blue part and make its color equals to the average of these three colors.
  3. To make space key work for switching between debugger view and normal view, I use a global variable called spacecount to calculate whether we press space key even number times or odd number times. If it is even number, then set normal view, if it is odd number, then set debuggerview.
  4. The way I design to hold text rains and make them move following my movement is in function debuggerRains and finalRains. The first one is for debugger mode and the second is for normal mode. The main logic is go through every letter in the text message I define, then everytime one letter drop one pixel, it will be tested whether any pixels on the bottom of this letter attach to any pixels darker than threshold or not. If it is, I use a while loop to help it find a nearest pixel lighter than threshold. This makes sure the text rise when hands rise.
  5. The way I vary different letter's speed and color is by assigning random values to each element in two arrays that store each letter's color and speed. I define these two arrays in setup() function.
  6. For achieve a psedo-random letter dropping so that we can catch words, I set up my algorithm in setup() when I try assigning initial value to evry letter's x value. So my logic is to extract each word from the text and make the x value of its first letter to a random varaible that enougn far away from its previous word's first letter. Here, I use a variable m to track each word's first letter and update it everytime go through a new word. For other letters in each word, every of them has a little distance from their previous letter(here the distance I set is 15~30)
