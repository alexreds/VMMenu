# VMMenu

A menu system vector games running on a real vector monitor for DOS Mame with a ZVG card

 - Requires iniparser from Nicolas Devillard, at https://github.com/ndevilla/iniparser
 - Requires the ZVG DOS SDK
 - Requires a DJGPP compile environment under DOS, I used the same version as used for DOS MAME circa .104

You can find a walk-through of setting up such an environment here: http://mamedev.emulab.it/haze/reallyoldstuff/compile036dos.html

I'm no C coder, please be gentle. This was my first attempt at C, I'm sure my code is far from optimal and inefficient in places.
As you've probably gathered, I'm also new to Git so please be patient whilst I get to grips with things and get the files more orderly to aid compilation. 

I've included a make file and sample compile batch file, but you will need to edit the paths in these to reflect your own environment. I originally edited and compiled the files within a Windows XP environment, later I created a Linux port with common source and edit on Linux, moving to an XP Virtualbox PC which grabbed the source from the Linux host and compiled for DOS under the XP machine. The compile.bat file will reflect this environment. You could probably set up cross compiling for a simpler setup.

The Linux port has the advantage of being able to mirror the vector screen to the PC monitor, this greatly aids with development as you can test code without needing the ZVG or a vector monitor attached, and see what the colours will look like should you only have a B&W monitor. I originally developed using a vectrex as a monitor as I didn't have access to my cabs at the time, so the original colour work was done "blind".

In the Utils folder you can find some utilities:

 - **Makeini** can be used to generate a template ini file for VMMenu. It will query your version of Mame and generate an entry for each vector game it finds.
 - **BiosKey** can be used to display the keycode of a pressed key under DOS. Use this if you are customising the keyboard inputs

Vector Mame Menu will build a list of games from your vmmenu.ini file and group them by manufacturer. The vmmenu.ini file is just a plain text file so you can edit it to change the grouping of games, remove games etc.

## Building on Linux:

- Download and unzip the VMMenu files
- Download the iniparser files from https://github.com/ndevilla/iniparser
- Download the Linux ZVG SDK files from https://github.com/rhew/zvg-linux

- Copy the dictionary and iniparser .h and .c files into the VMMenu/iniparser directory
- Copy the ZVG files from the inc and shared folders into the VMMenu/Linux/zvg directory

You will need the SDLLib1.2-dev and -gfx files:

`sudo apt install libsdl1.2-dev libsdl-gfx1.2-dev`

Copy the makefile from the VMMenu/Linux directory to VMMenu

Then run:

`make`

which will create the vmmenu file in the current directory

Optionally you can install upx and use the compile.sh script in the VMMenu/Linux directory to compile and compress the resulting vmmenu file.

This works even on a raspberry pi, obviously you won't be able to hook up a ZVG board... but you can develop and test the code and simulate how it will look on a vector monitor.


## Building on DOS

You will need a working DJGPP environment to compile VMMenu for DOS. There are many tutorials online for this.

- Download and unzip the VMMenu files
- Download the iniparser files from https://github.com/ndevilla/iniparser
- Download the DOS ZVG SDK files

- Copy the dictionary and iniparser .h and .c files into the VMMenu/iniparser directory
- Copy the ZVG files from the inc and shared folders into the VMMenu/DOS/zvg directory

Copy the makefile from the VMMenu/DOS directory to VMMenu

Then run:

`make`

which will create the vmmenu.exe file in the current directory

Optionally you can install upx and use the compile.bat script in the VMMenu/DOS directory to compile and compress the resulting vmmenu.exe file. Note that this batch file will first attempt to copy the source files to the current location before compilation, this is because I tended to house the source on a Linux PC and compile from an XP virtual machine. You may with to edit out the file copy commands if you are working directly under XP/DOS.

## Launching VMMenu (DOS)

VMMenu should be launched toward the end of your AUTOEXEC.BAT file, after you have initialised your sound card and any other devices such as mice. Here is an example AUTOEXEC file:

```
@echo off
SET PATH=C:\;C:\DOS;C:\drivers\sbpci\DOSDRV
lh C:\DOS\dosed >NUL
lh C:\DOS\ansi.com >NUL
prompt $p$g

lh C:\mouse\bin\CTMOUSE.EXE
SET ZVGPORT=P378 D3 I7 M4

SET SBPCI=C:\DOSDRV
SET BLASTER=A220 I5 D1 H7 P330 T6
SBLOAD
SBINIT

SMARTDRV /x
cd \vmame
vmmenu

:: switch off when done
shutdown -s 5
```

When VMMenu is quit, the AUTOEXEC.BAT file will continue from the next line, in this example it will run the shutdown command and turn off the PC.

## The vmmenu.cfg file

When first run, VMMenu will create a vmmenu.cfg file with various default settings for the colours, controls and menu options. There are 4 sections to the file:
- [interface], customises how the menu behaves
- [controls], this is for mouse/spinner options
- [keys], defines which keys are bound to which menu functions
- [colours], defines the colours and intensities of various elements on screen

[interface]

Most of the interface options can be set via the in game settings menu, which by default is accessed by pressing the backtick ` key, usually found below the escape key. Tip: It can be useful to bind this function to the test or service switch in your cabinet!

One interface option worthy of some explanation is "smartmenu". This allows you to control the menu in a more intuitive manner using a joystick, with direct navigation in the up, down, left and right directions. As not all vector cabs have a joystick (e.g. Asteroids), this option defaults to `off` and menu navigation is setup to use the rotation keys, with Hyperspace toggling between the games list and manufacturer list. If switching this option `on`, remember you will also need to specify the keys used to navigate between manufacturers, games and clones. If you switch smartmenu `on` without specifying suitable keys, the option will be switched off again as you would not be able to control the menu correctly. 

[controls]

This section will be populated by the in game settings menu, which allows you to set up a mouse or spinner and change/swap the axes, alter the sample rate etc.

[keys]

This section binds the controls to your preferred key presses. For DOS users, you can use the supplied keycode.exe to display the keycode of a key pressed. Simply change the value against the desired function. The default values and the keycodes for both Linux and DOS are listed in the vmmstddef.h file

[colours]

Here is where you can define the colours and intensities of various elements of the menu. Colour values are prefixed with `c_` and intensities with `i_`
Valid colour values are red, magenta, cyan, blue, yellow, green and white. Intensity values range from 0 to 25, dimmest to brightest.

## The vmmenu.ini file

VMMenu creates the game list by reading the vmmenu.ini file. This file contains a list of all the vector games supported by your version of Mame and contains information such as the manufacturer, the name of the game, the "Mame" name for the game and the name of the parent game if it is a clone of another game. The fileis just a text file in the following format:

```bash
Manufacturer name|Display name|name of parent game|name of game
```

There are 4 fields, delimited by the | character:

The Manufacturer name is used to group the games together on separate pages of the menu
The Display name is what is shown on screen
The name of parent game is used to group clones of the same game together
The name of the game is what gets passed back to DOS and on to mame when running a game

For example:

```bash
Atari|Asteroids (rev 2)|asteroid|asteroid
Atari|Asteroids (rev 1)|asteroid|asteroi1
Other|Asterock|asteroid|asterock
Other|Meteorites|asteroid|meteorts
```

As the file is plain text, you are free to customise it to your taste. For example, in the example above there are 2 clones of Asteroids by "Other" manufaturers, and these will appear on a separate page to the Atari versions of Asteroids. Should you wish to bundle all the Asteroids variants together under Atari, simply edit the manufacturer field for these 2 games, changing "Other" to "Atari":

```bash
Atari|Asteroids (rev 2)|asteroid|asteroid
Atari|Asteroids (rev 1)|asteroid|asteroi1
Atari|Asterock|asteroid|asterock
Atari|Meteorites|asteroid|meteorts
```

When you next start the menu, it will group all of these titles together under Atari -> Asteroids.

If you wish to remove a game from the menu, perhaps if the controls are not suitable or it does not work correctly, then you can either delete the line in question, or comment it out by placing a # character in the first column.

This would remove "Asteroids (rev 1)" from the menu but retain the other 3 games:

```bash
Atari|Asteroids (rev 2)|asteroid|asteroid
#Atari|Asteroids (rev 1)|asteroid|asteroi1
Atari|Asterock|asteroid|asterock
Atari|Meteorites|asteroid|meteorts
```

You can also edit the display name if you wish, but do not alter the clone name or parent game name or the game may not run.

## The VMM.BAT file

When a game is selected from the menu, the name of the game gets passed to the file VMM.BAT for processing. This allows us to perform some customisation if necessary, which would not be possible if the menu launched  mame directly.

Examples of such customisation are:
- Rotating the display for certain games
- Selecting a different version of MAME for certain games
- Selecting different MAME options for certain games

If you look at the example VMM.BAT file provided, you will see that the display is rotated when running Barrier, Sundance and Tacscan:

```
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Process the selected game and run the appropriate exe::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if %1 == barrier  goto flipxy
if %1 == sundance goto flipxy
if %1 == tacscan  goto flipxy
::if %1 == bwidow goto fskip2
 
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::             Default is to use Mame 0.104             ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
cd mame104
dvm104.exe %1 -zvg 3
cd ..
goto end

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::  Flip X and Y axes for barrier,sundance and tacscan  ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:flipxy
cd mame104
dvm104.exe %1 -zvg 3 -flipx -flipy
cd ..
goto end

:end
```

%1 represents the game name as passed from the menu to VMM.BAT. We test if this matches "barrier", "sundance" or "tacscan" and jump to the flipxy section if necessary, else mame is run with standard or default settings, as specified in the mame.ini file.



 
I'll flesh this document out with more detail in due course.
