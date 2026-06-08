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

All ArkTS async operations must use `async/await` — never `.then()/.catch()` chains. When modifying existing code that uses `.then()/.catch()`, rewrite it to async-await. Example: `PasteboardModel.ets` currently has `.then()/.catch()` in `handleUniformData` and `pasteDatatimelate`; these should be refactored to async-await when touched.

### Pasteboard getData: must authorize before calling

`systemPasteboard.getData()` must never be called without confirming user authorization first. The authorization flow:
1. Check `systemPasteboard.hasData()` and `getChangeCount()` to determine if permission is needed
2. If needed, call `abilityAccessCtrl.AtManager.requestPermissionsFromUser()` with `ohos.permission.READ_PASTEBOARD`
3. Only call `getData()` after user grants permission (`authResults === 0`)

See `Index.ets` `isNeedGetPermissionFromUser()` and the paste button `onClick` handler for the reference implementation.

### Pasteboard setData: must clear historical data after use

The pasteboard `setData()` (Set) API persists data in the clipboard — once written, the data remains until explicitly removed. This means historical data from previous `setData` calls can interfere with subsequent read/verify operations (e.g., `getData()` may return stale data instead of the newly set value). To avoid this:

1. After each `setData()` call completes and its result has been verified/read, immediately call `systemPasteboard.clear()` to remove the data from the clipboard
2. Never leave test or demo data lingering in the clipboard between different `setData` sequences
3. If a function performs multiple `setData` → `getData` round-trips, call `clear()` between each round-trip to ensure isolation

This applies especially to test scenarios and sequential demo operations where leftover clipboard content would corrupt expected results.

## Code Style

- Source files use `.ets` extension (ArkTS)
- Copyright header: Apache 2.0, Huawei Device Co., Ltd.
- Linter config: `code-linter.json5` — targets `**/*.ets`, ignores test/mock/build dirs; enforces security rules (no unsafe AES/3DES/hash/RSA/DSA/DH/ECDSA)
- Logging: use `hilog` from `@kit.PerformanceAnalysisKit` — never use `console` for logging; always use `hilog` instead. Never log pasteboard data content in plaintext (security requirement)
- Comments: prefer inline comments (`// `) over block comments; format is double-slash followed by a space then the comment text
- Spelling: strictly check spelling in all code and comments; fix any spelling errors found in existing code immediately

## Testing

- Framework: `@ohos/hypium` (unit) + `@ohos/hamock` (mock)
- Unit tests: `entry/src/test/List.test.ets` → `LocalUnit.test.ets`
- Instrumented tests: `entry/src/ohosTest/ets/test/List.test.ets` → `Ability.test.ets`
- Manual test cases documented in `ohosTest.md`