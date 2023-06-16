## **Sourcen**
- https://www.wikigain.com/10-ways-to-increase-laptop-battery-life-in-windows-10/
- https://www.makeuseof.com/tag/save-energy-extend-battery-life-custom-windows-power-plans/
- https://www.ctrl.blog/entry/laptop-boost-mode-battery.html
- http://www.rawinfopages.com/tips/2017/05/dig-deep-into-windows-power-settings-to-extend-laptop-battery-life/
- https://community.frame.work/t/power-optimizations-under-windows-lower-temps-longer-battery-life/19505
- https://geekflare.com/windows-power-options/


- https://www.thewindowsclub.com/configure-hidden-power-options-in-windows-10
- https://www.auslogics.com/en/articles/make-sense-of-advanced-power-settings/


## **Power Plans**

Windows 10 includes three default power plan options:

Balanced: Windows 10 balances your system performance with energy consumption in relation to your system hardware. This means your CPU speed will increase as required and reduce when not.

Power Saver: Windows 10 reduces your system performance to save battery power. Your CPU will run at lower speeds as much as possible, while other power savings come from reduced brightness, switching the screen off quicker, switching your hard drive or Wi-Fi adapter into power saving mode, and so on.

High Performance: Windows 10 cranks the performance dial up but increases power consumption. Your CPU will run at faster speeds most of the time, your screen brightness will increase, and other hardware components will not enter power-saving mode during periods of inactivity.

You can right-click the battery icon and select Power Options to open the power plan Control Panel Power Options or use the shortcuts in the previous section.

**Creating a Custom Power Plan to Save Battery Life and Reduce Power Consumption**
Sometimes, none of the default power plans suit your requirements. You might use a laptop with a portable battery and want to extend both devices' battery life. In that instance, you can customize a power plan to suit you.

To create a custom power plan, select Create a power plan from the Control Panel Power Options menu, on the left of the window. Give your power plan a name and select the existing plan you want to base your plan upon.

When you create a custom power plan on Windows 10, there are a few settings for you to consider.

#**1. Turn Off the Display and Put the Computer to Sleep**
The first two settings are the easiest to tweak. How long do you want your display to remain idle before switching off, and how long should the computer idle before switching to sleep mode?

On portable devices, Windows 10 provides an option for On battery and Plugged in. You might have to play around with timings to find your sweet spot. If extending your custom power plan is all about power saving and battery life preservation, set the numbers as low as possible.

**Display Brightness**
Wondering where the display brightness toggle setting is? Microsoft removed the option to set display brightness (as well as adaptive brightness) through your power plan in Windows 10 update 1809. The move is infuriating, as the display brightness option was another handy power saving factor you could customize.

You can still change how bright your display is without the toggle. Tap the Notification icon on the bottom right of your screen to open the Action Center. At the bottom of the panel is an adjustable brightness slider.

![image](https://user-images.githubusercontent.com/49591978/211345346-ffeb8448-1996-4a27-bdc7-4fd41abd123e.png)

![image](https://user-images.githubusercontent.com/49591978/211343312-6dba2085-ee00-4fb6-ab65-fc6eaccc2405.png)

Don't discount the power savings an even slightly dimmed monitor will deliver. Power savings vary between monitors, but according to this tip from Harvard Law School's Energy Manager, reducing your computer monitor brightness from 100-percent down to 70-percent can "save up to 20% of the energy the monitor uses." You might not notice that 30-percent brightness reduction too much, but you'll note the extra battery power!

#**2. Advanced Sleep Settings**
The sleep timer in the basic settings isn't the only adjustable option. The Windows 10 power plan advanced settings hide a host of customizable options. Select Change advanced power settings to open the advanced menu.

You'll find three additional sleep options; Sleep after, Allow hybrid sleep, and Hibernate after. Hybrid sleep attempts to combine the sleep and hibernate mode into a single mode and is intended for desktops, so ignore that for now.

You can switch out the option to put the computer to sleep with hibernate using a combination of the "Sleep after" and "Hibernate after" options. If you set the sleep timers to Never, and set a time for the hibernate timers, your computer will hibernate instead of sleep after a certain period.

The best option for maximum battery preservation is a combination of the two. Allow your computer to enter hibernation mode after a certain period, rather than keeping it exclusively in sleep mode (which uses more overall power).

You can switch out the option to put the computer to sleep with hibernate using a combination of the "Sleep after" and "Hibernate after" options. If you set the sleep timers to Never, and set a time for the hibernate timers, your computer will hibernate instead of sleep after a certain period.

**What Is Hibernate?**
Hibernate dumps your system RAM to your hard drive and then shuts down your computer, which drastically cuts (but does not completely eliminate) power draw. Furthermore, your computer's state saves to your hard disk, so you don't run the risk of losing data when the battery gives out (a common problem with sleep).

Restoring from hibernation takes longer than the effortless sleep restoration, so that's another consideration.

## **3. Processor Power Management**
Display brightness helps reduce power use and increase battery life. But it isn't the only thing affecting power consumption on your custom power plan. The amount of power your CPU uses depends on how you use it. Running a demanding program (or multiple programs) can cause your power draw to increase drastically, regardless of the power plan you use.

The Processor power management option controls your CPU output, providing a percentage amount for the minimum and maximum state.

If your maximum state is set to 100-percent, your CPU will use its full capacity when required. Whereas, if you set the maximum state to 50-percent, your CPU will use less capacity (though not exactly half as the percentage amount implies). That is to say, if you have a 2.0GHz processor and set the maximum processor state to 10-percent, your laptop won't use just 200MHz of its potential.

The processor power management option is somewhat like an underclocking tool, allowing you to use fewer CPU resources. In turn, you'll save some power and battery life.
It isn't a perfect science. You'll have to experiment with the best option for your device along with the applications you regularly run.


## **4. Wireless Adapters and Graphics Settings**
If you're using an Intel system, you'll find an Intel Graphics Settings option in the advanced power plan menu. This option lets you define a default level of graphics for your integrated CPU graphics settings, switching between Balanced, Maximum Battery Life, and Maximum Performance. If you're looking to extend battery life and reduce power consumption, switch to Maximum Battery Life.

Another power-saving option in your custom power plan is Wireless Adapter Settings. Your wireless adapter can periodically power down to save battery life. Changing this setting adjusts the period before the Wi-Fi adapter sleeps. For maximum battery life, switch to Maximum Power Saving.


## ** Diasable Boost Mode**
You can safely disable processor performance boost mode on your device unless you’re a gamer or regularly execute long-lived CPU-bound workloads. (You know who you are.) In other words, disabling boost mode could be beneficial to most people who want to prolong their laptop’s battery life.

Windows comes with built-in power options for disabling boost mode on both Intel and AMD processors.

The boost mode options are not visible by default in Windows’ power settings dialog. I don’t know why these options are hidden by default. Microsoft and Intel probably believes it’s what’s best for most customers, but it would be nice to have the option regardless. You can easily make the boost mode power options visible again, though.

Press the Windows key + X, right-click on either Command Prompt or PowerShell, and choose run as administrator.
Type in the following command (in one line), and press Enter afterward.
powercfg.exe -attributes sub_processor perfboostmode -attrib_hide
After you’ve made the settings visible, you can find the new option in the Advanced Power Options dialog. Here’s how to find that dialog in the depths of Windows’ many different power setting dialogs:

Press the Windows key, type “Edit power plan”, and open the app with the same name.
Click on Change advanced power settings.
Select Processor power management: Processor performance boost mode.
Change the option to Disabled.

![image](https://user-images.githubusercontent.com/49591978/211348689-34e7fe87-4e75-4269-b8d1-8ba76fd4ee03.png)


## **multimedia settings**
Expand the Multimedia settings and then When playing video. On battery, set it to Optimise power settings.

---------------------------------------------------------------------------------------------------------------------------

## **Notebook Konfiguration**

Battery Saver
The easiest way to use internal energy-saving options in Windows 10 is the use of battery saver mode. This mode helps reduce energy consumption by system resources and increases battery life. When the battery percentage comes to 20 per cent, the saver mode will be enabled automatically. And you can also edit the setting manually. Go to Battery Setting> Adjust your manually setting 
![image](https://user-images.githubusercontent.com/49591978/211339995-3342fa57-29ad-495b-8bef-4879c4dccbb9.png)

Decrease Screen Brightness
High screen brightness can consume more battery life. To increase battery life for a long time, adjust the screen brightness in a lower condition. Right-click on Battery option> Adjust screen brightness> put brightness row in a lower condition.

Use Hibernation Mode
At the time of using your laptop, sometimes you may leave your laptop for a few minutes. On that time your laptop may get to sleep mode and use your battery life. When you come back to turn on your laptop, the laptop will be turned on fast and drain more battery life. You can use the Hibernation option instead of sleep mode. This mode uses less battery and helps you to use your laptop for a long time. Go to control panel> power option> change plan setting> Change advanced power setting> Battery> Critical battery action> Hibernate
![image](https://user-images.githubusercontent.com/49591978/211340258-0d226bc5-f44c-48e5-9ff9-5f08587753b7.png)

Disable Bluetooth and Wi-Fi
in time of using your laptop sometimes maybe you don’t need to turn on some options, you can disable all the option which you don’t need that. Like; Bluetooth, Wi-Fi, Map, and other options. Just disable it to save your battery life for a long time.

Disable Animation and Shadow
Windows 10 uses shadows and animation for best performance and to make windows look cool, but if we want to save more battery life, we need to disable all the option due to better battery life. Go to Control panel> System> Advanced system setting> Setting> Adjust for best performance 

Disable Background Apps
Most of the Windows 10 apps run in the background to give you notification or information about new updates. But these apps can also drain your battery life, even if you don’t use them. Here we have a solution for it to disable all apps you don’t need it. Go to Setting> Privacy> Background apps> Disable/enable

Manage Startup Apps
You can disable the unnecessary startup apps to save battery life. Some apps run in a startup even we don’t need it, they can drain more battery life. Disable each in every app you don’t need. Press Ctrl+Shift+Esc > Startup.

