/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { describe, it, expect, beforeAll, afterAll, TestType, Size, Level } from '@ohos/hypium';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';
import hilog from '@ohos.hilog';

class Logger {
  private domain: number = 0xFF00;
  private prefix: string = '[Sample_StartAbility]';
  private format: string = '%{public}s';

  debug(tag: string, message: string): void {
    hilog.debug(this.domain, this.prefix, this.format, `${tag}: ${message}`);
  }

  info(tag: string, message: string): void {
    hilog.info(this.domain, this.prefix, this.format, `${tag}: ${message}`);
  }

  warn(tag: string, message: string): void {
    hilog.warn(this.domain, this.prefix, this.format, `${tag}: ${message}`);
  }

  error(tag: string, message: string): void {
    hilog.error(this.domain, this.prefix, this.format, `${tag}: ${message}`);
  }
}

const logger = new Logger();

const BUNDLE_NAME: string = 'com.samples.startability';
const ABILITY_NAME: string = 'StartAbilityEntry';

// define delay time interface
interface DelayTimes {
  SHORT: number;
  MEDIUM: number;
  LONG: number;
  PAGE_LOAD: number;
  PANEL_WAIT: number;
  INIT: number;
}

// define delay time constants (unit: milliseconds)
const DELAY: DelayTimes = {
  SHORT: 500,        // short delay
  MEDIUM: 1000,      // medium delay
  LONG: 2000,        // long delay
  PAGE_LOAD: 3000,   // page load delay
  PANEL_WAIT: 3000,  // panel wait delay
  INIT: 1000,        // initialization delay
};

async function findComponentByContains(driver: Driver, text: string): Promise<Component | null> {
  try {
    return await driver.findComponent(ON.text(text, MatchPattern.CONTAINS));
  } catch (error) {
    return null;
  }
}

// Helper function to get string from resource
async function getStringFromResource(resource: Resource): Promise<string> {
  try {
    const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    const manager = abilityDelegator.getAppContext().resourceManager;
    return await manager.getStringValue(resource);
  } catch (error) {
    logger.error('getStringFromResource', `Failed to get string from resource: ${JSON.stringify(error)}`);
    return '';
  }
}

export default function abilityTest() {
  describe('abilityTest', () => {
    let driver: Driver;

    beforeAll(async () => {
      driver = Driver.create();
      await driver.delayMs(DELAY.INIT);

      logger.info('TestSetup', 'start APP...');
      try {
        const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
        const want: Want = {
          bundleName: BUNDLE_NAME,
          abilityName: ABILITY_NAME
        };
        await abilityDelegator.startAbility(want);
        logger.info('TestSetup', 'start app success');
      } catch (error) {
        logger.warn('TestSetup', 'app is running');
      }

      await driver.delayMs(DELAY.PAGE_LOAD);
    });

    afterAll(async () => {
      await driver.delayMs(DELAY.MEDIUM);
      logger.info('TestCleanup', 'Test is over');
    });

    /**
     * @tc.number  : test_application_launch
     * @tc.name    : test_application_launch
     * @tc.desc    : test app launch
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_application_launch', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_application_launch', 'Verify application startup');

      const mainButton = await driver.findComponent(ON.text('Navigation'));
      expect(mainButton != null).assertTrue();
      logger.info('test_application_launch', 'Application startup verification passed.');

      done();
    });

    /**
     * @tc.number  : test_all_buttons_exist
     * @tc.name    : test_all_buttons_exist
     * @tc.desc    : Test whether all buttons exist.
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_all_buttons_exist', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_all_buttons_exist', 'Check all buttons');

      const buttonTexts: string[] = [
        'Navigation', 'Email', 'Finance', 'Emailto',
        'Flight', 'Express', 'File', 'PhotoEdit'
      ];

      for (const buttonText of buttonTexts) {
        const button = await driver.findComponent(ON.text(buttonText));
        expect(button != null).assertTrue();
        logger.info('ButtonsCheck', `Locate the button: ${buttonText}`);
      }

      logger.info('test_all_buttons_exist', 'All buttons have been checked.');
      done();
    });

    /**
     * @tc.number  : test_navigation_function
     * @tc.name    : test_all_buttons_exist
     * @tc.desc    : Test whether all buttons exist.
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_navigation_function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_navigation_function', 'Test the navigation function');

      const navButton = await driver.findComponent(ON.text('Navigation'));
      expect(navButton != null).assertTrue();
      await navButton.click();
      await driver.delayMs(DELAY.LONG);

      // check hideAbility text
      const hideAbilityText = await driver.findComponent(ON.text('hideAbility'));
      expect(hideAbilityText != null).assertTrue();
      await hideAbilityText.click();
      await driver.delayMs(DELAY.PANEL_WAIT);

      // check application selection panel
      const openWithText = await getStringFromResource($r('app.string.OpenType_label'));
      const choiceText = await getStringFromResource($r('app.string.Choice_label'));
      const navigationText = await getStringFromResource($r('app.string.Navigation_label'));

      const panel = await findComponentByContains(driver, openWithText) ||
        await findComponentByContains(driver, choiceText) ||
        await findComponentByContains(driver, 'Just once') ||
        await findComponentByContains(driver, navigationText);
      expect(panel != null).assertTrue();
      logger.info('test_navigation_function', 'Application selection panel called successfully.');

      // return back to main page
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);

      logger.info('test_navigation_function', 'Navigation function test completed.');
      done();
    });

    /**
     * @tc.number  : test_mail_function
     * @tc.name    : test_mail_function
     * @tc.desc    : Test whether the mail function works.
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_mail_function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_mail_function', 'Test the mail function.');

      const mailButton = await driver.findComponent(ON.text('Email'));
      expect(mailButton != null).assertTrue();
      await mailButton.click();
      await driver.delayMs(DELAY.LONG);

      // check hideAbility text
      const hideAbilityText = await driver.findComponent(ON.text('hideAbility'));
      expect(hideAbilityText != null).assertTrue();
      await hideAbilityText.click();
      await driver.delayMs(DELAY.PANEL_WAIT);

      // check application selection panel
      const openWithText = await getStringFromResource($r('app.string.OpenType_label'));
      const choiceText = await getStringFromResource($r('app.string.Choice_label'));
      const mailText = await getStringFromResource($r('app.string.Mail_label'));
      const otherAppsText = await getStringFromResource($r('app.string.other_apps'));

      const hasPanel = await findComponentByContains(driver, openWithText) ||
        await findComponentByContains(driver, choiceText) ||
        await findComponentByContains(driver, mailText) ||
        await findComponentByContains(driver, otherAppsText);
      expect(hasPanel != null).assertTrue();
      logger.info('test_mail_function', 'Mail function panel called successfully.');

      // return
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);

      logger.info('test_mail_function', 'Mail function test completed.');
      done();
    });

    /**
     * @tc.number  : test_finance_function
     * @tc.name    : test_finance_function
     * @tc.desc    : Test whether the finance function works.
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_finance_function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_finance_function', 'Test the finance function.');

      const financeButton = await driver.findComponent(ON.text('Finance'));
      expect(financeButton != null).assertTrue();
      await financeButton.click();
      await driver.delayMs(DELAY.LONG);

      // check hideAbility text
      const hideAbilityText = await driver.findComponent(ON.text('hideAbility'));
      expect(hideAbilityText != null).assertTrue();
      await hideAbilityText.click();
      await driver.delayMs(DELAY.PANEL_WAIT);

      // check application selection panel
      const openWithText = await getStringFromResource($r('app.string.OpenType_label'));
      const choiceText = await getStringFromResource($r('app.string.Choice_label'));
      const financeText = await getStringFromResource($r('app.string.FinanceAbility_label'));
      const otherAppsText = await getStringFromResource($r('app.string.other_apps'));

      const hasPanel = await findComponentByContains(driver, openWithText) ||
        await findComponentByContains(driver, choiceText) ||
        await findComponentByContains(driver, financeText) ||
        await findComponentByContains(driver, otherAppsText);
      expect(hasPanel != null).assertTrue();
      logger.info('test_finance_function', 'Finance function panel called successfully.');

      // return
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);

      logger.info('test_finance_function', 'Finance function test completed.');
      done();
    });

    /**
     * @tc.number  : test_mailto_function
     * @tc.name    : test_mailto_function
     * @tc.desc    : Test whether the mailto function works.
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_mailto_function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_mailto_function', 'Test the mailto function.');

      const mailtoButton = await driver.findComponent(ON.text('Emailto'));
      expect(mailtoButton != null).assertTrue();
      await mailtoButton.click();
      await driver.delayMs(DELAY.LONG);

      const feedbackButton = await driver.findComponent(ON.text('feedback'));
      expect(feedbackButton != null).assertTrue();
      if (feedbackButton != null) {
        logger.info('test_mailto_function', 'Feedback button found, directly return to the home page.');
        // return to the home page
        await driver.pressBack();
        await driver.delayMs(DELAY.MEDIUM);
      } else {
        const hideAbilityText = await driver.findComponent(ON.text('hideAbility'));
        if (hideAbilityText != null) {
          logger.warn('test_mailto_function', 'Mailto function is not the expected behavior.');
          await hideAbilityText.click();
          await driver.delayMs(DELAY.LONG);
          await driver.pressBack();
          await driver.delayMs(DELAY.MEDIUM);
        }
        await driver.pressBack();
        await driver.delayMs(DELAY.MEDIUM);
      }

      logger.info('test_mailto_function', 'Mailto function test completed.');
      done();
    });

    /**
     * @tc.number  : test_flight_function
     * @tc.name    : test_flight_function
     * @tc.desc    : Test whether the flight function works.
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_flight_function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_flight_function', 'Test the flight function.');

      const flightButton = await driver.findComponent(ON.text('Flight'));
      expect(flightButton != null).assertTrue();
      await flightButton.click();
      await driver.delayMs(DELAY.LONG);

      // locate hideAbility text
      const hideAbilityText = await driver.findComponent(ON.text('hideAbility'));
      expect(hideAbilityText != null).assertTrue();
      await hideAbilityText.click();
      await driver.delayMs(DELAY.PANEL_WAIT);

      // locate flight function panel
      const openWithText = await getStringFromResource($r('app.string.OpenType_label'));
      const choiceText = await getStringFromResource($r('app.string.Choice_label'));
      const flightText = await getStringFromResource($r('app.string.FlightAbility_label'));
      const otherAppsText = await getStringFromResource($r('app.string.other_apps'));

      const hasPanel = await findComponentByContains(driver, openWithText) ||
        await findComponentByContains(driver, choiceText) ||
        await findComponentByContains(driver, flightText) ||
        await findComponentByContains(driver, otherAppsText);
      expect(hasPanel != null).assertTrue();
      logger.info('test_flight_function', 'Flight function panel call success.');

      // return to the main page
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);

      logger.info('test_flight_function', 'Flight function test completed.');
      done();
    });

    /**
     * @tc.number  : test_express_function
     * @tc.name    : test_express_function
     * @tc.desc    : Test whether the express function works.
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_express_function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_express_function', 'Test the express function.');

      const expressButton = await driver.findComponent(ON.text('Express'));
      expect(expressButton != null).assertTrue();
      await expressButton.click();
      await driver.delayMs(DELAY.LONG);

      // locate hideAbility text
      const hideAbilityText = await driver.findComponent(ON.text('hideAbility'));
      expect(hideAbilityText != null).assertTrue();
      await hideAbilityText.click();
      await driver.delayMs(DELAY.PANEL_WAIT);

      // locate express function panel
      const openWithText = await getStringFromResource($r('app.string.OpenType_label'));
      const choiceText = await getStringFromResource($r('app.string.Choice_label'));
      const expressText = await getStringFromResource($r('app.string.ExpressAbility_label'));
      const otherAppsText = await getStringFromResource($r('app.string.other_apps'));

      const hasPanel = await findComponentByContains(driver, openWithText) ||
        await findComponentByContains(driver, choiceText) ||
        await findComponentByContains(driver, expressText) ||
        await findComponentByContains(driver, otherAppsText);
      expect(hasPanel != null).assertTrue();
      logger.info('test_express_function', 'Express function panel call success.');

      // return to the main page
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);

      logger.info('test_express_function', 'Express function test completed.');
      done();
    });

    /**
     * @tc.number  : test_file_function
     * @tc.name    : test_file_function
     * @tc.desc    : Test whether the file function works.
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_file_function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_file_function', 'Test the file function.');

      const fileButton = await driver.findComponent(ON.text('File'));
      expect(fileButton != null).assertTrue();
      await fileButton.click();
      await driver.delayMs(DELAY.LONG);

      // locate hideAbility text
      const hideAbilityText = await driver.findComponent(ON.text('hideAbility'));
      expect(hideAbilityText != null).assertTrue();
      await hideAbilityText.click();
      await driver.delayMs(DELAY.PANEL_WAIT);

      // locate file function panel
      const openWithText = await getStringFromResource($r('app.string.OpenType_label'));
      const choiceText = await getStringFromResource($r('app.string.Choice_label'));
      const fileText = await getStringFromResource($r('app.string.FileAbility_label'));
      const otherAppsText = await getStringFromResource($r('app.string.other_apps'));

      const hasPanel = await findComponentByContains(driver, openWithText) ||
        await findComponentByContains(driver, choiceText) ||
        await findComponentByContains(driver, fileText) ||
        await findComponentByContains(driver, otherAppsText);
      expect(hasPanel != null).assertTrue();
      logger.info('test_file_function', 'File function panel call success.');

      // return to the main page
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);

      logger.info('test_file_function', 'File function test completed.');
      done();
    });

    /**
     * @tc.number  : test_photo_editor_function
     * @tc.name    : test_photo_editor_function
     * @tc.desc    : Test whether the photo editor function works.
     * @tc.level   : Level0
     * @tc.size    : SmallTest
     * @tc.type    : Function
     */
    it('test_photo_editor_function', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      logger.info('test_photo_editor_function', 'Test the photo editor function');

      const photoButton = await driver.findComponent(ON.text('PhotoEdit'));
      expect(photoButton != null).assertTrue();
      await photoButton.click();
      await driver.delayMs(DELAY.LONG);

      // locate selectimg and editimg button
      const selectImgText = await getStringFromResource($r('app.string.select_img'));
      const editImgText = await getStringFromResource($r('app.string.edit_img'));

      const selectImgButton = await driver.findComponent(ON.text(selectImgText));
      const editImgButton = await driver.findComponent(ON.text(editImgText));

      expect(selectImgButton != null).assertTrue();
      expect(editImgButton != null).assertTrue();
      logger.info('PhotoEditorTest', 'locate selectimg and editimg button successfully');

      // return to the main page
      await driver.pressBack();
      await driver.delayMs(DELAY.MEDIUM);

      logger.info('test_photo_editor_function', 'Photo editor function test completed.');
      done();
    });
  });
}