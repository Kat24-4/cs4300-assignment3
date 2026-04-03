# Katherine Tse CS4300 Assignment 3 - WebGPU Intro

## Technical 

For this assignment, I wanted to try and utilize feedback to make a ripple effect that followed the mouse. I utilized gulls to add mouse inputs into the program and I passed in frames to create a time variable. I used a sine wave that calculates the ripple based on distance between the point and the mouse, the frequency given by the user, the speed given by the user, and time. I also added exponential damping that changes based on how far the point is from the center. Lastly, the distortion is created by multiplying (point location minus mouse location) by  the generated wave, amplitude set by the user, and the damping.  I decided to use a perlin noise function as my noise to get a smoother randomization. This noise can be toggled on and off. When on, it is added to the wave and distortion. 

## Aesthetic 

I had two inspirations in mind when doing this project. The first is the idea of water and dropping a rock into a still lake. The way the water ripples is something that I think is so calming and fun to watch and I wanted to recreate this. The second inspiration that I had was the way that some people perceive the world when they are intoxicated. People describe it as being spiny and kind of wrapped. I wanted to see if I could recreate the feeling with the shaders. The code I have allows for both a very wiggly view as well as very solid and precise rings that ripple out from where the mouse is.

## Feedback

As I observed one of my classmates using the program, I heard words like wiggly. They also said that it felt like reflective jello or water. These all really align with what I was going for. They also said that there were times when the program felt like a fish lens camera and I thought that was kind of funny but I could really see that at times. Overall, I think my vision came through pretty good and I was super proud to hear them say that they thought it was really fun to use!

## Additional Notes 

This project uses a perlin noise function from [De Koole Centrale](https://dekoolecentrale.nl/). The specific perlinNoise2D used can be found [here](https://dekoolecentrale.nl/wgsl-fns/perlinNoise2D)!
