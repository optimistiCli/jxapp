setup() {
    load Library/bats-assert/load.bash
    load Library/bats-support/load.bash
    load Tests/common.bash

    COMPILED_JXA="$(mktemp "${BATS_TEST_TMPDIR}/compiled_jxa_XXXXXX")"
    CUSTOM_SHEBANG="$OSASCRIPT -l JavaScript"
}

@test "Include with shebang runs" {
    run .build/debug/jxapp Tests/shebang_handling/outer.js
    assert_output 'OK'
}

@test "All shebangs are removed by default" {
    wrapper() {
        .build/debug/jxapp -c Tests/shebang_handling/outer.js | grep -c '^#!' 2>/dev/null
    }
    run wrapper
    assert_output '0'
}

@test "Compiled runs by default" {
    wrapper() {
        .build/debug/jxapp -c Tests/shebang_handling/outer.js | "$OSASCRIPT" -l JavaScript
    }
    run wrapper
    assert_output 'OK'
}

compile_with_default_shebang() {
    .build/debug/jxapp -c -s Tests/shebang_handling/outer.js > "$COMPILED_JXA"
}

@test "Compiling with default shebang works" {
    run compile_with_default_shebang
    assert_success
}

@test "Compiled with default shebang has 1 shebang" {
    compile_with_default_shebang
    wrapper() {
        grep -c '^#!' "$COMPILED_JXA" 2>/dev/null
    }
    run wrapper
    assert_output '1'
}

@test "Compiled with default shebang starts with expected shebang" {
    compile_with_default_shebang
    wrapper() {
        head -n 1 "$COMPILED_JXA" | grep -c '^#!/usr/bin/env osascript -l JavaScript[[:blank:]]*$' 2>/dev/null
    }
    run wrapper
    assert_output '1'
}

@test "Compiled with default shebang runs" {
    compile_with_default_shebang
    chmod a+x "$COMPILED_JXA"
    run "$COMPILED_JXA"
    assert_output 'OK'
}

compile_keeping_main_file_shebang() {
    .build/debug/jxapp -c -k Tests/shebang_handling/outer.js > "$COMPILED_JXA"
}

@test "Compiling keeping main file shebang works" {
    run compile_keeping_main_file_shebang
    assert_success
}

@test "Compiled keeping main file shebang has 1 shebang" {
    compile_keeping_main_file_shebang
    wrapper() {
        grep -c '^#!' "$COMPILED_JXA" 2>/dev/null
    }
    run wrapper
    assert_output '1'
}

@test "Compiled keeping main file shebang starts with expected shebang" {
    compile_keeping_main_file_shebang
    wrapper() {
        head -n 1 "$COMPILED_JXA" | grep -c '^#!/usr/bin/env jxapp[[:blank:]]*$' 2>/dev/null
    }
    run wrapper
    assert_output '1'
}

@test "Compiled keeping main file shebang runs" {
    compile_keeping_main_file_shebang
    chmod a+x "$COMPILED_JXA"
    run "$COMPILED_JXA"
    assert_output 'OK'
}

compile_with_custom_shebang() {
    .build/debug/jxapp -c -S "$CUSTOM_SHEBANG" Tests/shebang_handling/outer.js > "$COMPILED_JXA"
}

@test "Compiling with custom shebang works" {
    run compile_with_custom_shebang
    assert_success
}

@test "Compiled with custom shebang has 1 shebang" {
    compile_with_custom_shebang
    wrapper() {
        grep -c '^#!' "$COMPILED_JXA" 2>/dev/null
    }
    run wrapper
    assert_output '1'
}

@test "Compiled with custom shebang starts with expected shebang" {
    compile_with_custom_shebang
    wrapper() {
        head -n 1 "$COMPILED_JXA" | grep -c "^#!${CUSTOM_SHEBANG}[[:blank:]]*$" 2>/dev/null
    }
    run wrapper
    assert_output '1'
}

@test "Compiled with custom shebang runs" {
    compile_with_custom_shebang
    chmod a+x "$COMPILED_JXA"
    run "$COMPILED_JXA"
    assert_output 'OK'
}
