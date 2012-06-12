#!/usr/local/bin/php
<?php
error_reporting(-1);
ini_set('display_errors', 1);

require_once '/usr/local/exhibit-e.com/vendor/phpass/PasswordHash.php';
echo "\nexhibit-E site creator\n\n";
$usage_str = "Usage: {$argv[0]} ee_site\n";

if ($argc != 2) {
    die($usage_str);
}
$ee_site = trim($argv[1]);

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

define('EE_SITE_DIR', '/opt/www/');
define('EE_FILES_DIR', '/opt/www/files/');
define('LOGS_DIR', '/var/www/w3logs/');
define('ADMIN_LOGS_DIR', '/var/www/admin_logs/');

if (is_dir(EE_SITE_DIR . $ee_site)) {
    die("site already exists in filesystem");
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

if (FALSE === isOkToRun($db, $ee_site)) {
    echo "Exiting\n";
    exit;
}

echo "Admin User:\n";
$username = getUsername();
$password = getPassword();
echo "\n\n";

echo "AWStats domain:\n";
$domain = getAWStatsDomains();
$awstats_key = createAWStatsConfig($ee_site, $domain);
echo "\n\n";

echo "Directory creation:\n";
createDirectories($ee_site);
echo "\n\n";


$db->query("INSERT INTO sites SET"
    . " is_active = 1"
    . ", ee_site_name = '" . $db->real_escape_string($ee_site). "'"
    . ", name = '" . $db->real_escape_string(ucfirst($ee_site)) . "'"
    . ", awstats_key = '" . $db->real_escape_string($awstats_key) . "'"
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


echo "\n\n1. Now perform a siteupdate";
echo "\n2. run 'sudo apachectl configtest'";
echo "\n3. run 'apachectl graceful'\n\n";

exit;



function isOkToRun($db, $ee_site)
{
    $res = $db->query("SELECT 1 FROM sites WHERE ee_site_name = '" . $db->real_escape_string($ee_site). "'");

    if ($res->fetch_assoc()) {
        echo "Site already exists\n";
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

function getUsername()
{
    do {
        echo "Email (admin@exhbiit-e.com): ";
        $username = trim(fgets(STDIN));

        if (!empty($username) && filter_var($username, FILTER_VALIDATE_EMAIL)) {
            break;
        }
    } while (1);
    
    return $username;
}

function getPassword()
{
    do {
        echo "Password: ";
        $password = trim(fgets(STDIN));

        if (!empty($password) && !preg_match('/[^\w]/', $password)) {
            break;
        }
    } while (1);
    
    return $password;
}

function getAWStatsDomains()
{
    do {
        echo "Domain without \"www.\" (i.e. mygallery.com): ";
        $domain = trim(fgets(STDIN));

        if (!empty($domain)) {
            echo "Main domain will be \"www.$domain\"\n";
            echo "Alias will be \"$domain\"\n";
            
            echo "OK (Y/N)?: ";
            $agree = strtolower(trim(fgets(STDIN)));
            if ($agree === 'y') {
                break;
            }
        }
    } while (1);
    
    return $domain;
}

function createAWStatsConfig($ee_site, $domain)
{
    $site_config = "Include \"awstats.EEallsites.conf\""
        . "\nLogFile=\"/var/www/w3logs/$ee_site/access_log\""
        . "\nSiteDomain=\"www.$domain\""
        . "\nHostAliases=\"$domain\""
        ;

    do {
        $rand = exec('pwgen 16');
        if (empty($rand)) {
            die("pwgen binary not found");
        }
        $filepath = "/etc/awstats/awstats.$rand.conf";

        if (!is_file($filepath)) {
            break;
        }
    } while (1);

    if (PRODUCTION) {
        $res = file_put_contents($filepath, $site_config);
        if (!$res) {
            die("AWStats config file couldn't be configured");
        }
    } else {
        echo "Placing the following into $filepath:\n\n"
            . "$site_config\n\n"
            ;
    }
    
    return $rand;

}


function createDirectories($ee_site)
{
    if (!PRODUCTION) {
        echo "Creating Directories\n";
        return;
    }

    // Site root
    mkdir(EE_SITE_DIR . $ee_site);
    chown(EE_SITE_DIR . $ee_site, 'ee_dev_sync');
    chgrp(EE_SITE_DIR . $ee_site, 'ee_dev_sync');
    chmod(EE_SITE_DIR . $ee_site, 0775);

    // Files
    mkdir(EE_FILES_DIR . $ee_site);
    chown(EE_FILES_DIR . $ee_site, 'nobody');
    chgrp(EE_FILES_DIR . $ee_site, 'nobody');
    chmod(EE_FILES_DIR . $ee_site, 0775);

    // Logs
    mkdir(LOGS_DIR . $ee_site);
    chown(LOGS_DIR . $ee_site, 'nobody');
    chgrp(LOGS_DIR . $ee_site, 'nobody');
    chmod(LOGS_DIR . $ee_site, 0775);

    // Admin Logs
    mkdir(ADMIN_LOGS_DIR . $ee_site);
    chown(ADMIN_LOGS_DIR . $ee_site, 'nobody');
    chgrp(ADMIN_LOGS_DIR . $ee_site, 'nobody');
    chmod(ADMIN_LOGS_DIR . $ee_site, 0775);

    // Assets
    symlink(EE_SITE_DIR . "$ee_site/site", EE_SITE_DIR . "exhibit-e_libsite/site/sites/$ee_site");
}