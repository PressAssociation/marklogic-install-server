xquery version "1.0-ml";
(: Copyright 2009, Mark Logic Corporation. All Rights Reserved. :)

import module namespace inst-conf = "http://www.marklogic.com/ps/install/config.xqy" at "config.xqy";
import module namespace inst-db = "http://www.marklogic.com/ps/lib/lib-database.xqy" at "/lib/lib-database.xqy";
import module namespace inst-app = 'http://www.marklogic.com/ps/lib/lib-app-server.xqy' at "/lib/lib-app-server.xqy";
import module namespace inst-idx = 'http://www.marklogic.com/ps/lib/lib-index.xqy' at "/lib/lib-index.xqy";
import module namespace inst-cpf = 'http://www.marklogic.com/ps/lib/lib-cpf.xqy' at "/lib/lib-cpf.xqy";
import module namespace inst-load = 'http://www.marklogic.com/ps/lib/lib-load.xqy' at "/lib/lib-load.xqy";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $action as xs:string external;
declare variable $environ as xs:string external;
declare variable $delete-data as xs:boolean external;

let $install-config := $inst-conf:DEFAULT-INSTALL-CONFIG//inst-conf:development

let $LOG := xdmp:log($install-config)

let $ACTION :=
if ("install-all" eq $action) then
(
    $action,
    inst-db:install-databases($install-config),
    inst-app:install-servers($install-config),
    inst-cpf:install-cpf($install-config),
    inst-load:load-content($install-config),
    xdmp:restart((),"Installation")
)
else if ("uninstall-all" eq $action) then
(
    $action,
    inst-app:uninstall-servers($install-config),
    inst-db:uninstall-databases($install-config, $delete-data)
)
else if ("install-databases" eq $action) then
(
   $action,
    inst-db:install-databases($install-config)
)
else if ("uninstall-databases" eq $action) then
(
    $action,
    inst-db:uninstall-databases($install-config, $delete-data)
)
else if ("install-servers" eq $action) then
(   
    $action,
    inst-app:install-servers($install-config)
)
else if ("uninstall-servers" eq $action) then
(
   $action,
    inst-app:uninstall-servers($install-config)
)
else if ("reinstall-content" eq $action) then
(
   $action,
    inst-load:load-content($install-config)
)
else if ("load-pipelines" eq $action) then
(
    $action,
    inst-cpf:load-pipelines($install-config)
)
else if ("create-domains" eq $action) then
(
    $action,
    inst-cpf:create-domains($install-config)
)
else if ("create-configurations" eq $action) then
(
    $action,
    inst-cpf:create-configurations($install-config)
)
else
    text{"Invalid Action: ", $action}

    
return $ACTION    
    