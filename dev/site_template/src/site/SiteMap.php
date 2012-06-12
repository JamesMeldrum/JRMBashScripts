<?php
use eE\Site\SiteMap as BaseSiteMap;

class SiteMap extends BaseSiteMap
{
    public function dispatch()
    {
        util_connect_db();

    	// Homepage
    	$this->add('', '0.3', false, 'never');

		// Add rest of sitemap here
		
    	$this->output();
    }

}


