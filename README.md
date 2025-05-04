A script for every Paradox game with the Clausewitz Engine to use mods that are only available in English for the German version without errors occurring in the game.

Move the bat file and ps1 file to the appropriate mod folder. For Crusaders Kings 3 on Steam, for example, it is ‘SteamLibrary\steamapps\workshop\content\1158310’.

Run the bat.

The script then works by itself and goes through folder by folder and checks whether there is a folder ‘german’. If so, it will rename all files ending with ‘_l_english.yml’ to ‘_l_german.yml’ and replace “english” with ‘german’ within the file.

If no folder ‘geman’ exists, it will create one and copy all files from ‘english’ into it and then proceed as described above.
