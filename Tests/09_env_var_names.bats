setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash
}

@test "Set strict var, normal rule" {
    run .build/debug/jxapp Tests/env_var_names/set_strict.js
    assert_output 'OK'
}

@test "Set strict var, strict rule" {
    run .build/debug/jxapp -N Tests/env_var_names/set_strict.js
    assert_output 'OK'
}

@test "Set strict var, relaxed rule" {
    run .build/debug/jxapp -n Tests/env_var_names/set_strict.js
    assert_output 'OK'
}

@test "Unset strict var, normal rule" {
    STRICT_VAR_001=1 run .build/debug/jxapp Tests/env_var_names/unset_strict.js
    assert_output 'OK'
}

@test "Unset strict var, strict rule" {
    STRICT_VAR_001=1 run .build/debug/jxapp -N Tests/env_var_names/unset_strict.js
    assert_output 'OK'
}

@test "Unset strict var, relaxed rule" {
    STRICT_VAR_001=1 run .build/debug/jxapp -n Tests/env_var_names/unset_strict.js
    assert_output 'OK'
}

@test "Set normal var, normal rule" {
    run .build/debug/jxapp Tests/env_var_names/set_normal.js
    assert_output 'OK'
}

@test "Set normal var, strict rule" {
    run .build/debug/jxapp -N Tests/env_var_names/set_normal.js
    assert_failure
}

@test "Set normal var, relaxed rule" {
    run .build/debug/jxapp -n Tests/env_var_names/set_normal.js
    assert_output 'OK'
}

@test "Unset normal var, normal rule" {
    StrictVar_001=1 run .build/debug/jxapp Tests/env_var_names/unset_normal.js
    assert_output 'OK'
}

@test "Unset normal var, strict rule" {
    StrictVar_001=1 run .build/debug/jxapp -N Tests/env_var_names/unset_normal.js
    assert_failure
}

@test "Unset normal var, relaxed rule" {
    StrictVar_001=1 run .build/debug/jxapp -n Tests/env_var_names/unset_normal.js
    assert_output 'OK'
}

@test "Set relaxed var, normal rule" {
    run .build/debug/jxapp Tests/env_var_names/set_relaxed.js
    assert_failure
}

@test "Set relaxed var, strict rule" {
    run .build/debug/jxapp -N Tests/env_var_names/set_relaxed.js
    assert_failure
}

@test "Set relaxed var, relaxed rule" {
    run .build/debug/jxapp -n Tests/env_var_names/set_relaxed.js
    assert_output 'OK'
}

@test "Unset relaxed var, normal rule" {
    STRICT_VAR_001=1 run .build/debug/jxapp Tests/env_var_names/unset_relaxed.js
    assert_failure
}

@test "Unset relaxed var, strict rule" {
    STRICT_VAR_001=1 run .build/debug/jxapp -N Tests/env_var_names/unset_relaxed.js
    assert_failure
}

@test "Unset relaxed var, relaxed rule" {
    STRICT_VAR_001=1 run .build/debug/jxapp -n Tests/env_var_names/unset_relaxed.js
    assert_output 'OK'
}
