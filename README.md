# Top Movie Search
This project is for people who like watching movies. The script scrapes information from [Rotten Tomatoes Weekend
Box Office Chart](https://www.rottentomatoes.com/browse/box-office/). 

# Project Summary
Top Movie Search is similar to box office chart which people can view top movies from the weekend. It displays the top 10 movies sorted by rating and sorted by gross. As one runs the program, it will give the user a condense version of the weekend chart instead of viewing 60 of them at the same time. Additionally, it allows the user to acquire more information of a movie of their choice. The program will prompt the user to pick a movie that they want to know more about. After picking, the program will output the movie info of the selected movie. Then, it will once again ask if the user wants the movie info in an email form. All the data are directed scraped from [Rotten Tomatoes](https://www.rottentomatoes.com/). However, if the inputted movie is not found on rotten tomatoes, it will force the program to terminate.

# Example
```
-bash-4.2$ sh myScript.sh 
Here is the weekend box office chart for new movies!
Here are the top 10 sorted by rating:
      Fiddler: A Miracle of Miracles     
      Honeyland     
      The Farewell     
      Maiden     
      Tigers Are Not Afraid      
      Toy Story      
      The Peanut Butter Falcon     
      Miles Davis: Birth of the Cool     
      End of the Century     
      Raise Hell: The Life and Times of Molly Ivins  
And here are the top 10 sorted by gross:
      It Chapter Two     
      Angel Has Fallen     
      Good Boys     
      The Lion King     
      Fast and Furious Presents: Hobbs and Shaw     
      Overcomer     
      Dora and the Lost City of Gold     
      Ready or Not     
      Scary Stories to Tell in the Dark     
      Once Upon a Time In Hollywood     



which movie do you like to know more
ready or not


Movie Info

   A typical Las Vegas bachelor party takes a dangerous turn of events
   when four college friends become stranded in Mexico and must race to
   get back to the United States in time for the bachelor to reach the
   alter in time for his wedding. Now, if they can just survive long
   enough to cross the border and get to the church on time, these four
   friends will have a story worth passing down through the generations.

Do you want the synopsis as an email? [yes/no]
yes
what is your email address?
example@gmail.com
Sent!
```
