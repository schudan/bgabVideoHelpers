<?php
	 if(date('D') == ('Sun')) { 
	      $DIR=date("Ymd",strtotime('today UTC',strtotime(date("Ymd"))));
	    } else {
	      $DIR=date("Ymd",strtotime('next sunday',strtotime(date("Ymd"))));
	    }
#$DIR=date("Ymd",strtotime('next sunday',strtotime(date("Ymd"))));

		// Enter the name of directory 
		$pathdir = "./sonntag/";  
  
    // or however you get the path
    $yourfile = "$DIR.pptx";
    
    $powerpoint = $pathdir . $yourfile;

    $file_name = basename($yourfile);

		$file_path = './$yourfile';
		$filename = '$yourfile';
		header("Content-Type: application/octet-stream");
		header("Content-Transfer-Encoding: Binary");
		header("Content-disposition: attachment; filename=\"".$yourfile."\""); 
		echo readfile($yourfile);
 
?>