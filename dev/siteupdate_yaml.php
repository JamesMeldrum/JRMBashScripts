<?php
$file = file_get_contents("php://stdin", "r");

require('/usr/local/exhibit-e.com/yaml/sfYaml.php');

$config = sfYaml::load($file);
	
echo var_export($config, true);
