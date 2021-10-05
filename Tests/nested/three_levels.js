//include print.js

//if-set JXAPP_TEST
    //if-set JXAPP_SECOND_TEST
        //if-set JXAPP_THIRD_TEST
            print('1')
        //else
            print('2')
        //fi
    //else
        //if-set JXAPP_THIRD_TEST
            print('3')
        //else
            print('4')
        //fi
    //fi
//else
    //if-set JXAPP_SECOND_TEST
        //if-set JXAPP_THIRD_TEST
            print('5')
        //else
            print('6')
        //fi
    //else
        //if-set JXAPP_THIRD_TEST
            print('7')
        //else
            print('8')
        //fi
    //fi
//fi
