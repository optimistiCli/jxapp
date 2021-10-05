setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash
}

@test "It runs" {
    run .build/debug/jxapp
    assert_output --partial 'Usage:'
}
