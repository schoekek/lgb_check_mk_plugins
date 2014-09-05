<?php

/******************************************************************************
 *
 *  check_mk plugin for xcache
 *  please insert this script into the webroot of your monitored webserver. 
 *  
 *  It based on code for munin Plugin under http://www.ohardt.net/dev/munin/ 
 *  Infos under https://github.com/lgbff/lgb_check_mk_plugins/tree/master/xchache
 */

$DATA_VALUES = array (
                            "memory_php_max" => 'php_max',
                            "memory_php_cur" => 'php_cur',
                            "memory_var_max" => 'var_max',
                            "memory_var_cur" => 'var_cur',
                            "php_cache_hits"   => 'php_hits',
                            "var_cache_hits"   => 'var_hits',
                            "php_misses" => 'php_miss',
                            "var_misses" => 'var_miss',
                            "php_cached" => 'php_cached',
                            "var_cached" => 'var_cached',
                            "php_errors" => 'php_errors',
                            "var_errors" => 'var_errors'
);

xcache_print_data();

exit( 0 );

function xcache_print_data() {

    global $DATA_VALUES;

    $data = get_data();
        
    // got data ? 
    if( $data === false ) {

        foreach( $DATA_VALUES as $key => $value ) {
            print $key . " emty\n";
        }
        return false;
    }
    
    foreach( $DATA_VALUES as $key => $value ) {
        print $key . " " . $data[ $value ] . "\n";
    }
    
    return true;
}

function get_data() {
    
    $pcnt = xcache_count(XC_TYPE_PHP);
    $vcnt = xcache_count(XC_TYPE_VAR);
    
    $info['php_max'] = 0;
    $info['php_cur'] = 0;
    
    $info['var_max'] = 0;
    $info['var_cur'] = 0;
    
    $info['php_hits']  = 0;
    $info['var_hits']  = 0;
    
    $info['php_miss']  = 0;
    $info['var_miss']  = 0;
    
    $info['php_cached']  = 0;
    $info['var_cached']  = 0;

    $info['php_errors']  = 0;
    $info['var_errors']  = 0;

    $cacheInfos = array(); 
    for ($i = 0; $i < $pcnt; $i ++) {
            $data = xcache_info(XC_TYPE_PHP, $i);
            $info['php_max']  += $data["size"];
            $info['php_cur']  += $data["avail"];
    
            $info['php_hits'] += $data["hits"];
            $info['php_miss'] += $data["misses"];
    
            $info['php_cached'] += $data["cached"];
            $info['php_errors'] += $data["errors"];
    }
    
    for ($i = 0; $i < $vcnt; $i ++) {
            $data = xcache_info(XC_TYPE_VAR, $i);
    
            $info['var_max']  += $data["size"];
            $info['var_cur']  += $data["avail"];
    
            $info['var_hits'] += $data["hits"];
            $info['var_miss'] += $data["misses"];
    
            $info['var_cached'] += $data["cached"];
            $info['var_errors'] += $data["errors"];
    }
    return $info;
}
?>
