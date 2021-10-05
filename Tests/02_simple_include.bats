setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash
}

@test "Simple include, no quotes" {
    run .build/debug/jxapp Tests/simple_include/no_quotes.js
    assert_output 'OK'
}

@test "Simple include, single quotes" {
    run .build/debug/jxapp Tests/simple_include/single_quotes.js
    assert_output 'OK'
}

@test "Simple include, double quotes" {
    run .build/debug/jxapp Tests/simple_include/double_quotes.js
    assert_output 'OK'
}
