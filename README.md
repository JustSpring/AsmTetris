# Two-player Tetris- x86
**16 bits two-player Tetris game in x86 assembly**

* This is a modified version of the classic Tetris game codded in **x86 Assembly**, which features a competitive two-player mode.

* Made by Aviv Friedman 2023 as part of a final project of the year at school.

## Screenshots
### Start Images
![AvStart](https://github.com/JustSpring/AsmTetris/assets/87150546/a97066fb-26e8-44ae-a27c-5baacd60909d)
![AvKeys](https://github.com/JustSpring/AsmTetris/assets/87150546/bf7321fd-30f1-4b80-90d7-2ad635c25d58)
### Midgame
![tetris_gameplay](https://github.com/JustSpring/AsmTetris/assets/87150546/cac239a4-a145-4ef7-bbbc-47344d0cc5c7)
## Building
To run this project without any changes you don't need to build the **tetris.asm** to **tetris.exe**.


If you want to build the asm file you need to follow the following steps:
1. Download DOSBox from this [link](http://data.cyber.org.il/assembly/dosbox.exe).
2. Download Tasm (Turbo Assembler) from this [link](http://data.cyber.org.il/assembly/TASM.rar) and insert **TASM.EXE** and **TLINK.EXE** to **C:\TASM\BIN**
3. Run the following commands:
```
mount c:  C:\
C:
cd tasm
cd bin
cycles=max
tasm /zi tetris.asm
tlink /v tetris.obj
  ```
## Running
To run this project you will need to insert the **tetris.exe** file into **C:\TASM\BIN**.
Run the following commands in [DOSBox](http://data.cyber.org.il/assembly/dosbox.exe):
```
mount c:  C:\
C:
cd tasm
cd bin
cycles=max
tetris
  ```
* To turn the game into full screen press **ALT+ENTER**.

## Game rules
### Keyboard Keys
* **Right player:** *arrows* to move and *Space* to rotate.
* **Left Player:**  *asd* to move and *R* to rotate.
### Scoring system
The amount of points depends on the number of full rows in one turn
| Action        | Points        |
| ------------- |:-------------:|
| One Row (Single)| 100 points |
| Two Rows (Double)      | 300 points      |
| Three Rows (Triple) | 500 points      |
| Four Rows (Tetris) | 800 points      |
### Speed
* The speed is presented at the top of the screen and increases every 50 seconds.
* The speed ranges from 1-5. After 4:10 minutes the speed reaches the highest level.
### Winning
* The player with the most points wins after both players reach the top of their grid.
