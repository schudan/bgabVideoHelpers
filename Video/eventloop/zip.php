<?php

$DIR=date("Ymd",strtotime('next sunday',strtotime(date("Ymd"))));
$zip = new ZipArchive;
if ($zip->open('$DIR.zip', ZipArchive::OVERWRITE) === TRUE)
{
    if ($handle = opendir('$DIR'))
    {
        // Add all files inside the directory
        while (false !== ($entry = readdir($handle)))
        {
            if ($entry != "." && $entry != ".." && !is_dir($DIR. '/' . $entry))
            {
                $zip->addFile($DIR. '/' . $entry);
            }
        }
        closedir($handle);
    }
 
    $zip->close();
}

?>