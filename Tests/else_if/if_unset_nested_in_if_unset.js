//include print.js

//if-unset JXAPP_TEST_001
    //if-unset JXAPP_TEST_002
        // 0,0,.,.
        print('1')
    //else-if-unset JXAPP_TEST_003
        // 0,1,0,.
        print('2')
    //else
        // 0,1,1,.
        print('3')
    //fi
//else-if-unset JXAPP_TEST_004
    //if-unset JXAPP_TEST_002
        // 1,0,.,0
        print('4')
    //else-if-unset JXAPP_TEST_003
        // 1,1,0,0
        print('5')
    //else
        // 1,1,1,0
        print('6')
    //fi
//else
    //if-unset JXAPP_TEST_002
        // 1,0,.,1
        print('7')
    //else-if-unset JXAPP_TEST_003
        // 1,1,0,1
        print('8')
    //else
        // 1,1,1,1
        print('9')
    //fi
//fi
