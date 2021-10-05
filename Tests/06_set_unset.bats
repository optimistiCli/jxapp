setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash
}

@test "Simple set variable" {
    run .build/debug/jxapp Tests/set_unset/set.js
    assert_output 'OK'
}

@test "Set variable with empty value" {
    run .build/debug/jxapp Tests/set_unset/set_empty_value.js
    assert_output 'OK'
}

@test "Set variable with empty value, no whitespace before “=”" {
    run .build/debug/jxapp Tests/set_unset/set_no_value_no_space_before_eq.js
    assert_output 'OK'
}

@test "Simple set variable with value" {
    run .build/debug/jxapp Tests/set_unset/set_with_value.js
    assert_output 'OK'
}

@test "Set variable with value, no whitespace before “=”" {
    run .build/debug/jxapp Tests/set_unset/set_with_value_no_space_before.js
    assert_output 'OK'
}

@test "Set variable with value, no whitespace after “=”" {
    run .build/debug/jxapp Tests/set_unset/set_with_value_no_space_after.js
    assert_output 'OK'
}

@test "Set variable with value, no whitespace before and after “=”" {
    run .build/debug/jxapp Tests/set_unset/set_with_value_no_space_before_and_after.js
    assert_output 'OK'
}

@test "Simple set variable, runtime" {
    run .build/debug/jxapp Tests/set_unset/set_runtime.js
    assert_output 'OK'
}

@test "Set variable with empty value, runtime" {
    run .build/debug/jxapp Tests/set_unset/set_empty_value_runtime.js
    assert_output 'OK'
}

@test "Set variable with empty value, no whitespace before “=”, runtime" {
    run .build/debug/jxapp Tests/set_unset/set_no_value_no_space_before_eq_runtime.js
    assert_output 'OK'
}

@test "Simple set variable with value, runtime" {
    run .build/debug/jxapp Tests/set_unset/set_with_value_runtime.js
    assert_output 'OK'
}

@test "Set variable with value, no whitespace before “=”, runtime" {
    run .build/debug/jxapp Tests/set_unset/set_with_value_no_space_before_runtime.js
    assert_output 'OK'
}

@test "Set variable with value, no whitespace after “=”, runtime" {
    run .build/debug/jxapp Tests/set_unset/set_with_value_no_space_after_runtime.js
    assert_output 'OK'
}

@test "Set variable with value, no whitespace before and after “=”, runtime" {
    run .build/debug/jxapp Tests/set_unset/set_with_value_no_space_before_and_after_runtime.js
    assert_output 'OK'
}

@test "Unset variable" {
    JXAPP_TEST=1 run .build/debug/jxapp Tests/set_unset/unset.js
    assert_output 'OK'
}

@test "Unset variable, runtime" {
    JXAPP_TEST=1 run .build/debug/jxapp Tests/set_unset/unset_runtime.js
    assert_output 'OK'
}
