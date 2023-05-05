@echo off
setlocal enabledelayedexpansion

:start
cls
echo Welcome to Zyro, a mystical land filled with danger and adventure!
echo.
echo In this game, you will travel to different locations and fight enemies to become the strongest hero in all of Zyro.
echo Press 1 to start a new game.
echo Press 2 to quit.
choice /c 12 /n /m "Enter your choice: "
if errorlevel 2 goto :eof
if errorlevel 1 goto character_creation
:character_creation
echo First, let's create your character.
echo What is your character's name?
set /p name=Name: 
echo Great, your character's name is !name!.
echo Now choose your starting equipment:
echo 1. Sword and armor
echo 2. Crossbow and armor
choice /c 12 /n /m "Enter your choice: "
if errorlevel 2 set sword=0 & set armor=1 & set crossbow=1 & set attack=8 & set defense=7 & set health=100
if errorlevel 1 set sword=1 & set armor=1 & set crossbow=0 & set attack=9 & set defense=6 & set health=100
echo You have equipped a !sword! sword, !armor! armor, and !crossbow! crossbow.
call :show_stats
echo Press any key to continue.
pause >nul
goto main_loop
:main_loop
rem Added a check for game over condition
if !health! leq 0 goto game_over
rem Added a random chance for healing potion to appear
set /a potion=!random! %% 10 + 1
if !potion! leq 2 (
    echo You found a healing potion!
    echo It restores 20 health points.
    echo Do you want to use it?
    echo.
    echo Press Y to use it.
    echo Press N to save it for later.
    choice /c yn /n /m "Enter your choice: "
    if errorlevel 2 goto skip_potion
    if errorlevel 1 (
        set /a health+=20
        if !health! gtr 100 set health=100
        echo You used the healing potion and restored your health to !health!.
        echo Press any key to continue.
        pause >nul
    )
)
:skip_potion
rem Added a random chance for treasure chest to appear
set /a chest=!random! %% 10 + 1
if !chest! leq 2 (
    echo You found a treasure chest!
    echo It contains a random item that can boost your stats.
    echo Do you want to open it?
    echo Press Y to open it.
    echo Press N to leave it alone.
    choice /c yn /n /m "Enter your choice: "
    if errorlevel 2 goto skip_chest
        rem Added a random item generator
        set /a item=!random! %% 3 + 1
        if "!item!"=="1" (
            echo You opened the chest and found a steel sword!
            echo It increases your attack by 2 points.
            set sword=1
            set /a attack+=2
        )
        if "!item!"=="2" (
            echo You opened the chest and found a leather armor!
            echo It increases your defense by 2 points.
            set armor=1
            set /a defense+=2
        )
        if "!item!"=="3" (
            echo You opened the chest and found nothing!
            echo It was a trap!
            rem Added a random damage generator 
            set /a damage=(%random%%%((attack-defense)+(defense+1))) 
            rem Prevent negative damage 
            if !damage! leq 0 ( 
                rem Prevent negative damage 
                set damage=0 
                ) 
                rem Prevent zero damage 
                if !damage! equ 0 ( 
                    rem Added a minimum damage of one point 
                    set damage=1 
                    ) 
                    rem Subtract damage from health 
                    set /a health-=damage 
                    rem Display damage message 
                    echo The chest exploded and dealt !damage! damage to you! 
        )
        rem Display updated stats after opening the chest 
        call :show_stats 
        echo Press any key to continue. 
        pause >nul 
)
:skip_chest 
rem Display current location options 
cls 
echo !name!, where do you want to go? 
echo. 
echo 1. Forest 
echo 2. Cave  
choice /c 12 /n /m "Enter your choice: "  
if errorlevel 2 call :cave  
if errorlevel 1 call :forest  
goto main_loop  

:forest  
rem Added a random enemy generator for forest location  
set /a enemy=%random% %% 3 + 1  
rem Display enemy name based on number   
set enemy_name=wolf   
if "!enemy!"=="2" (   
set enemy_name=bear   
)   
if "!enemy!"=="3" (   
set enemy_name=hunter   
)   
rem Display enemy encounter message   
echo You have entered the forest.   
echo A wild !enemy_name! appears!   
call :battle   
goto :eof   

:cave    
rem Added a random enemy generator for cave location    
set /a enemy=%random% %% 3 + 1    
rem Display enemy name based on number     
set enemy_name=bats     
if "!enemy!"=="2" (     
set enemy_name=goblin     
)     
if "!enemy!"=="3" (     
set enemy_name=zombie     
)     
rem Display enemy encounter message     
echo You have entered the cave.     
echo A horde of !enemy_name! surrounds you!     
call :battle     
goto :eof     

:battle     
rem Simulate a fight between the user and the enemy using random damage calculations and stat comparisons     
rem The battle ends when either the user or the enemy's health reaches zero     
rem The user can also run away from the battle with a penalty of losing half of their health     
rem Initialize battle variables     
set user_health=!health!     
set user_attack=!attack!     
set user_defense=!defense!     
set user_damage=0     
set user_action=""     
set user_run=false     
set user_win=false     

rem Generate random stats for the enemy based on their type    
if "!enemy!"=="sword" (    
set enemy_health=(%random%%%30)+70    
set enemy_attack=(%random%%%5)+8    
set enemy_defense=(%random%%%5)+6    
)    

if "!enemy!"=="armor" (    
set enemy_health=(%random%%%30)+80    
set enemy_attack=(%random%%%5)+7    
set enemy_defense=(%random%%%5)+7    
)    

if "!enemy!"=="crossbow" (    
set enemy_health=(%random%%%30)+60    
set enemy_attack=(%random%%%5)+9    
set enemy_defense=(%random%%%5)+5    
)    

set enemy_damage=
set enemy_action=""
set enemy_run=false
set enemy_win=false

:battle_loop
rem Display battle status
cls
echo You are fighting a !enemy_name!.
echo Your health: !user_health!
echo Enemy health: !enemy_health!
echo.
rem Ask the user for their action
echo What do you want to do?
echo 1. Attack
echo 2. Run away
choice /c 12 /n /m "Enter your choice: "
if errorlevel 2 set user_action=run
if errorlevel 1 set user_action=attack

rem Perform the user's action
if "!user_action!"=="attack" (
    rem Generate random damage based on user's attack and enemy's defense
    set /a user_damage=(%random%%%((user_attack-enemy_defense)+(enemy_defense+1)))
    rem Prevent negative damage
    if !user_damage! leq 0 (
        set user_damage=0
    )
    rem Prevent zero damage
    if !user_damage! equ 0 (
        rem Added a minimum damage of one point 
        set user_damage=1 
     ) 
     rem Subtract damage from enemy's health 
     set /a enemy_health-=user_damage 
     rem Display attack message 
     echo You attacked the !enemy_name! and dealt !user_damage! damage! 
) 
 
if "!user_action!"=="run" ( 
     rem Set the user's run flag to true 
     set user_run=true 
     rem Display run message 
     echo You ran away from the !enemy_name!. 
) 
 
rem Check for battle end conditions 
if !enemy_health! leq 0 ( 
     rem The user has won the battle 
     set user_win=true 
     goto battle_end 
) 
 
if !user_run! equ true ( 
     rem The user has escaped the battle with a penalty of losing half of their health 
     set /a user_health/=2 
     goto battle_end 
) 
 
rem Generate random action for the enemy based on their type and health
set /a enemy_action=%random% %% 10 + 1

if "!enemy!"=="sword" (
    rem Sword enemy has a 70% chance to attack and a 30% chance to run away if their health is below 30%
    if !enemy_health! lss 30 (
        if !enemy_action! leq 7 (
            set enemy_action=attack
        )
        if !enemy_action! gtr 7 (
            set enemy_action=run
        )
    ) else (
        set enemy_action=attack
    )
)

if "!enemy!"=="armor" (
    rem Armor enemy has a 80% chance to attack and a 20% chance to run away if their health is below 20%
    if !enemy_health! lss 20 (
        if !enemy_action! leq 8 (
            set enemy_action=attack
        )
        if !enemy_action! gtr 8 (
            set enemy_action=run
        )
    ) else (
        set enemy_action=attack
    )
)

if "!enemy!"=="crossbow" (
    rem Crossbow enemy has a 60% chance to attack and a 40% chance to run away if their health is below 40%
    if !enemy_health! lss 40 (
        if !enemy_action! leq 6 (
            set enemy_action=attack
        )
        if !enemy_action! gtr 6 (
            set enemy_action=run
        )
    ) else (
        set enemy_action=attack
    )
)

rem Perform the enemy's action
if "!enemy_action!"=="attack" (
    rem Generate random damage based on enemy's attack and user's defense
    set /a enemy_damage=(%random%%%((enemy_attack-user_defense)+(user_defense+1)))
    rem Prevent negative damage
    if !enemy_damage! leq 0 (
        set enemy_damage=0
    )
    rem Prevent zero damage
    if !enemy_damage! equ 0 (
        rem Added a minimum damage of one point 
        set enemy_damage=1 
     ) 
     rem Subtract damage from user's health 
     set /a user_health-=enemy_damage 
     rem Display attack message 
     echo The !enemy_name! attacked you and dealt !enemy_damage! damage! 
) 
 
if "!enemy_action!"=="run" ( 
     rem Set the enemy's run flag to true 
     set enemy_run=true 
     rem Display run message 
     echo The !enemy_name! ran away from you. 
) 
 
rem Check for battle end conditions 
if !user_health! leq 0 ( 
     rem The enemy has won the battle 
     set enemy_win=true 
     goto battle_end 
) 
 
if !enemy_run! equ true ( 
     rem The enemy has escaped the battle with no penalty 
     goto battle_end 
) 
 
rem Repeat the battle loop until one of the end conditions is met 
goto battle_loop 
 
:battle_end 
rem Display battle result message based on who won or escaped 
if !user_win! equ true ( 
     echo You have defeated the !enemy_name!. 
) 
 
if !user_run! equ true ( 
     echo You have lost half of your health. 
) 
 
if !enemy_win! equ true ( 
     echo You have been killed by the !enemy_name!. 
) 
 
if !enemy_run! equ true ( 
     echo You have spared the !enemy_name!. 
) 
 
rem Update the user's stats after the battle  
set health=!user_health!  
set attack=!user_attack!  
set defense=!user_defense!  
rem Display updated stats after the battle  
call :show_stats  
echo Press any key to continue.  
pause >nul  
goto :eof  

:show_stats  
rem Display the user's stats in a formatted way  
echo Your stats are:  
echo Attack:   !attack!  
echo Defense:  !defense!  
echo Health:   !health!/100  
goto :eof  

:game_over  
echo Game over!  
echo You have failed to become the strongest hero in Zyro.  
goto :eof  


