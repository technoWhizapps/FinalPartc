#!/bin/bash


# Date 11/11/2018
#Author : Toby Turnbull
# Srchprofiler is a menu based script, which allows the user to use advanced features of the find command.
# The menu has 3 options one is the find subcommands section and the second is a profiler of software currently running on the 
# system option 3 allows the user to exit from the Top level. All other parts of the script must use q/Q to quit up to the main menu where the exit
# can then be obtined.
# declare variables

TOP=/usr/bin/top;
GREP=/bin/grep;
AWK=/usr/bin/awk;
PS=/bin/ps;
CLR=/usr/bin/clear;
FIND=/usr/bin/find;
PARTBA=sysinfo.sh;
PARTBB=sysinfoprocs.sh;

#main menu function for flow of rest of program
function menu {


 $CLR;
  # script  using a menu to perform operstional tasks on the system
trap '' SIGINT;
echo -e "Enter your choice from the Menu:";
echo -e "1: Find a file on the system";
echo -e "2: Search and Profile a running program on the system";
echo -e "3: Get some system info (mem disk);
echo -e "4: Get some info and post processing";
echo -e "5: Exit this Program";

read -r prompt;
#error check the menu options meet expected from input
if [ "$prompt" = "1" ] || [ "$prompt" = "2" ] || [ "$prompt" = "3" ]|| [ "$prompt" = "4" ] || [ "$prompt" = "5" ]
then 
menu_actions "$prompt"
# If they dont match show an error message and rerun menu 
else
  echo "please enter a valid option"
  sleep 2;
  menu;
fi

}
#Profiler program to select the correct program from the list returned

function dopartba {
arga=$1


partba=$($partba "$arga" );
$CLR;
echo "$partba"

echo "Do you wish to return to the main menu now Y/y"
read -r retmenu;
if [ "$retmenu" = "Y" ] || [ "$retmenu" = "y" ]
  then
    menu
  fi

}

function dopartbb {
arga=$1




partbb=$($partbb "$arga" );
$CLR;
echo "$partbb"

echo "Do you wish to return to the main menu now Y/y"
read -r retmenu;
if [ "$retmenu" = "Y" ] || [ "$retmenu" = "y" ]
  then
    menu
  fi

}

function selectprog {

prog=$1
choice=$2
t=0;
for commd in $($PS -ef | awk '{print $8}'| grep "$prog");

   do
     if [ "$choice" -eq $t ]
      then
	echo "you selected Program : $commd"
        toprog "$commd";
     fi

	((t++))
   done
exit 0;
}

#Memory function on process number for the Profiler command options

function pmem { 

PID=$1
prog=$2

    mem=$($PS -p "$PID" -o %mem,cmd);

echo "${mem}" &


cmd=$($TOP -b -n1 | $GREP "PID" | $AWK '{print $2,$3,$4,$5,$6,$7,"","",$10,$11,$12}' );
cmda=$($TOP -b -n1 | $GREP "$prog"  | $AWK '{print $2,$3,$4,$5,$6,$7,"","",$10,$11,$12}');
echo "${cmd}" &
sleep 1;
echo "${cmda}" &
echo "---------------------------" &
#sleep 3;
#menu;
}

function pcpu { 

PID=$1

    cpu=$(ps -p "$PID" -o %cpu,cmd);

echo  "${cpu}" &


cmd=$($TOP -b -n1 | $GREP "PID" | $AWK '{print $2,$3,$4,$5,$6,$7,$8,$9,"",$11,$12}' );
cmda=$($TOP -b -n1 | $GREP "$prog"  | $AWK '{print $2,$3,$4,$5,$6,$7,$8,$9,"",$11,$12}');
echo "${cmd}" &
sleep 1;
echo "${cmda}" &
echo "---------------------------" &

}



function toprog {
  prog=$1
  show=$($PS -ef|$GREP -v $GREP|$GREP -m1 "$prog" | awk '{print $2}');
echo "The Process number of the program is : $show ";

echo " Do you wish to see the CPU or the Memory for the process:";
echo "Enter C/c (cpu) or M/m (memory):"
read -r memcpu;
if [ "$memcpu" = "q" ]||[ "$memcpu" = "Q" ]
  then 
   menu;
fi	   


if [ "$memcpu" = "M" ] || [ "$memcpu" = "m" ]

  then

while true ; 
do
pmem "$show" "$prog" ; 
sleep 1
echo "Enter will exit to menu"
read -n 1 -t 3 && menu
done
fi
if [ "$memcpu" = "C" ] || [ "$memcpu" = "c" ]
  then
echo "Enter will exit to menu"

while true ; 
do
read -n 1 -t 3 && menu
pcpu "$show" "$prog";
sleep 1

done
fi
}


function docustomfindsym {
findpath=$1
what="$2"
whatyp=$3
namobj=$4
depth="$5"
customcmd="$6"


custom=$($FIND -L "$findpath" -maxdepth "$depth" -$what "$whatyp" -name "$namobj" -exec "$customcmd");
$CLR;
echo "Please see your search listed"
echo "$custom"

echo "Do you wish to return to the main menu now Y/y"
read -r retmenu;
if [ "$retmenu" = "Y" ] || [ "$retmenu" = "y" ]
  then
    menu
  fi

}



#Function that will perform the find command from the find section of the menu
function docustomfind {
findpath=$1
what=$2
whatyp=$3
namobj=$4
depth=$5
customcmd=$6


custom=$($FIND "$findpath" -maxdepth "$depth" -"$what" "$whatyp" -name "$namobj" -exec $customcmd);
$CLR;
echo "Please see your search listed"
echo "$custom"

echo "Do you wish to return to the main menu now Y/y"
read -r retmenu;
if [ "$retmenu" = "Y" ] || [ "$retmenu" = "y" ]
  then
    menu
  fi

}


function dofind {
findpath=$1
what="$2"
whatyp=$3
namobj=$4
depth="$5"
action="-$6"


custom=$($FIND "$findpath" -maxdepth "$depth" -"$what" "$whatyp" -name "$namobj" "$action");
$CLR;
echo "The search returned the following"
echo "$custom"


echo "Do you wish to return to the main menu now Y/y"
read -r retmenu;
if [ "$retmenu" = "Y" ] || [ "$retmenu" = "y" ]
  then
    menu
  fi

}

# find function with symbolic links

function dofindsym {
findpath=$1
what="$2"
whatyp=$3
namobj=$4
depth="$5"
action="-$6"


custom=$($FIND -L "$findpath" -maxdepth "$depth" -"$what" "$whatyp" -name "$namobj" "$action");
$CLR;
echo "The search returned the following"
echo "$custom"


echo "Do you wish to return to the main menu now Y/y"
read -r retmenu;
if [ "$retmenu" = "Y" ] || [ "$retmenu" = "y" ]
  then
    menu
  fi

}

#main actions from menu script either do a Find or profile and application running
function menu_actions {

prompt="$1";

if [ "$prompt" -eq "1" ]
   then	
            $CLR;
            echo "Exit at anytime to top level menu with (q or Q )";
            echo -e "Enter the starting directory that you wish to start your find from full paths please (example: /root):"
		read -r findpath;
	        if [ "$findpath" = "q" ]||[ "$findpath" = "Q" ]
		  then 
		   menu;
	        fi	
                #error check whether the Path exists in the system
                if [ ! -d "$findpath" ]
                  then 
               	   echo "No directory found please input again";
                   sleep 1
		   menu_actions 2;
                fi

 	        echo -e "what do you want to search for one of (path,group,type,fstype:):"
		read -r  what;
                
                if [ "$what" = "q" ]||[ "$what" = "Q" ]
		  then 
		   menu;
	        fi	   


		if [ "$what" = "fstype" ]
    	          then
		   read -p  "Please state the type of filesystem: ( ufs, nfs, tmpfs, proc, any filesystem in /etc/mtab will work)" whatype;
                    if [ "$whatype" = "q" ]||[ "$whatype" = "Q" ]
                  then
                   menu;
                fi

		fi
		#confirm the sub options for file Type
		if [ "$what" = "type" ]
		  then
	           read -p  "Please state the type to seacrh for: (one of c character, b block, f file, d directory, n named pipe, l symbolic link, s socket  ): " whatype;
                if [ "$whatype" = "c" ] || [ "$whatype" = "f" ]|| [ "$whatype" = "d" ]|| [ "$whatype" = "b" ]|| [ "$whatype" = "n" ]|| [ "$whatype" = "l" ] ||[ "$whatype" = "s" ] 
                  then 
			 echo " selected type of $whatype" 
	   	  elif [ "$what" = "q" ]||[ "$what" = "Q" ]
                    then
                     menu;
                  else
	             echo "Please enter a valid type redirecting........."
		     sleep 2;
	 	     menu_actions 1

                  fi
	        fi
		if [ "$what" = "group" ]
		  then
		    read -p " What group would be an owner of this file either name or gid will do: " whatype;
                   if [ "$whatype" = "q" ]||[ "$whatype" = "Q" ]
                  then
                   menu;
                fi

		fi
		if [ "$what" = "path" ]
		  then
		    read -p  "enter the path of the file you wish to view: " whatype;
		    if [ "$whatype" = "q" ]||[ "$whatype" = "Q" ]
                     then
                       menu;
                    fi

		fi



	        echo -e "Enter the name of the object you wish to find listed:"
		read -r namobj;
                  if [ "$namobj" = "q" ]||[ "$namobj" = "Q" ]
                    then
                      menu;
                  fi
	 	        echo -e "what directory depth do you require on this 1,2..(20)"
                	read -r depth;

		        if [ "$depth" = "q" ]||[ "$depth" = "Q" ]
                          then
                            menu;
                        fi
		    
                  if [ "$depth" -gt 20 ]
                    then
                      menu;
                  fi
                echo -e "Follow Symbolic links Y/y N/n:"
		read -r symlink;

		  if [ "$symlink" = "q" ]||[ "$symlink" = "Q" ]
                    then
                      menu;
                   fi

	        echo -e "once found what action do you want to take choose-  d/D or delete , p/P or print , p0/P0 or print0 and c/C or custom"
		read -r action;

                  if [ "$action" = "q" ]||[ "$action" = "Q" ]
                    then
                      menu;
                  fi


		if [ "$action" = "custom" ] ||  [ "$action" = "c" ] || [ "$action" = "C" ] 
   	 	  then

		  read  -p "Please enter the exec script function example to list use (ls -lrt {} ) Please use any scripted function that you want : " custcom;

                   if [ "$symlink" = "Y" ] || [ "$symlink" = "y" ] 
		   then

                    docustomfindsym $findpath $what $whatype "$namobj" $depth "$custcom"


	            else
                    docustomfind "$findpath" "$what" "$whatype" "$namobj" "$depth" "$custcom"


                   fi

	   fi
		
		#name of object is sent in quotes to contain any wildcard enties added

		if [ "$action" = "delete" ] ||  [ "$action" = "d" ] || [ "$action" = "D" ] 
	       	  then
                   if [ "$symlink" = "Y" ] || [ "$symlink" = "y" ] 
		   then

		    dofindsym "$findpath" "$what" "$whatype" "$namobj" "$depth" "delete"

	            else
		     dofind "$findpath" "$what" "$whatype" "$namobj" "$depth" "delete"

                   fi
		fi

		if [ "$action" = "print" ] || [ "$action" = "p" ] || [ "$action" = "P" ]
	     	  then
                   if [ "$symlink" = "Y" ] || [ "$symlink" = "y" ] 
		   then

		    dofindsym "$findpath" "$what" "$whatype" "$namobj" "$depth" "print"

	            else
		    dofind "$findpath" "$what" "$whatype" "$namobj" "$depth" "print"
                   fi


                 fi
		if [ "$action" = "print0" ] || [ "$action" = "p0" ] || [ "$action" = "P0" ]
	       	 then
 if [ "$symlink" = "Y" ] || [ "$symlink" = "y" ] 
		   then

                     dofindsym "$findpath" "$what" "$whatype" "$namobj" "$depth" "print0"

	            else
		     dofind "$findpath" "$what" "$whatype" "$namobj" "$depth" "print0"

                   fi
		fi



fi
#Menu action when 2 is selected - profiler

if [ "$prompt" -eq "2" ]
  then	
    $CLR;

    echo "Exit at anytime to top level menu with (q or Q )";
    read -p "please enter the name of the program you wish to profile: " prog;
        

      if [ "$prog" = "q" ]||[ "$prog" = "Q" ]
        then 
	   menu;

     else

    echo "The following list shows values for  $prog , please select one:";
    i=0;
    for commd in $($PS -ef | awk '{print $8}'| grep "$prog")

      do
        echo "$i:) Select this program ?: " "$commd"

	((i++))
      done
    ((i--))
      read -p " There were 2 or more programs identified: 0-$i : " choice;

     # check whether the reponse is ok

      if [ "$choice" -gt $i ]||[ "$choice" -lt "0" ]
       then
	 echo "Please enter a valid choice "
	 sleep 2;
         menu_actions 2;
      fi
     selectprog "$prog" "$choice"
     fi
  fi
#Exit when 3 is selected

if [ "$prompt" -eq "3" ]
    then	
 echo -e "You want to run the xxxxxxx script please enter the options seperated by spaces (-m -d -f -n)"
		read -r  optb;
                
                if [ "$opt" = "q" ]||[ "$opt" = "Q" ]
		  then 
		   partbb "$opt";
	        fi
     fi
     
     
if [ "$prompt" -eq "4" ]
    then	
 echo -e "You want to run the xxxxxxx script please enter the options seperated by spaces (mem disk cpu)"
		read -r  opta;
                
                if [ "$opta" = "q" ]||[ "$opta" = "Q" ]
		  then 
		   partba "$opta";
	        fi
     fi
#Exit when 5 is selected
if [ "$prompt" -eq "5" ]
    then	
      echo -e "Exiting srchprofiler...........";
      exit 0;
  else
      echo " Error Please enter a value listed on the menu........(1,2,3,4,5)"
      sleep 2;
      menu;
  fi
}

# Call main menu
menu;

