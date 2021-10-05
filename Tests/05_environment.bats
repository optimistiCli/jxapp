setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash
}

@test "Directives with environment variable value set with option" {
    run .build/debug/jxapp -e JXAPP_TEST=1 Tests/environment/var_set.js
    assert_output 'OK'
}

@test "Directives with empty environment variable set with option" {
    run .build/debug/jxapp -e JXAPP_TEST= Tests/environment/var_set.js
    assert_output 'OK'
}

@test "Directives with environment variable unset with option" {
    JXAPP_TEST=1 run .build/debug/jxapp -E JXAPP_TEST Tests/environment/var_unset.js
    assert_output 'OK'
}

@test "Runtime with environment variable value set with option" {
    run .build/debug/jxapp -e JXAPP_TEST=1 Tests/environment/var_set_runtime.js
    assert_output 'OK'
}

@test "Runtime with empty environment variable set with option" {
    run .build/debug/jxapp -e JXAPP_TEST= Tests/environment/var_empty_runtime.js
    assert_output 'OK'
}

@test "Directives with two environment variables set to default value" {
    run .build/debug/jxapp -e JXAPP_TEST -e JXAPP_SECOND_TEST Tests/environment/two_var_set.js
    assert_output 'OK'
}

@test "Directives with two environment variables unset with option" {
    JXAPP_TEST=1 JXAPP_SECOND_TEST=1 run .build/debug/jxapp \
            -E JXAPP_TEST -E JXAPP_SECOND_TEST Tests/environment/two_var_unset.js
    assert_output 'OK'
}
