//include func/print.js

//include-once	"fw/foundation.js"

print('1')

//if-set "$PATH"
    //include	"print2.js"
//else
    print('This should not be printed')
//fi

//if-unset NO_SUCH_VAR
    print('3')
//else
    print('This should neither be printed')
//fi

//include 'further/down/the rabbit hole/include me.js'
