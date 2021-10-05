setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash
}

@test "Else-if in If-set nested in if-set: 1,1,1,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-set nested in if-set: 1,1,1,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-set nested in if-set: 1,1,0,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-set nested in if-set: 1,1,0,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-set nested in if-set: 1,0,1,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '2'
}

@test "Else-if in If-set nested in if-set: 1,0,1,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '2'
}

@test "Else-if in If-set nested in if-set: 1,0,0,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '3'
}

@test "Else-if in If-set nested in if-set: 1,0,0,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '3'
}

@test "Else-if in If-set nested in if-set: 0,1,1,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '4'
}

@test "Else-if in If-set nested in if-set: 0,1,1,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '7'
}

@test "Else-if in If-set nested in if-set: 0,1,0,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '4'
}

@test "Else-if in If-set nested in if-set: 0,1,0,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '7'
}

@test "Else-if in If-set nested in if-set: 0,0,1,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '5'
}

@test "Else-if in If-set nested in if-set: 0,0,1,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '8'
}

@test "Else-if in If-set nested in if-set: 0,0,0,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '6'
}

@test "Else-if in If-set nested in if-set: 0,0,0,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_set.js
    assert_success
    assert_output '9'
}

@test "Else-if in If-set nested in if-unset: 1,1,1,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '7'
}

@test "Else-if in If-set nested in if-unset: 1,1,1,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '4'
}

@test "Else-if in If-set nested in if-unset: 1,1,0,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '7'
}

@test "Else-if in If-set nested in if-unset: 1,1,0,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '4'
}

@test "Else-if in If-set nested in if-unset: 1,0,1,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '8'
}

@test "Else-if in If-set nested in if-unset: 1,0,1,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '5'
}

@test "Else-if in If-set nested in if-unset: 1,0,0,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '9'
}

@test "Else-if in If-set nested in if-unset: 1,0,0,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '6'
}

@test "Else-if in If-set nested in if-unset: 0,1,1,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-set nested in if-unset: 0,1,1,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-set nested in if-unset: 0,1,0,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-set nested in if-unset: 0,1,0,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-set nested in if-unset: 0,0,1,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '2'
}

@test "Else-if in If-set nested in if-unset: 0,0,1,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '2'
}

@test "Else-if in If-set nested in if-unset: 0,0,0,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '3'
}

@test "Else-if in If-set nested in if-unset: 0,0,0,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_set_nested_in_if_unset.js
    assert_success
    assert_output '3'
}

@test "Else-if in If-unset nested in if-set: 1,1,1,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '3'
}

@test "Else-if in If-unset nested in if-set: 1,1,1,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '3'
}

@test "Else-if in If-unset nested in if-set: 1,1,0,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '2'
}

@test "Else-if in If-unset nested in if-set: 1,1,0,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '2'
}

@test "Else-if in If-unset nested in if-set: 1,0,1,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-unset nested in if-set: 1,0,1,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-unset nested in if-set: 1,0,0,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-unset nested in if-set: 1,0,0,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-unset nested in if-set: 0,1,1,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '6'
}

@test "Else-if in If-unset nested in if-set: 0,1,1,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '9'
}

@test "Else-if in If-unset nested in if-set: 0,1,0,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '5'
}

@test "Else-if in If-unset nested in if-set: 0,1,0,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '8'
}

@test "Else-if in If-unset nested in if-set: 0,0,1,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '4'
}

@test "Else-if in If-unset nested in if-set: 0,0,1,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '7'
}

@test "Else-if in If-unset nested in if-set: 0,0,0,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '4'
}

@test "Else-if in If-unset nested in if-set: 0,0,0,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_set.js
    assert_success
    assert_output '7'
}

@test "Else-if in If-unset nested in if-unset: 1,1,1,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '9'
}

@test "Else-if in If-unset nested in if-unset: 1,1,1,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '6'
}

@test "Else-if in If-unset nested in if-unset: 1,1,0,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '8'
}

@test "Else-if in If-unset nested in if-unset: 1,1,0,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '5'
}

@test "Else-if in If-unset nested in if-unset: 1,0,1,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '7'
}

@test "Else-if in If-unset nested in if-unset: 1,0,1,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '4'
}

@test "Else-if in If-unset nested in if-unset: 1,0,0,1" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '7'
}

@test "Else-if in If-unset nested in if-unset: 1,0,0,0" {
    run .build/debug/jxapp \
            -e JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '4'
}

@test "Else-if in If-unset nested in if-unset: 0,1,1,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '3'
}

@test "Else-if in If-unset nested in if-unset: 0,1,1,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '3'
}

@test "Else-if in If-unset nested in if-unset: 0,1,0,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '2'
}

@test "Else-if in If-unset nested in if-unset: 0,1,0,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -e JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '2'
}

@test "Else-if in If-unset nested in if-unset: 0,0,1,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-unset nested in if-unset: 0,0,1,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -e JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-unset nested in if-unset: 0,0,0,1" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -e JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '1'
}

@test "Else-if in If-unset nested in if-unset: 0,0,0,0" {
    run .build/debug/jxapp \
            -E JXAPP_TEST_001 \
            -E JXAPP_TEST_002 \
            -E JXAPP_TEST_003 \
            -E JXAPP_TEST_004 \
            Tests/else_if/if_unset_nested_in_if_unset.js
    assert_success
    assert_output '1'
}
