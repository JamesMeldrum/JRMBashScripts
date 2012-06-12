<?php
define ('EE_SITE', '{{ site_name }}');
define('PROJECT_DIR', dirname(__DIR__) . '/src/site');

require getenv('ee_libs') . 'libeestd3.php';

require COMMON_DIR . '/Configuration.php';

use eE\Template\SiteTemplate;

function getTemplate()
{
    $tpl = new SiteTemplate();

    $tpl->setTemplateDir(PROJECT_DIR . '/View', array(
        'cache_id' => EE_SITE . '/site'
    ));

    $tpl->assign(array(
        'site_name' => $GLOBALS['Configuration']['site_name'],
        'client_url' => $GLOBALS['Configuration']['client_url'],
        'mode' => filter_input(INPUT_GET, 'mode', FILTER_SANITIZE_STRING) ?: 'home'
    ));
    
    return $tpl;
}

########################################################################
## RUN FORREST, RUN! NAMED HER THE ONLY NAME I COULD THINK OF; JENNY
########################################################################

$mode = filter_input(INPUT_GET, 'mode', FILTER_SANITIZE_STRING) ?: 'home';

switch ($mode) {
	case 'home':
		home();
		break;

	default:
	    throw new eE\Site\Site404Exception();
}

