# Measure your motorcycle torque with your phone
Have you ever heard that we have in our pockets a tool for making whatever we want? Well… yes, this is true.

With this code you can obtain your motorcycle´s torque, speed and traveled distance using the [PhyPhox app](https://phyphox.org/) in your phone (Don´t worry, it´s available in Android and iOS). It should work too with other similar apps or using an Arduino with an accelerometer.

You can do all this running the MotorcycleTestBench.m file in Matlab (We did it in that way) or if you are more an open source user I am almost sure that you can use [GNU Octave]( https://www.gnu.org/software/octave/download) with the same results.

Here are some graphs obtained:

![](https://raw.githubusercontent.com/spinedaospina/measuring-motorcycle-torque-with-phone/main/images/distance.png)  | ![](https://raw.githubusercontent.com/spinedaospina/measuring-motorcycle-torque-with-phone/main/images/velocidad.png)
------------- | -------------
a) Distance v.s. time.  | b) Speed v.s. time.
![](https://raw.githubusercontent.com/spinedaospina/measuring-motorcycle-torque-with-phone/main/images/momentos.png)  | C![](https://raw.githubusercontent.com/spinedaospina/measuring-motorcycle-torque-with-phone/main/images/rpm.png)
c) Torque v.s. time (2nd. And 3rd. method are the recommended).  | d) RPMs v.s. time. The RPMs function have some issues and need to be improved for it uses.


### Repository organization

In this repo you can find 5 files listed below:
+ **LICENSE,** this project is shared under MIT license agreement. If you need more information read this file or [click here.]( https://choosealicense.com/licenses/mit/)

+ **README.md,** you are reading this now, so “Hello, I’m the readme file”.

+ **MotorcycleTestBench.m,** here is all the code that we build. You can find there all the equations used and this is the file that you have to run if you want to get some cool graphs. This is the result of our work, if you need detailed info continue reading.

+ **Aceleración con frenado trasero.xls,** this file contains all the data that PhyPhox app recollected during the test.

+ **Trabajo final.pdf,** the analysis, information, test and all our work is documented here. If you are really interested in this topic maybe this document is from your interest. Oh, it is writing in Spanish, but we are in 2020, google translate works very well.


### Some inconvenients

Theoretically you can obtain the RPM from your motor with this code, but for an unknown reason it is showing incongruent results (Maybe we forgot something important). If you find something wrong, please make a pull request suggestion.

Furthermore, we tried to measure the sound level from the exhaust gases and tried to characterize the suspension from the motorcycle. This last thing was proved experimentally that could not be possibly, due to the phone limitations. For more information about that read the “Trabajo final.pdf” file.

And one more thing, all the values obtained are ideal because we didn´t take count of all the loses presented like forces against the driver and the motorcycle (air and other friction forces), transmission loses, etc. If you want to go deeper, this could be a nice project continuation. 

Remember, we plant the seed but (if you want of course) is your responsibility develop a big plant from this, a long but exciting way is in front of you. Whatever you want could be done if you really fight and perseverate about it.

Now, if you read all this please feel free to contact me to my email sepinedaos@unal.edu.co. I will be very happy if this can help at least one person.