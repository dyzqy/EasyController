# EasyController
An assiting tool for making Stick War 2 & Stick Empires Engine levels easier and less of a hassle. It has many features that assist the creator of said level, but do not directly "replace" the exisisting code. This tool i strictly for assisting, while having the users keep a **DIY(do-it-yourself)** attitude.
> *Note: Some thoughts about changing name to Stick War 2 Modding Utilities(AKA SMU)*
## What are templates?
Templates are *ready to go* controller classes that use a specific part of a class to showcase the usage of EasyController and its functions to help learners understand the easy concept.


## How to install
### Installer
> *Note: The downloaded EasyController_Installer.zip might be of a pre-release, so it might contain some issues.*

Install the zip file called [`EasyController_Installer.zip`](https://github.com/dyzqy/EasyController/releases/download/1.2.0/EasyController_Installer.zip) and extract it, inside the given folder there should be a .bat file called `install`, Drag the SWF file on top it, and it will make a copy of the SWF with _-EC_, and it should be installed on your SWF now.
### Manual Install
> *Note: It is suggested that you use a version of FFDEC lower than 19.0.0 to avoid any possible errors.*
Download the *CampaignController.as* file linked below, and enter the SWF with your application, after doing so, go to the `CampaignController` class inside `com.brockw.stickwar.campaign.controllers`, click edit and delete everything inside it.

After doing so, do not save yet; Open the file you downloaded(_CampaignController.as_) and **copy everything**, after copying everything, return back to your application and **paste the text**. After doing that, click save. Good Job! Now you should have `EasyController` installed inside your mod!

### Warning!
After having downloaded the package, the class `CampaignController` will no longer be editable! Editing it will result in the game crashing, so beware of doing so. The same applies to the EasyController classes, a fix will be worked on soon to fix this problem.
