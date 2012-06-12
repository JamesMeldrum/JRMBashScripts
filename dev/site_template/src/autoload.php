<?php

require_once EE_LIBS . 'vendor/symfony/src/Symfony/Framework/UniversalClassLoader.php';
//require_once EE_LIBS . 'vendor/ee/lib/eE/Site/DefaultExceptionHandler.php';

use Symfony\Framework\UniversalClassLoader;
//use eE\Site\DefaultExceptionHandler;

$loader = new UniversalClassLoader();
$loader->registerNamespaces(array(
    'site'      => __DIR__ . '/site',
    'eE'        => EE_LIBS . 'vendor/ee/lib',
    'Symfony'   => EE_LIBS . 'vendor/symfony/src',
    //'Zend'      => EE_LIBS . 'vendor/zend/library'
));
$loader->registerPrefixes(array(
    'Twig_'     => EE_LIBS . 'vendor/twig/lib',
    'Swift_'    => EE_LIBS . 'vendor/swiftmailer/lib/classes',
));
$loader->register();