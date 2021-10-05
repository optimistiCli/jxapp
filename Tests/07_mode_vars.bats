setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash

    COMPILED_JXA="$(mktemp "${BATS_TEST_TMPDIR}/compiled_jxa_XXXXXX")"
}

@test "The “JXAPP_RUNNING” environment variable is set in running mode" {
    run .build/debug/jxapp Tests/mode_vars/run_running_set.js
    assert_output 'OK'
}

@test "The JXAPP_COMPILING environment variable is unset in running mode" {
    run .build/debug/jxapp Tests/mode_vars/run_compiling_unset.js
    assert_output 'OK'
}

@test "The “JXAPP_RUNNING” environment variable is set in running mode, runtime" {
    run .build/debug/jxapp Tests/mode_vars/run_running_set_runtime.js
    assert_output 'OK'
}

@test "The JXAPP_COMPILING environment variable is unset in running mode, runtime" {
    run .build/debug/jxapp Tests/mode_vars/run_compiling_unset_runtime.js
    assert_output 'OK'
}

@test "The JXAPP_COMPILING environment variable is set in compiling mode" {
    wrapper() {
        .build/debug/jxapp -c Tests/mode_vars/compile_compiling_set.js > "$COMPILED_JXA"
    }
    run wrapper
    assert_success

    run "$OSASCRIPT" -l JavaScript "$COMPILED_JXA"
    assert_output 'OK'
}

@test "The “JXAPP_RUNNING” environment variable is unset in compiling mode" {
    wrapper() {
        .build/debug/jxapp -c Tests/mode_vars/compile_running_unset.js > "$COMPILED_JXA"
    }
    run wrapper
    assert_success

    run "$OSASCRIPT" -l JavaScript "$COMPILED_JXA"
    assert_output 'OK'
}
