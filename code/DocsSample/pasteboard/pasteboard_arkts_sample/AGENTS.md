# AGENTS.md

## Project

OpenHarmony ArkTS pasteboard (clipboard) sample app — single `entry` module, API 20, SDK 6.0.0.49. Requires DevEco Studio 5.1.1+ to build/run.

## Architecture

- `entry/src/main/ets/pages/Index.ets` — UI page; handles pasteboard permission flow before reading data
- `entry/src/main/ets/pages/PasteboardModel.ets` — Business logic; exported `TestJs` namespace with pasteboard API wrappers
- `entry/src/main/ets/entryability/EntryAbility.ets` — App lifecycle entry

Required permission declared in `entry/src/main/module.json5`: `ohos.permission.READ_PASTEBOARD`

## Critical Rules

### Async style: always use async-await

All ArkTS async operations must use `async/await` — never `.then()/.catch()` chains. When modifying existing code that uses `.then()/.catch()`, rewrite it to async-await. When calling an async function, always use `await`. Calling an async function without `await` returns a Promise object instead of the actual return value, which causes incorrect control flow and logic errors.

When checking async compliance, do not only grep for `.then()/.catch()` patterns — also cross-reference all `async` function definitions with their call sites to confirm every call uses `await`.

### Pasteboard getData: must authorize before calling

`systemPasteboard.getData()` must never be called without confirming user authorization first. The authorization flow:
1. Check `systemPasteboard.hasData()` and `getChangeCount()` to determine if permission is needed
2. If needed, call `abilityAccessCtrl.AtManager.requestPermissionsFromUser()` with `ohos.permission.READ_PASTEBOARD`
3. Only call `getData()` after user grants permission (`authResults === 0`)

See `Index.ets` `isNeedGetPermissionFromUser()` and the paste button `onClick` handler for the reference implementation.

### Pasteboard getData: must clear after consuming pasteData

The pasteboard `getData()` API returns a `PasteData` object that persists in the clipboard until explicitly removed. Once the pasteData has been fully consumed (read, processed, or used), `systemPasteboard.clear()` must be called to remove it. This ensures:

1. After `getData()` returns pasteData and the data has been consumed, immediately call `systemPasteboard.clear()` to remove the data from the clipboard
2. Never leave consumed clipboard data lingering between different `getData` sequences
3. If a function performs multiple `getData` → consume → verify round-trips, call `clear()` after consuming pasteData in each round-trip to ensure isolation

This applies especially to test scenarios and sequential demo operations where leftover clipboard content would corrupt expected results.

## Code Style

- Source files use `.ets` extension (ArkTS)
- Copyright header: Apache 2.0, template text with year only. For newly created files, use the creation year (e.g., `Copyright (c) 2026 Device Co., Ltd.`). For previously created files being edited, use `creationYear-editYear` format (e.g., `Copyright (c) 2025-2026 Device Co., Ltd.`)
- Linter config: `code-linter.json5` — targets `**/*.ets`, ignores test/mock/build dirs; enforces security rules (no unsafe AES/3DES/hash/RSA/DSA/DH/ECDSA)
- Logging: use `hilog` from `@kit.PerformanceAnalysisKit` — never use `console` for logging; always use `hilog` instead
- Comments: prefer inline comments (`// `) over block comments; format is double-slash followed by a space then the comment text
- Spelling: strictly check spelling in all code and comments; fix any spelling errors found in existing code immediately

## General Code Quality Checks

When asked to check the project code against rules, do not only verify the explicitly stated rules above — also inspect for common syntax and logic issues, including but not limited to:

- Missing `await` on async function calls (causes Promise object instead of actual return value)
- Unused or unreachable code (functions defined but never called, unreachable branches)
- Incorrect control flow (conditions that always evaluate to true or false due to type coercion, e.g. `if (!asyncFunction())` where `asyncFunction` returns a Promise)
- Potential null/undefined access (using a variable before it is guaranteed to be assigned)
- Type mismatches (assigning or comparing values of incompatible types)
- Resource leaks (opening connections or acquiring resources without corresponding cleanup)

Report all findings in a single unified list, categorized by severity (logic errors > rule violations > style issues).

## Testing

- Framework: `@ohos/hypium` (unit) + `@ohos/hamock` (mock)
- Unit tests: `entry/src/test/List.test.ets` → `LocalUnit.test.ets`
- Instrumented tests: `entry/src/ohosTest/ets/test/List.test.ets` → `Ability.test.ets`
- Manual test cases documented in `ohosTest.md`