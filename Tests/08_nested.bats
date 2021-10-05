setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash
}

@test "If-set nested in if-set: satisfied, satisfied" {
    run .build/debug/jxapp -e JXAPP_TEST -e JXAPP_SECOND_TEST Tests/nested/if_set_nested_in_if_set.js 
    assert_success
    assert_output '1'
}

@test "If-set nested in if-set: satisfied, unsatisfied" {
    run .build/debug/jxapp -e JXAPP_TEST -E JXAPP_SECOND_TEST Tests/nested/if_set_nested_in_if_set.js 
    assert_success
    assert_output '2'
}

@test "If-set nested in if-set: unsatisfied, satisfied" {
    run .build/debug/jxapp -E JXAPP_TEST -e JXAPP_SECOND_TEST Tests/nested/if_set_nested_in_if_set.js 
    assert_success
    assert_output '3'
}

@test "If-set nested in if-set: unsatisfied, unsatisfied" {
    run .build/debug/jxapp -E JXAPP_TEST -E JXAPP_SECOND_TEST Tests/nested/if_set_nested_in_if_set.js 
    assert_success
    assert_output '4'
}

@test "If-unset nested in if-set: satisfied, satisfied" {
    run .build/debug/jxapp -e JXAPP_TEST -e JXAPP_SECOND_TEST Tests/nested/if_unset_nested_in_if_set.js 
    assert_success
    assert_output '2'
}

@test "If-unset nested in if-set: satisfied, unsatisfied" {
    run .build/debug/jxapp -e JXAPP_TEST -E JXAPP_SECOND_TEST Tests/nested/if_unset_nested_in_if_set.js 
    assert_success
    assert_output '1'
}

@test "If-unset nested in if-set: unsatisfied, satisfied" {
    run .build/debug/jxapp -E JXAPP_TEST -e JXAPP_SECOND_TEST Tests/nested/if_unset_nested_in_if_set.js 
    assert_success
    assert_output '4'
}

@test "If-unset nested in if-set: unsatisfied, unsatisfied" {
    run .build/debug/jxapp -E JXAPP_TEST -E JXAPP_SECOND_TEST Tests/nested/if_unset_nested_in_if_set.js 
    assert_success
    assert_output '3'
}

@test "If-set nested in if-unset: satisfied, satisfied" {
    run .build/debug/jxapp -e JXAPP_TEST -e JXAPP_SECOND_TEST Tests/nested/if_set_nested_in_if_unset.js 
    assert_success
    assert_output '3'
}

@test "If-set nested in if-unset: satisfied, unsatisfied" {
    run .build/debug/jxapp -e JXAPP_TEST -E JXAPP_SECOND_TEST Tests/nested/if_set_nested_in_if_unset.js 
    assert_success
    assert_output '4'
}

@test "If-set nested in if-unset: unsatisfied, satisfied" {
    run .build/debug/jxapp -E JXAPP_TEST -e JXAPP_SECOND_TEST Tests/nested/if_set_nested_in_if_unset.js 
    assert_success
    assert_output '1'
}

@test "If-set nested in if-unset: unsatisfied, unsatisfied" {
    run .build/debug/jxapp -E JXAPP_TEST -E JXAPP_SECOND_TEST Tests/nested/if_set_nested_in_if_unset.js 
    assert_success
    assert_output '2'
}

@test "If-unset nested in if-unset: satisfied, satisfied" {
    run .build/debug/jxapp -e JXAPP_TEST -e JXAPP_SECOND_TEST Tests/nested/if_unset_nested_in_if_unset.js 
    assert_success
    assert_output '4'
}

@test "If-unset nested in if-unset: satisfied, unsatisfied" {
    run .build/debug/jxapp -e JXAPP_TEST -E JXAPP_SECOND_TEST Tests/nested/if_unset_nested_in_if_unset.js 
    assert_success
    assert_output '3'
}

@test "If-unset nested in if-unset: unsatisfied, satisfied" {
    run .build/debug/jxapp -E JXAPP_TEST -e JXAPP_SECOND_TEST Tests/nested/if_unset_nested_in_if_unset.js 
    assert_success
    assert_output '2'
}

@test "If-unset nested in if-unset: unsatisfied, unsatisfied" {
    run .build/debug/jxapp -E JXAPP_TEST -E JXAPP_SECOND_TEST Tests/nested/if_unset_nested_in_if_unset.js 
    assert_success
    assert_output '1'
}

@test "Three levels set, set, set" {
    run .build/debug/jxapp \
        -e JXAPP_TEST \
        -e JXAPP_SECOND_TEST \
        -e JXAPP_THIRD_TEST \
        Tests/nested/three_levels.js
    assert_success
    assert_output '1'
}

@test "Three levels set, set, unset" {
    run .build/debug/jxapp \
        -e JXAPP_TEST \
        -e JXAPP_SECOND_TEST \
        -E JXAPP_THIRD_TEST \
        Tests/nested/three_levels.js
    assert_success
    assert_output '2'
}

@test "Three levels set, unset, set" {
    run .build/debug/jxapp \
        -e JXAPP_TEST \
        -E JXAPP_SECOND_TEST \
        -e JXAPP_THIRD_TEST \
        Tests/nested/three_levels.js
    assert_success
    assert_output '3'
}

@test "Three levels set, unset, unset" {
    run .build/debug/jxapp \
        -e JXAPP_TEST \
        -E JXAPP_SECOND_TEST \
        -E JXAPP_THIRD_TEST \
        Tests/nested/three_levels.js
    assert_success
    assert_output '4'
}

@test "Three levels unset, set, set" {
    run .build/debug/jxapp \
        -E JXAPP_TEST \
        -e JXAPP_SECOND_TEST \
        -e JXAPP_THIRD_TEST \
        Tests/nested/three_levels.js
    assert_success
    assert_output '5'
}

@test "Three levels unset, set, unset" {
    run .build/debug/jxapp \
        -E JXAPP_TEST \
        -e JXAPP_SECOND_TEST \
        -E JXAPP_THIRD_TEST \
        Tests/nested/three_levels.js
    assert_success
    assert_output '6'
}

@test "Three levels unset, unset, set" {
    run .build/debug/jxapp \
        -E JXAPP_TEST \
        -E JXAPP_SECOND_TEST \
        -e JXAPP_THIRD_TEST \
        Tests/nested/three_levels.js
    assert_success
    assert_output '7'
}

@test "Three levels unset, unset, unset" {
    run .build/debug/jxapp \
        -E JXAPP_TEST \
        -E JXAPP_SECOND_TEST \
        -E JXAPP_THIRD_TEST \
        Tests/nested/three_levels.js
    assert_success
    assert_output '8'
}
