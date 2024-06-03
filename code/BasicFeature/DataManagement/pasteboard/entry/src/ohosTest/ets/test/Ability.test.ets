import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_pasteboard]';
const DOMAIN = 0xF811;
const BUNDLE = 'pasteboard_';
const NUMBER = 22;

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

// function getContent(): string {
//   let content = 'abcdefghijklmnopqrstuvwxyz';
//   let fileContent = content.repeat(NUMBER);
//   return fileContent;
// }

export default function abilityTest() {
  describe('PasteboardTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    // it('assertContain', 0, () => {
    //   // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
    //   hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
    //   let a = 'abc';
    //   let b = 'b';
    //   // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
    //   expect(a).assertContain(b);
    //   expect(a).assertEqual(a);
    // })


  it('StartAbilityFunction_001', 0, async () => {
    hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
    let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    try {
      await abilityDelegator.startAbility({
        bundleName: "com.samples.pasteboard",
        abilityName: "EntryAbility"
      });
      // done();
    } catch (err) {
      expect(err.code).assertEqual(0);
      // done();
    }
    hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
  })

  /**
   * pasteboard 赋权限
   */
  // 点击允许
  it('RequestPermissionFunction_001', 0, async () => {
    hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
    let driver = await Driver.create();
    await driver.delayMs(2000);
    // let permit: string = await getResourceString($r('app.string.permit'));
    // let permit: string = $r('app.string.permit');
    // await driver.assertComponentExist(ON.text(permit));
    await driver.assertComponentExist(ON.text('仅本次允许', MatchPattern.CONTAINS));
    let permit = await driver.findComponent(ON.text('仅本次允许', MatchPattern.CONTAINS));
    await permit.click();
    hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 click');

    // let permit1 = await driver.findComponent(ON.text(permit));
    // await permit1.click();
    await driver.delayMs(500);
    // let permit2 = await driver.findComponent(ON.text(permit));
    // await permit2.click();
    // await driver.delayMs(200);
    // done();

    // await driver.assertComponentExist(ON.id('pasteTextArea'));
    // let inputTextArea = await driver.findComponent(ON.id('pasteTextArea'));
    // await inputTextArea.click();
    // await inputTextArea.clearText();

    hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
  })

    // 点击复制
    it('copy_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'copy_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(2000);
      // let permit: string = await getResourceString($r('app.string.permit'));
      // let permit: string = $r('app.string.permit');
      // await driver.assertComponentExist(ON.text(permit));

      // await driver.delayMs(1000);
      // await driver.assertComponentExist(ON.type('List'));
      // let list = await driver.findComponent(ON.type('List'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'copy_001 11');
      // await driver.assertComponentExist(ON.type('TextArea'));
      // let inputTextArea = await driver.findComponent(ON.type('TextArea'));

      await driver.assertComponentExist(ON.id('pasteTextArea'));
      let inputTextArea = await driver.findComponent(ON.id('pasteTextArea'));
      await inputTextArea.click();
      await inputTextArea.clearText();

      hilog.info(DOMAIN, TAG, BUNDLE + 'copy_001 aa');

      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('a', MatchPattern.CONTAINS));
      let inputTextA = await driver.findComponent(ON.text('a', MatchPattern.CONTAINS));
      await inputTextA.click();

      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('b', MatchPattern.CONTAINS));
      let inputTextB = await driver.findComponent(ON.text('b', MatchPattern.CONTAINS));
      await inputTextB.click();


      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('c', MatchPattern.CONTAINS));
      let inputTextC = await driver.findComponent(ON.text('c', MatchPattern.CONTAINS));
      await inputTextC.click();

      await driver.click(670, 700); // 点击收起软键盘

      let copy: string = await getResourceString($r('app.string.Button_copy'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'copy_001 copy: ' + copy);
      // let permit: string = $r('app.string.permit');
      // await driver.assertComponentExist(ON.text(permit));

      await driver.assertComponentExist(ON.text(copy, MatchPattern.CONTAINS));
      let inputText = await driver.findComponent(ON.text(copy, MatchPattern.CONTAINS));
      await inputText.click();

      // let permit1 = await driver.findComponent(ON.text(permit));
      // await permit1.click();
      await driver.delayMs(200);
      // let permit2 = await driver.findComponent(ON.text(permit));
      // await permit2.click();
      // await driver.delayMs(200);
      // done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'copy_001 end');
    })

    // 点击粘贴
    it('paste_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(2000);
      // let permit: string = await getResourceString($r('app.string.permit'));
      // let permit: string = $r('app.string.permit');
      // await driver.assertComponentExist(ON.text(permit));

      // await driver.delayMs(1000);
      // await driver.assertComponentExist(ON.type('List'));
      // let list = await driver.findComponent(ON.type('List'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_001 11');
      // await driver.assertComponentExist(ON.type('TextArea'));
      // let inputTextArea = await driver.findComponent(ON.type('TextArea'));

      let paste: string = await getResourceString($r('app.string.Button_paste'));
      // hilog.info(DOMAIN, TAG, BUNDLE + 'paste_001 paste: ' + paste);
      // let permit: string = $r('app.string.permit');
      // await driver.assertComponentExist(ON.text(permit));

      await driver.assertComponentExist(ON.text(paste, MatchPattern.CONTAINS));
      let inputText = await driver.findComponent(ON.text(paste, MatchPattern.CONTAINS));
      await inputText.click();

      await driver.assertComponentExist(ON.id('pasteTextArea'));
      let inputTextArea = await driver.findComponent(ON.id('pasteTextArea'));
      let inputString = await inputTextArea.getText();
      expect(inputString === 'abc').assertTrue();



      // let permit1 = await driver.findComponent(ON.text(permit));
      // await permit1.click();
      await driver.delayMs(200);
      // let permit2 = await driver.findComponent(ON.text(permit));
      // await permit2.click();
      // await driver.delayMs(200);
      // done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_001 end');
    })

    // 点击安全粘贴
    it('paste_security_text_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_security_text_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(2000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_security_text_001 11');

      // let paste: string = await getResourceString($r('app.string.Button_text_paste'));
      await driver.assertComponentExist(ON.type('PasteButton'));
      let inputText = await driver.findComponent(ON.type('PasteButton'));
      await inputText.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_security_text_001 22');

      await driver.assertComponentExist(ON.id('pasteTextArea'));
      let inputTextArea = await driver.findComponent(ON.id('pasteTextArea'));
      let inputString = await inputTextArea.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 inputString: ' + inputString);
      expect(inputString === 'abc').assertTrue();

      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_security_text_001 end');
    })

    // 点击粘贴文本
    it('paste_text_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(2000);

      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 11');

      // let paste: string = await getResourceString($r('app.string.Button_text_paste'));
      // hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 paste: ' + paste);

      // await driver.assertComponentExist(ON.id(paste, MatchPattern.CONTAINS));
      // let inputText = await driver.findComponent(ON.text(paste, MatchPattern.CONTAINS));
      await driver.assertComponentExist(ON.id('textPaste'));
      let inputText = await driver.findComponent(ON.id('textPaste'));
      await inputText.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 22');

      await driver.assertComponentExist(ON.id('pasteTextArea'));
      let inputTextArea = await driver.findComponent(ON.id('pasteTextArea'));
      let inputString = await inputTextArea.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 inputString: ' + inputString);
      expect(inputString === 'abc').assertTrue();

      await driver.delayMs(200);
      hilog.info(DOMAIN, TAG, BUNDLE + 'paste_text_001 end');
    })
  })
}