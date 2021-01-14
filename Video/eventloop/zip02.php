<?php

$DIR=date("Ymd",strtotime('next sunday',strtotime(date("Ymd"))));

// Enter the name of directory 
$pathdir = "$DIR/";  
  
// Enter the name to creating zipped directory 
$zipcreated = "$DIR.zip"; 
  
// Create new zip class 
$zip = new ZipArchive; 
   
if($zip -> open($zipcreated, ZipArchive::CREATE ) === TRUE) { 
      
    // Store the path into the variable 
    $dir = opendir($pathdir); 
       
    while($file = readdir($dir)) { 
        if(is_file($pathdir.$file)) { 
            $zip -> addFile($pathdir.$file, $file); 
        } 
    } 
    $zip ->close(); 
} 

    sleep(3);

    // or however you get the path
    $yourfile = "$DIR.zip";

    $file_name = basename($yourfile);

    header("Content-Type: application/zip");
    header("Content-Disposition: attachment; filename=$file_name");
    header("Content-Length: " . filesize($yourfile));

    readfile($yourfile);
    exit;
  

?>