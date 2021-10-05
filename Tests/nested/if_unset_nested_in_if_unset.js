//include print.js

//if-unset JXAPP_TEST
    //if-unset JXAPP_SECOND_TEST
        print('1')
    //else
        print('2')
    //fi
//else
    //if-unset JXAPP_SECOND_TEST
        print('3')
    //else
        print('4')
    //fi
//fi
