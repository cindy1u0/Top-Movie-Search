#!/bin/bash

# sh myScript.sh

# The line above makes your script executable.
# You should write your tutorial in here.
# Include comments inline with your script explaining what is going on.

# You might start out by first saying the purpose of the script and
# demonstrating its usage.

# Problem Statement: For movie lovers, sometimes it is problematic for them to find the right movie to 
# 		     watch because they don't know about the movie or the rating. In order to make movie 
# 	             lovers's (me included) life easier, the script will provide top 10 movies sorted by 
#		     rating and by gross. The user can acquire a movie's synopsis and receive it in an 
#		     email form if needed

# Name of commands: sed, awk, tr, rm, lynx -dump, head, tail, sort, read, echo, cat, mailx, grep
# Examples of their usages:
# -bash-4.2$ echo hi
# hi
# -bash-4.2$ awk '{print $1}' movie.csv
# (print out the first column in movie.csv)
# -bash-4.2$ sed '$d' test.html
# (delete the last line in test.html)
# -bash-4.2$ tr '[:upper:]' '[:lower:]'
# (turns all upper cases into lower cases)
# -bash-4.2$ rm myfile.txt
# (remove the file named myfile.txt)
# -bash-4.2$ lynx -dump URL
# (Extracts information from the website)
# -bash-4.2$ head -n 1 scrape.html
# (first line in scrape.html)
# -bash-4.2$ tail -n 1 scrape.html
# (last line in scrape.html)
# -bash-4.2$ sort -k3 -nr nWeb.csv 
# (sorts nWeb.csv by the third column in descending order)
# -bash-4.2$ mailx -s "hi" "cindy@gmail.com"
# (sends an email to cindy@gmail.com with the subject "hi")
# -bash-4.2$ grep "hi" test.html
# (outputs instances that contain the string "hi")

# Here is the myScript.sh script that can list movies and acquire synopsis from online sources
# as an email if needed
# --------------------------------------------

# using lynx to scrape the rotten tomatoes Weekend Movie Chart
lynx -dump https://www.rottentomatoes.com/browse/box-office/ > web.html
sed '/http/d' web.html > scrape.html
rm web.html

# grep the first and last instance of 'Last Weekend' to get only the chart information
# and throw away other irrelevant information since the table is in between two "Last Weekend."
first=$(grep -n 'Last Weekend' scrape.html | head -n 1 | awk -F'[^0-9]*' '{print $1;}')
second=$(grep -n 'Last Weekend' scrape.html | tail -n 1 | awk -F'[^0-9]*' '{print $1;}')
# Gets the table (lines) to read the data 
sed -i -n $first,$second\p scrape.html
# format the table so that it doesn't have special characters and all the lines should
# be longer than 30 since some of them don't have enough information and we dont 
# care about those
sed -i '/^$/d' scrape.html
sed -i '1,4d;$d' scrape.html
# merge first three lines (because the original format is weird)
sed -i '1{N;N;N; s/\n/ /g;}' scrape.html
# replace "no score yet" for those who don't have rating with "__"
sed -i 's/No Score Yet/--/g; s/&/and/g' scrape.html
sed -i 's/\[[^]]*\]//g' scrape.html
awk 'length($0)>30'  scrape.html > nWeb.csv
# remove unnecessary files
rm scrape.html

# using for loop to only print out the name of the movies excluding its ranking
# and gross income and other information so that it is more presentable
for line in $(seq 1 60); 
do
	# sort by rating (which is the third column) and write a new file with the sorted list
	sort -k3 -nr nWeb.csv | awk '{out="     "; for(i=4;i<=NF;i++){out=out" "$i}; print out}' | sed 's/[0-9]*//g; s/--//g; s/$.k//g; s/$.M//g' |sed -e 's/([^()]*)//g' > Rating.csv 
	# sort by gross and write a new file with the sorted list
	awk '{out="     "; for(i=4;i<=NF;i++){out=out" "$i}; print out}' nWeb.csv | sed 's/[0-9]*//g; s/--//g; s/$.k//g; s/$.M//g' > Gross.csv
done

rm nWeb.csv

# Script that prints out top 10 of the movies from each of the sorted lists
echo -e "Here is the weekend box office chart for new movies!\nHere are the top 10 sorted by rating:\n$(sed -n 1,10p Rating.csv)\nAnd here are the top 10 sorted by gross:\n$(sed -n 1,10p Gross.csv)"
# prompts the user to acquire more information of the movie they like
echo -e  "\n\n\nwhich movie do you like to know more"
read movie
# formats the user's input to put in the URL
moviename=$(echo $movie | sed -e 's/([^()]*)//g'| sed 's/[^a-z  A-Z]//g'| tr '[:upper:]' '[:lower:]' | sed -e 's/ /_/g')
# Converts all upper cases to lower cases so that it would be easier to fine if
# a specific string is in the file
awk '{print tolower($0)}' Gross.csv > testList.csv

# if the user's input is not found in the file (no such movie), then the program will stop; 
# Otherwise, it will look up the movie synopsis online and print out the synopsis
if [ $(grep -q "$(echo $movie | tr '[:upper:]' '[:lower:]')" testList.csv ; echo $?) -eq 0 ]; then
	# Search up synopsis of the user's movie on rotten tomatoes (URL is formed by what
	# the user inputs) and get the useful information (same method as above)	
	lynx -dump https://www.rottentomatoes.com/m/$moviename > movie.html
	begin=$(grep -n 'Movie Info' movie.html | awk -F'[^0-9]*' '{print $1;}')
	end=$(grep -n '* Rating' movie.html | awk -F'[^0-9]*' '{print $1;}')
	sed -n $begin,$end\p movie.html | sed '$d' > info.html
	echo -e "\n"
	# print out the synopsis
	cat info.html
	# ask the user if they want an email of the synopsis
	echo -e "\nDo you want the synopsis as an email? [yes/no]"
	read bool
	
	# Give the user options if they want an email of the synopsis
	# It will read the user's email if yes; Otherwise the program stops
	if [ $bool == "yes" ]; then
		echo "what is your email address?"
		read address
		cat info.html | mailx -s "Synopsis" $address
		echo Sent!
	else
		echo "Alright"
	fi
	# remove all the files because they are not needed anymore
	rm testList.csv Gross.csv Rating.csv info.html movie.html
else 
	# Stop the program if the user's input is not valid (movie not found)
	echo "enter movie does not exist, sorry."
fi

