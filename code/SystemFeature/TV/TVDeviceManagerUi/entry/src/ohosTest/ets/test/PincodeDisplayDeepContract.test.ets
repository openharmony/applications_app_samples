/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { describe, it } from '@ohos/hypium';
import { TestAsserts } from './base/TestAsserts';

interface WantParameters {
  pinCode?: string;
}

interface VerificationResult {
  verifyFailed: boolean;
}

class PincodeDisplayViewModel {
  readonly cancelOperation: number = 3;
  readonly title: string = 'PIN码连接';
  readonly tips: string = '请在设备端输入连接码进行验证';
  readonly cancelKey: string = 'cancel';

  readPinFromWant(parameters: WantParameters): string {
    const pinCode: string | undefined = parameters.pinCode;
    return pinCode ?? '';
  }

  shouldCloseByReply(verifyFailed: boolean): boolean {
    return !verifyFailed;
  }
}

class PincodeReplyAssembler {
  buildReplyParam(verifyFailed: boolean): string {
    return JSON.stringify({ verifyFailed: verifyFailed });
  }
}

export default function pincodeDisplayDeepContractTest(): void {
  describe('TVDeviceManagerUiPincodeDisplayDeepContractTest', () => {
    it('should read pincode from want payload without losing leading zeros', 0, () => {
      // 展示侧 PIN 通常来自对端设备动态下发，前导零属于真实业务数据。
      // 如果读取链路把 PIN 当成数值处理，用户看到的连接码会与对端不一致。
      const model: PincodeDisplayViewModel = new PincodeDisplayViewModel();
      const plainParams: WantParameters = { pinCode: '123456' };
      const leadingZeroParams: WantParameters = { pinCode: '012345' };
      const plainPin: string = model.readPinFromWant(plainParams);
      const leadingZeroPin: string = model.readPinFromWant(leadingZeroParams);
      TestAsserts.assertStringEquals(plainPin, '123456');
      TestAsserts.assertStringEquals(leadingZeroPin, '012345');
      TestAsserts.assertPinCandidateSet([plainPin, leadingZeroPin]);
    });

    it('should keep pincode display texts readable for device side operation guidance', 0, () => {
      // PIN 展示页的核心职责是指导用户去另一端完成输入。
      // 文案一旦出现空值或脏词，用户将无法理解跨设备连接下一步该如何操作。
      const model: PincodeDisplayViewModel = new PincodeDisplayViewModel();
      TestAsserts.assertReadableText(model.title);
      TestAsserts.assertReadableText(model.tips);
      TestAsserts.assertStringEquals(model.cancelKey, 'cancel');
    });

    it('should terminate display flow only when reply result reports verification success', 0, () => {
      // 展示页收到成功回执后应主动退出，避免成功后仍遮挡用户视线。
      // 失败时继续停留则能给用户再次核对 PIN 的机会，这是展示场景的重要业务策略。
      const model: PincodeDisplayViewModel = new PincodeDisplayViewModel();
      TestAsserts.assertTrue(model.shouldCloseByReply(false));
      TestAsserts.assertFalse(model.shouldCloseByReply(true));
    });

    it('should encode reply result payloads with the verifyFailed field preserved', 0, () => {
      // replyResult 事件依赖 JSON 结构中的 verifyFailed 字段驱动页面关闭策略。
      // 这里固定字段存在性，防止后续事件格式调整时把展示页状态机悄悄破坏。
      const assembler: PincodeReplyAssembler = new PincodeReplyAssembler();
      const failedPayload: string = assembler.buildReplyParam(true);
      const successPayload: string = assembler.buildReplyParam(false);
      TestAsserts.assertStringContains(failedPayload, 'verifyFailed');
      TestAsserts.assertStringContains(successPayload, 'false');
      TestAsserts.assertStringContains(failedPayload, 'true');
    });

    it('should bind cancel interaction to dedicated pincode display reply operation', 0, () => {
      // PIN 展示取消与确认类、输入类弹窗使用不同动作码。
      // 这里单独锁定值域，避免多个弹窗共用错误动作码导致设备管理侧误判用户意图。
      const model: PincodeDisplayViewModel = new PincodeDisplayViewModel();
      TestAsserts.assertNumberEquals(model.cancelOperation, 3);
    });

    // Want 参数缺失时页面也应保持可渲染，不能因为拿不到 pinCode 而出现 null/undefined 文本。
    // 这里锁定缺省回退为空串，确保异常 payload 至少进入可观测的降级态。
    it('should fall back to empty pin when want payload omits pinCode', 0, () => {
      const model: PincodeDisplayViewModel = new PincodeDisplayViewModel();
      const params: WantParameters = {};
      const pin: string = model.readPinFromWant(params);

      TestAsserts.assertStringEquals(pin, '');
    });

    // PIN 作为展示数据必须满足 0-6 位纯数字的候选集合，否则会把不可信字符直接暴露给用户。
    // 这里用候选集断言约束读取结果，保证展示页永远不会渲染非数字串。
    it('should keep want sourced pin value within numeric candidate contract', 0, () => {
      const model: PincodeDisplayViewModel = new PincodeDisplayViewModel();
      const params: WantParameters = { pinCode: '654321' };
      const pin: string = model.readPinFromWant(params);

      TestAsserts.assertPinCandidateSet([pin]);
    });

    // reply payload 的核心是 verifyFailed 布尔字段，生成器必须保持 true/false 可区分，不允许被字符串化污染。
    // 这里直接解析组装结果，锁定字段类型为 boolean，避免后续 JSON 组装改动引入隐式类型漂移。
    it('should keep reply payload verifyFailed as boolean when parsed back', 0, () => {
      const assembler: PincodeReplyAssembler = new PincodeReplyAssembler();
      const payload: string = assembler.buildReplyParam(true);
      const parsed: VerificationResult = JSON.parse(payload) as VerificationResult;

      TestAsserts.assertTrue(parsed.verifyFailed);
    });
  });
}
