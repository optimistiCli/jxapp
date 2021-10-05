setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
}

@test "The osascript binary is in the PATH" {
    run which osascript
    assert_success
    assert_output --partial 'osascript'
}

@test "OSASCRIPT is set" {
    load Tests/common.bash
    run echo "$OSASCRIPT"
    assert_output --partial 'osascript'
}

@test "OSASCRIPT points to proper osascript" {
    load Tests/common.bash
    wrapper() {
        echo 'console.log("OK")' | "$OSASCRIPT" -l JavaScript
    }
    run wrapper
    assert_success
    assert_output 'OK'
}

