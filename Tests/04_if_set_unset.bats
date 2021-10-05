setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash
}

@test "If-set, variable with \$ and in double quotes" {
    JXAPP_TEST=1 run .build/debug/jxapp Tests/if_set_unset/if_set_dollar_quotes.js
    assert_output 'OK'
}

@test "If-set, variable with \$ without quotes" {
    JXAPP_TEST=1 run .build/debug/jxapp Tests/if_set_unset/if_set_dollar.js
    assert_output 'OK'
}

@test "If-set, variable without \$" {
    JXAPP_TEST=1 run .build/debug/jxapp Tests/if_set_unset/if_set.js
    assert_output 'OK'
}

@test "If-set when variable is not set" {
    run .build/debug/jxapp Tests/if_set_unset/if_set_no_var.js
    assert_output 'OK'
}

@test "If-set + else, variable set" {
    JXAPP_TEST=1 run .build/debug/jxapp Tests/if_set_unset/if_set_else.js
    assert_output 'OK'
}

@test "If-set + else, variable not set" {
    run .build/debug/jxapp Tests/if_set_unset/if_set_else_no_var.js
    assert_output 'OK'
}

@test "If-unset, variable not set" {
    run .build/debug/jxapp Tests/if_set_unset/if_unset.js
    assert_output 'OK'
}

@test "If-unset, variable is set" {
    JXAPP_TEST=1 run .build/debug/jxapp Tests/if_set_unset/if_unset_with_var.js
    assert_output 'OK'
}

@test "If-unset + else, variable not set" {
    run .build/debug/jxapp Tests/if_set_unset/if_unset_else.js
    assert_output 'OK'
}

@test "If-unset + else, variable is set" {
    JXAPP_TEST=1 run .build/debug/jxapp Tests/if_set_unset/if_unset_else_with_var.js
    assert_output 'OK'
}
