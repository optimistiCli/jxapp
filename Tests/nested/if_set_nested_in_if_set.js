//include print.js

//if-set JXAPP_TEST
    //if-set JXAPP_SECOND_TEST
        print('1')
    //else
        print('2')
    //fi
//else
    //if-set JXAPP_SECOND_TEST
        print('3')
    //else
        print('4')
    //fi
//fi
