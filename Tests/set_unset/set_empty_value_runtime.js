//include print.js

//include app.js

//set JXAPP_TEST =

if (app.systemAttribute().includes("JXAPP_TEST") 
        && app.systemAttribute("JXAPP_TEST") == "") {
    print('OK')
}
