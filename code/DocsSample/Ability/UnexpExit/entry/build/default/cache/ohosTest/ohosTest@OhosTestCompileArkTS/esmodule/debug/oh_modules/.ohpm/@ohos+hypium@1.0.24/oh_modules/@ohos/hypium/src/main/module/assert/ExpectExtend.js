/*
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import assertNull from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertNull&1.0.24';
import assertClose from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertClose&1.0.24';
import assertContain from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertContain&1.0.24';
import assertLess from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertLess&1.0.24';
import assertLarger from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertLarger&1.0.24';
import assertFail from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertFail&1.0.24';
import assertUndefined from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertUndefined&1.0.24';
import assertFalse from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertFalse&1.0.24';
import assertInstanceOf from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertInstanceOf&1.0.24';
import assertThrowError from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertThrowError&1.0.24';
import assertLargerOrEqual from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertLargerOrEqual&1.0.24';
import assertLessOrEqual from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertLessOrEqual&1.0.24';
import assertNaN from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertNaN&1.0.24';
import assertNegUnlimited from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertNegUnlimited&1.0.24';
import assertPosUnlimited from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertPosUnlimited&1.0.24';
import assertDeepEquals from '@normalized:N&&&@ohos/hypium/src/main/module/assert/deepEquals/assertDeepEquals&1.0.24';
import assertPromiseIsPending from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertPromiseIsPending&1.0.24';
import assertPromiseIsRejected from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertPromiseIsRejected&1.0.24';
import assertPromiseIsRejectedWith from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertPromiseIsRejectedWith&1.0.24';
import assertPromiseIsRejectedWithError from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertPromiseIsRejectedWithError&1.0.24';
import assertPromiseIsResolved from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertPromiseIsResolved&1.0.24';
import assertPromiseIsResolvedWith from '@normalized:N&&&@ohos/hypium/src/main/module/assert/assertPromiseIsResolvedWith&1.0.24';
class ExpectExtend {
    constructor(attr) {
        this.id = attr.id;
        this.matchers = {};
    }

    extendsMatchers() {
        this.matchers.assertNull = assertNull;
        this.matchers.assertClose = assertClose;
        this.matchers.assertContain = assertContain;
        this.matchers.assertLess = assertLess;
        this.matchers.assertLarger = assertLarger;
        this.matchers.assertFail = assertFail;
        this.matchers.assertUndefined = assertUndefined;
        this.matchers.assertFalse = assertFalse;
        this.matchers.assertInstanceOf = assertInstanceOf;
        this.matchers.assertThrowError = assertThrowError;
        this.matchers.assertLargerOrEqual = assertLargerOrEqual;
        this.matchers.assertLessOrEqual = assertLessOrEqual;
        this.matchers.assertNaN = assertNaN;
        this.matchers.assertNegUnlimited = assertNegUnlimited;
        this.matchers.assertPosUnlimited = assertPosUnlimited;
        this.matchers.assertDeepEquals = assertDeepEquals;
        this.matchers.assertPromiseIsPending = assertPromiseIsPending;
        this.matchers.assertPromiseIsRejected = assertPromiseIsRejected;
        this.matchers.assertPromiseIsRejectedWith = assertPromiseIsRejectedWith;
        this.matchers.assertPromiseIsRejectedWithError = assertPromiseIsRejectedWithError;
        this.matchers.assertPromiseIsResolved = assertPromiseIsResolved;
        this.matchers.assertPromiseIsResolvedWith = assertPromiseIsResolvedWith;
    }

    init(coreContext) {
        this.coreContext = coreContext;
        this.extendsMatchers();
        const expectService = this.coreContext.getDefaultService('expect');
        expectService.addMatchers(this.matchers);
    }

    apis() {
        return {
            'expect': function (actualValue) {
                return this.coreContext.getDefaultService('expect').expect(actualValue);
            }
        };
    }
}

export default ExpectExtend;
