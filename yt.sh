#!/bin/bash
#TODO read from text? || IT CAN DOWNLOAD ONLY AUDIO TOO --> ADD THAT
select opt in List MCAT quit
do
  case $opt in
    List)
      echo "Enter 1 URL at a time !"
      read url
      echo "The first video of the URL is named :"
      echo "Proccesing..."
      youtube-dl -e -q --no-warnings --skip-download --playlist-end 1 $url
      echo "Enter the name of the new txt"
      read name
      echo "GETTING YOUR IDS..."
      youtube-dl -i --get-id --skip-download $url | awk '{print "https://www.youtube.com/watch?v="$0}' >> $name.txt
      echo "Done!"
      ;;
    MCAT)
      echo "Make sure the last songs are saved!"
      echo "Are your mcat and info saved?"
      read ans
      if [[ ans == y ]]; then
        truncate -s 0 mcat.txt info.txt #emptying mcat&info
      fi
      echo "Enter the number of the song after that :"
      cat log.txt #display last song
      read x
      date | tee mcat.txt #setting date on top of mcat
      #writing IDs
      youtube-dl -i --get-id --skip-download --playlist-end $x https://www.youtube.com/playlist?list=PLe8jmEHFkvsaDOOWcREvkgFoj6MD0pQ67 | awk '{print "https://www.youtube.com/watch?v="$0}' >> mcat.txt
      for (( i = 1; i < $x; i++ )); do
        youtube-dl -e -q --no-warnings --get-description --skip-download --playlist-end $i https://www.youtube.com/playlist?list=PLe8jmEHFkvsaDOOWcREvkgFoj6MD0pQ67 | iconv -c -t ascii | sed -e 2,27d -e 's/^\s*//' | head -n 2 >> info.txt
      done
      c=$(tail -n 1 mcat.txt)
      echo "The song the program started from is the :"
      youtube-dl -e --skip-download $c #confirm
      truncate -s 0 log.txt #emptying log
      date | tee log.txt #date
      #writing to log
      youtube-dl -e  --get-description --skip-download --playlist-end 1 https://www.youtube.com/playlist?list=PLe8jmEHFkvsaDOOWcREvkgFoj6MD0pQ67 >> log.txt
      break;;
    quit|*)
      break;;
  esac
done
