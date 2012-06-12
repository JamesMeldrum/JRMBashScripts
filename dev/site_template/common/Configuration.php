<?php
$Configuration['db_database']					= '';
$Configuration['db_username']					= '';
$Configuration['db_password']					= '';

$Configuration['site_name']						= '';
if (PRODUCTION) {
	$Configuration['client_url']				= 'http://www.{{ site_name }}.com/';
} else {
	$Configuration['client_url']				= 'http://{{ site_name }}.dev';
}

$Configuration['mailinglist_sender']			= '';
$Configuration['mailinglist_reply']				= '';