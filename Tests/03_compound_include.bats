setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash
}

@test "Compound include" {
    run .build/debug/jxapp Tests/compound_include/main.js
    assert_output 'OK'
}

@test "Compound include once" {
    wrapper() {
        .build/debug/jxapp -c Tests/compound_include/main.js | grep -c "ObjC.import('Foundation')"
    }
    run wrapper
    assert_output '1'
}
