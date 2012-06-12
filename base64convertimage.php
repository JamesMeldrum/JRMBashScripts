#!/opt/local/bin/php
<?php

$filename = $argv[1];
if (!is_file($filename)) {
    die("File doesn't exist");
}

$str = file_get_contents($filename);
echo base64_encode($str);