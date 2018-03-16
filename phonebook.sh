#!/bin/bash

#dictionary file
dictionarypath=directory.txt

if [ ! -f "$dictionarypath" ]
then
	touch $dictionarypath
fi

cleanup(){
	rm -f tmp.txt tmp2.txt
	echo -e "\nCleanup done"
	exit 0
}


trap "cleanup" 2


while [ "forever" ]
do
echo -e "\n\n"
echo "Welcome to Phonebook!"
echo "Select One option:"
echo "1. Add new entry"
echo "2. Find entry"
echo "3. Edit entry"
echo "4. Delete record"

read option

case "$option" in
	"1")
	echo -e "Enter name: \c"
	read -r name
	echo -e "Enter Phone number: \c"
	read -r phone
	echo -e "Enter Email id: \c"
	read -r email
	echo -e "$name:$phone:$email" >> $dictionarypath
	;;
	"2")
	echo -e "Enter search term: \c"
	read -r searchword
	lines=`grep $searchword $dictionarypath | wc -l | tr -d ' '`
	if [ $lines -gt 0 ]
	then
		OLDIFS=$IFS
		IFS=''
		echo "$lines result(s) found"
		grep $searchword $dictionarypath >> tmp.txt
		counter=1
		while read line
		do
			line2=`echo $line| tr ":" "\t"`
			echo "$counter. $line2"
			counter=$((counter+1))
		done < tmp.txt
		rm tmp.txt
		IFS=$OLDIFS
	else
		echo "No search results"
	fi
	;;
	"3")
	flag="y"
	while [ "$flag" = "y" ]
	do
		flag="n"
		echo -e "Enter search term: \c"
		read -r searchword
		lines=`grep $searchword $dictionarypath | wc -l | tr -d ' '`
		if [ $lines -gt 0 ]
		then
			OLDIFS=$IFS
			IFS=''
			echo "$lines result(s) found"
			grep $searchword $dictionarypath >> tmp.txt
			counter=1
			while read line
			do
				line2=`echo $line| tr ":" "\t"`
				echo "$counter. $line2"
				counter=$((counter+1))
			done < tmp.txt
			flag2="y"
			while [ "$flag2" = "y" ]
			do
				echo "Select which entry you want to modify."
				read option2
				if [ $option2 -gt 0 ] && [ $option2 -le $lines ]
				then
					flag2="n"
				else
					echo "Choose valid option" 
				fi 
			done
			tmp1=`sed -n "${option2}p" tmp.txt`
			#echo $tmp1
			name=`echo "$tmp1" | awk '{split($0,a,":"); print a[1]}'`
			phone=`echo "$tmp1" | awk '{split($0,a,":"); print a[2]}'`
			email=`echo "$tmp1" | awk '{split($0,a,":"); print a[3]}'`
			echo "Modify name (previous value = '$name', enter new value, return to keep it same)"
			read tmp2
			if [ ! -z "$tmp2" ]
			then
				name="$tmp2"
			fi
			echo "Modify phone (previous value = '$phone', enter new value, return to keep it same)"
			read tmp2
			if [ ! -z "$tmp2" ]
			then
				phone="$tmp2"
			fi
			echo "Modify email (previous value = '$email', enter new value, return to keep it same)"
			read tmp2
			if [ ! -z "$tmp2" ]
			then
				email="$tmp2"
			fi
			newvalue="$name:$phone:$email"
			cat $dictionarypath | sed "s/$tmp1/$newvalue/g" >> tmp2.txt
			rm $dictionarypath
			mv tmp2.txt $dictionarypath
			#echo "$name:$phone:$email"
			rm tmp.txt
			IFS=$OLDIFS
		else
			echo "Try again.."
		fi
	done
	;;
	"4")
	flag="y"
	while [ "$flag" = "y" ]
	do
		flag="n"
		echo -e "Enter search term: \c"
		read -r searchword
		lines=`grep $searchword $dictionarypath | wc -l | tr -d ' '`
		if [ $lines -gt 0 ]
		then
			OLDIFS=$IFS
			IFS=''
			echo "$lines result(s) found"
			grep $searchword $dictionarypath >> tmp.txt
			counter=1
			while read line
			do
				line2=`echo $line| tr ":" "\t"`
				echo "$counter. $line2"
				counter=$((counter+1))
			done < tmp.txt
			flag2="y"
			while [ "$flag2" = "y" ]
			do
				echo "Select which entry you want to delete."
				read option2
				if [ $option2 -gt 0 ] && [ $option2 -le $lines ]
				then
					flag2="n"
				else
					echo "Choose valid option" 
				fi 
			done
			tmp1=`sed -n "${option2}p" tmp.txt`
			cat $dictionarypath | sed "/$tmp1/d" >> tmp2.txt
			rm $dictionarypath
			mv tmp2.txt $dictionarypath
			#echo "$name:$phone:$email"
			rm tmp.txt
			IFS=$OLDIFS
		else
			echo "Entry not found. Try again.."
		fi
	done
	;;
esac
done
