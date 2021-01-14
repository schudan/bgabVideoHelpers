<?php
$a = date("Y/m/d");
 
$last_sunday=date("Y/m/d",strtotime('last sunday',strtotime($a)));
$next_sunday=date("Y/m/d",strtotime('next sunday',strtotime($a)));
$DIR=date("Ymd",strtotime('next sunday',strtotime(date("Ymd")))); 

 echo $last_sunday."\n";
 echo $next_sunday."<br/>";
 echo $DIR;

?>