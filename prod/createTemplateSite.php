#!/usr/local/bin/php
<?php
error_reporting(-1);
ini_set('display_errors', 1);

require_once '/usr/local/exhibit-e.com/vendor/phpass/PasswordHash.php';

$usage_str = "Usage: {$argv[0]} domain\n";

if ($argc != 2) {
    die($usage_str);
}
$url = trim($argv[1]);

if (isset($_SERVER['HOSTNAME']) && $_SERVER['HOSTNAME'] == 'dal-wh2.exhibit-e.com') {
    define('PRODUCTION', true);
    $connect_params = array(
        'host'          => '10.10.129.120',
        'user'          => 'root',
        'pass'          => '9TQ4PVKXWDE3WWGG',
        'database'      => 'ee_sites'
    );
    
} else {
    define('PRODUCTION', false);
    $connect_params = array(
        'host'          => '127.0.0.1',
        'user'          => getenv('mysql_user'),
        'pass'          => getenv('mysql_password'),
        'database'      => 'ee_sites'
    );
}


$db = new \mysqli(
    $connect_params['host'],
    $connect_params['user'], 
    $connect_params['pass'], 
    $connect_params['database']
);
if ($db->connect_error) {
    throw new \Exception("Couldn't connect");
}

if (strpos($url, 'www.') !== FALSE) {
    die("Domain should not contain 'www.'");
}

if (FALSE === isOkToRun($db, $url)) {
    echo "Exiting\n";
    exit;
}

echo "Site Name (Gallery B): ";
$site_name = trim(fgets(STDIN));

echo "User email (admin@exhbiit-e.com): ";
$username = trim(fgets(STDIN));
if (empty($username) || FALSE === filter_var($username, FILTER_VALIDATE_EMAIL)) {
    die("Invalid email");
    exit();
}

echo "New Password: ";
$password = trim(fgets(STDIN));
if (empty($password) || TRUE === preg_match('/[^\w]/', $password)) {
    die("Invalid password");
    exit();
}

$db->query("INSERT INTO sites SET"
    . " is_active = 1"
    . ", is_template_site = 1"
    . ", ee_site_name = 'gtemplate'"
    . ", name = '" . $db->real_escape_string($site_name) . "'"
);

$site_id = $db->insert_id;
if (!$site_id) {
    throw new \Exception("Site not created. db error:" . mysqli_error($db));
}

$db->query("INSERT INTO user SET"
    . " site_id = $site_id"
    . ", is_active = 1"
    . ", email = '" . $db->real_escape_string($username) . "'"
    . ", password = '" . $db->real_escape_string(hashPassword($password)) . "'"
);

$db->query("INSERT INTO gtemplate.urls SET"
    . " ee_gtemplate_id = $site_id"
    . ", is_default = 1"
    . ", url = '" . $db->real_escape_string($url) . "'"
);

$db->query("INSERT INTO gtemplate.settings SET"
    . " ee_gtemplate_id = $site_id"
);

echo "\n1. Add the following to the gtemplate SVN repo under httpd-site.conf when you are ready to go live:\n\n";
echo "ServerAlias $url www.$url";
echo "\n\n2. siteupdate gtemplate";
echo "\n3. restart apache\n\n";

exit;



function isOkToRun($db, $url)
{
    $res = $db->query("SELECT ee_gtemplate_id AS id FROM gtemplate.urls WHERE url = '" . $db->real_escape_string($url) . "'");
    $row = $res->fetch_assoc();

    if (!empty($row['id'])) {
        echo "Site already exists with ee_site_id = {$row['id']}\n";
        return FALSE;
    }

    if (PRODUCTION) {
        echo "You are about to run this on production data. Proceed? ";
        $prompt = trim(fgets(STDIN));

        if (!in_array($prompt, array('y', 'Y', 'yes', 'YES'))) {
            return FALSE;
        }    
    }
    
    return TRUE;
}

function hashPassword($password)
{
    $pwdHasher = new \PasswordHash(8, FALSE);

    return $pwdHasher->HashPassword($password);
}

