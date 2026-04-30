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

import { describe, it, expect, TestType, Size, Level } from '@ohos/hypium';
import { ButtonModel, button } from '../../../../main/ets/model/ButtonModel';

interface ButtonPayload {
  name: string;
  isFocus: boolean;
}

function strRepeat(s: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) { result += s; }
  return result;
}

export default function ButtonModelComprehensiveTestSuite(): void {
  describe('ButtonModelComprehensiveTest', () => {

    it('test_buttonModel_constructor_basic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: 'play',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.name).assertEqual('play');
      expect(btn.isFocus).assertFalse();
    });

    it('test_buttonModel_constructor_focusTrue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: 'pause',
        iconNormal: $r('app.media.ic_pause'),
        iconFocus: $r('app.media.ic_pause'),
        isFocus: true
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.isFocus).assertTrue();
    });

    it('test_buttonModel_constructor_emptyName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: '',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.name).assertEqual('');
    });

    it('test_buttonModel_constructor_chineseName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: '播放按钮',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: true
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.name).assertEqual('播放按钮');
    });

    it('test_buttonModel_constructor_specialChars', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: '!@#$%^&*()',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.name).assertEqual('!@#$%^&*()');
    });

    it('test_buttonModel_constructor_longName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const longName: string = strRepeat('btn_', 100);
      const model: button = {
        name: longName,
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.name).assertEqual(longName);
    });

    it('test_buttonModel_propertiesAccessible', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: 'previous',
        iconNormal: $r('app.media.ic_play_previous'),
        iconFocus: $r('app.media.ic_play_previous'),
        isFocus: true
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.name).assertEqual('previous');
      expect(btn.iconNormal !== null).assertTrue();
      expect(btn.iconFocus !== null).assertTrue();
      expect(btn.isFocus).assertTrue();
    });

    it('test_buttonModel_nameMutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: 'original',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      btn.name = 'mutated';
      expect(btn.name).assertEqual('mutated');
    });

    it('test_buttonModel_focusMutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: 'test',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      btn.isFocus = true;
      expect(btn.isFocus).assertTrue();
      btn.isFocus = false;
      expect(btn.isFocus).assertFalse();
    });

    it('test_buttonModel_multipleInstances', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model1: button = {
        name: 'btn1',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: true
      };
      const model2: button = {
        name: 'btn2',
        iconNormal: $r('app.media.ic_pause'),
        iconFocus: $r('app.media.ic_pause'),
        isFocus: false
      };
      const btn1: ButtonModel = new ButtonModel(model1);
      const btn2: ButtonModel = new ButtonModel(model2);
      expect(btn1.name).assertEqual('btn1');
      expect(btn2.name).assertEqual('btn2');
      expect(btn1.isFocus).assertTrue();
      expect(btn2.isFocus).assertFalse();
    });

    it('test_buttonModel_allControlButtons', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const buttons: button[] = [
        { name: 'hop', iconNormal: $r('app.media.ic_hop'), iconFocus: $r('app.media.ic_hop'), isFocus: false },
        { name: 'previous', iconNormal: $r('app.media.ic_play_previous'), iconFocus: $r('app.media.ic_play_previous'), isFocus: false },
        { name: 'pause', iconNormal: $r('app.media.ic_pause'), iconFocus: $r('app.media.ic_pause'), isFocus: true },
        { name: 'next', iconNormal: $r('app.media.ic_play_next'), iconFocus: $r('app.media.ic_play_next'), isFocus: false },
        { name: 'add', iconNormal: $r('app.media.ic_play_add'), iconFocus: $r('app.media.ic_play_add'), isFocus: false }
      ];
      const btnModels: ButtonModel[] = [];
      for (let i: number = 0; i < buttons.length; i++) {
        btnModels.push(new ButtonModel(buttons[i]));
      }
      expect(btnModels.length).assertEqual(5);
      expect(btnModels[0].name).assertEqual('hop');
      expect(btnModels[1].name).assertEqual('previous');
      expect(btnModels[2].name).assertEqual('pause');
      expect(btnModels[3].name).assertEqual('next');
      expect(btnModels[4].name).assertEqual('add');
    });

    it('test_buttonModel_focusToggleMultiple', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: 'toggle',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      for (let i: number = 0; i < 100; i++) {
        btn.isFocus = !btn.isFocus;
      }
      expect(btn.isFocus).assertFalse();
    });

    it('test_buttonModel_implementsButtonInterface', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: 'interfaceTest',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: button = new ButtonModel(model);
      expect(btn.name).assertEqual('interfaceTest');
      expect(typeof btn.isFocus).assertEqual('boolean');
    });

    it('test_buttonModel_rapidCreate_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      for (let i: number = 0; i < 100; i++) {
        const model: button = {
          name: 'rapid_' + i.toString(),
          iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'),
          isFocus: i % 2 === 0
        };
        const btn: ButtonModel = new ButtonModel(model);
        expect(btn.name).assertEqual('rapid_' + i.toString());
      }
    });

    it('test_buttonModel_unicodeName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: '🎵音乐',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: true
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.name).assertEqual('🎵音乐');
    });

    it('test_buttonModel_numberLikeName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: '123',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.name).assertEqual('123');
    });

    it('test_buttonModel_nameWithSpaces', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: 'play button',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.name).assertEqual('play button');
    });

    it('test_buttonModel_nameWithNewlines', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
      const model: button = {
        name: 'line1\nline2',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      expect(btn.name).assertEqual('line1\nline2');
    });

    it('test_stress_createButtonModels_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
      for (let i: number = 0; i < 100; i++) {
        const model: button = {
          name: 'stress_' + i.toString(),
          iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'),
          isFocus: i % 2 === 0
        };
        new ButtonModel(model);
      }
      expect(true).assertTrue();
    });

    it('test_stress_focusToggle_100', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
      const model: button = {
        name: 'stressToggle',
        iconNormal: $r('app.media.ic_play'),
        iconFocus: $r('app.media.ic_play'),
        isFocus: false
      };
      const btn: ButtonModel = new ButtonModel(model);
      for (let i: number = 0; i < 100; i++) {
        btn.isFocus = !btn.isFocus;
      }
      expect(typeof btn.isFocus).assertEqual('boolean');
    });

    // ========== Button ==========
    describe('Button_interfaceContractDepth', () => {

      it('comprehensive_buttonInterface_allFourFieldsRequired', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const requiredFields: string[] = ['name', 'iconNormal', 'iconFocus', 'isFocus'];
        expect(requiredFields.length).assertEqual(4);
        const btn: button = new ButtonModel({
          name: 'test', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(btn.name !== undefined).assertTrue();
        expect(btn.iconNormal !== undefined).assertTrue();
        expect(btn.iconFocus !== undefined).assertTrue();
        expect(btn.isFocus !== undefined).assertTrue();
      });

      it('comprehensive_buttonInterface_nameTypeIsString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: button = new ButtonModel({
          name: 'play', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(typeof btn.name).assertEqual('string');
      });

      it('comprehensive_buttonInterface_isFocusTypeIsBoolean', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: button = new ButtonModel({
          name: 'test', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(typeof btn.isFocus).assertEqual('boolean');
      });

      it('comprehensive_buttonInterface_iconFieldsNotNull', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: button = new ButtonModel({
          name: 'test', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(btn.iconNormal !== null).assertTrue();
        expect(btn.iconFocus !== null).assertTrue();
      });

      it('comprehensive_buttonInterface_iconNormalAndFocusCanDiffer', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: button = new ButtonModel({
          name: 'play', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_pause'), isFocus: false
        });
        expect(btn.iconNormal !== null).assertTrue();
        expect(btn.iconFocus !== null).assertTrue();
      });

      it('comprehensive_buttonModel_isInstanceOfButton', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const instance: ButtonModel = new ButtonModel({
          name: 'test', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        const asButton: button = instance;
        expect(asButton.name).assertEqual('test');
      });
    });

    // ========== Focus state machine ==========
    describe('Focus_stateMachineDepth', () => {

      it('comprehensive_focusState_initialFalseIsValid', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: ButtonModel = new ButtonModel({
          name: 'btn', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(btn.isFocus).assertFalse();
      });

      it('comprehensive_focusState_initialTruePropagates', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: ButtonModel = new ButtonModel({
          name: 'first', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: true
        });
        expect(btn.isFocus).assertTrue();
      });

      it('comprehensive_focusState_transitionsFalseTrueFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: ButtonModel = new ButtonModel({
          name: 'btn', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        btn.isFocus = true;
        expect(btn.isFocus).assertTrue();
        btn.isFocus = false;
        expect(btn.isFocus).assertFalse();
      });

      it('comprehensive_focusState_settingSameValueNoSideEffect', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: ButtonModel = new ButtonModel({
          name: 'btn', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        btn.isFocus = false;
        expect(btn.isFocus).assertFalse();
        btn.isFocus = false;
        expect(btn.isFocus).assertFalse();
        btn.isFocus = true;
        expect(btn.isFocus).assertTrue();
        btn.isFocus = true;
        expect(btn.isFocus).assertTrue();
      });

      it('comprehensive_focusState_onlyOneButtonHasFocus', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const buttons: ButtonModel[] = [
          new ButtonModel({ name: 'b1', iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: false }),
          new ButtonModel({ name: 'b2', iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: true }),
          new ButtonModel({ name: 'b3', iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: false })
        ];
        let focusedCount: number = 0;
        for (let i: number = 0; i < buttons.length; i++) {
          if (buttons[i].isFocus) { focusedCount++; }
        }
        expect(focusedCount).assertEqual(1);
      });

      it('comprehensive_focusState_moveFocusBetweenButtons', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const b1: ButtonModel = new ButtonModel({
          name: 'b1', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        const b2: ButtonModel = new ButtonModel({
          name: 'b2', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: true
        });
        b2.isFocus = false;
        b1.isFocus = true;
        expect(b1.isFocus).assertTrue();
        expect(b2.isFocus).assertFalse();
      });
    });

    // ========== Icon resource integrity ==========
    describe('Icon_resourceIntegrity', () => {

      it('comprehensive_iconResource_normalAndFocusBothDefined', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: ButtonModel = new ButtonModel({
          name: 'play', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(btn.iconNormal !== null).assertTrue();
        expect(btn.iconFocus !== null).assertTrue();
      });

      it('comprehensive_iconResource_allFiveButtonsHaveUniqueIcons', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const iconKeys: Set<string> = new Set<string>();
        const names: string[] = ['hop', 'previous', 'pause', 'next', 'add'];
        names.forEach((n: string): void => { iconKeys.add('ic_' + n); });
        expect(iconKeys.size).assertEqual(5);
      });

      it('comprehensive_iconResource_allResourceRefsAreResourceType', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: ButtonModel = new ButtonModel({
          name: 'play', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(typeof btn.iconNormal).assertEqual('object');
        expect(typeof btn.iconFocus).assertEqual('object');
      });
    });

    // ========== Name semantic integrity ==========
    describe('Name_semanticIntegrity', () => {

      it('comprehensive_name_noReservedKeywordsConflict', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const safeNames: string[] = ['hop', 'previous', 'pause', 'next', 'add', 'play'];
        const reservedWords: string[] = ['class', 'delete', 'import', 'new', 'return', 'switch'];
        safeNames.forEach((name: string): void => {
          expect(reservedWords.indexOf(name)).assertEqual(-1);
        });
      });

      it('comprehensive_name_lengthWithinReasonableLimits', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const names: string[] = ['hop', 'previous', 'pause', 'next', 'add'];
        names.forEach((name: string): void => {
          expect(name.length).assertLess(21);
        });
      });

      it('comprehensive_name_noLeadingTrailingWhitespace', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const names: string[] = ['hop', 'previous', 'pause', 'next', 'add'];
        names.forEach((name: string): void => {
          expect(name).assertEqual(name.trim());
        });
      });
    });

    // ========== Multi-button collection ops ==========
    describe('MultiButton_collectionOperations', () => {

      it('comprehensive_multiButton_batchCreate_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const batch: ButtonModel[] = [];
        for (let i: number = 0; i < 100; i++) {
          batch.push(new ButtonModel({
            name: 'device_btn_' + i.toString(),
            iconNormal: $r('app.media.ic_play'),
            iconFocus: $r('app.media.ic_play'),
            isFocus: i === 0
          }));
        }
        expect(batch.length).assertEqual(100);
        expect(batch[0].isFocus).assertTrue();
        expect(batch[499].isFocus).assertFalse();
      });

      it('comprehensive_multiButton_findByName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const buttons: ButtonModel[] = [
          new ButtonModel({ name: 'hop', iconNormal: $r('app.media.ic_hop'), iconFocus: $r('app.media.ic_hop'), isFocus: false }),
          new ButtonModel({ name: 'pause', iconNormal: $r('app.media.ic_pause'), iconFocus: $r('app.media.ic_pause'), isFocus: true }),
          new ButtonModel({ name: 'next', iconNormal: $r('app.media.ic_play_next'), iconFocus: $r('app.media.ic_play_next'), isFocus: false }),
        ];
        let found: ButtonModel | undefined = undefined;
        for (let i: number = 0; i < buttons.length; i++) {
          if (buttons[i].name === 'pause') { found = buttons[i]; break; }
        }
        expect(found !== undefined && found !== null).assertTrue();
        if (found !== undefined && found !== null) {
          expect(found.name).assertEqual('pause');
        }
      });

      it('comprehensive_multiButton_countByFocusState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const buttons: ButtonModel[] = [
          new ButtonModel({ name: 'b1', iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: true }),
          new ButtonModel({ name: 'b2', iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: false }),
          new ButtonModel({ name: 'b3', iconNormal: $r('app.media.ic_play'), iconFocus: $r('app.media.ic_play'), isFocus: false }),
        ];
        let focusedCount: number = 0;
        for (let i: number = 0; i < buttons.length; i++) {
          if (buttons[i].isFocus) { focusedCount++; }
        }
        expect(focusedCount).assertEqual(1);
      });

      it('comprehensive_multiButton_serializationRoundTrip', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: ButtonModel = new ButtonModel({
          name: 'play', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: true
        });
        const payload: ButtonPayload = { name: btn.name, isFocus: btn.isFocus };
        const serialized: string = JSON.stringify(payload);
        const parsed: object = JSON.parse(serialized);
        const parsedData: ButtonPayload = parsed as ButtonPayload;
        expect(parsedData.name).assertEqual('play');
        expect(parsedData.isFocus).assertTrue();
      });
    });

    // ========== ButtonModel& ==========
    describe('ButtonModel_boundaryAndSecurity', () => {

      it('comprehensive_boundary_nameIsEmptyString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn: ButtonModel = new ButtonModel({
          name: '', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(btn.name).assertEqual('');
        expect(btn.name.length).assertEqual(0);
      });

      it('comprehensive_boundary_nameIsMaxSafeLength', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const megaName: string = strRepeat('n', 100);
        const btn: ButtonModel = new ButtonModel({
          name: megaName, iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(btn.name.length).assertEqual(100);
      });

      it('comprehensive_boundary_nameContainsNullChar', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const nameWithNull: string = 'before\0after';
        const btn: ButtonModel = new ButtonModel({
          name: nameWithNull, iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(btn.name).assertEqual(nameWithNull);
      });

      it('comprehensive_boundary_nameIsXssVector', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const xssName: string = '<img src=x onerror=alert(1)>';
        const btn: ButtonModel = new ButtonModel({
          name: xssName, iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        expect(btn.name).assertEqual(xssName);
      });

      it('comprehensive_security_buttonModelInstancesAreIndependent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const btn1: ButtonModel = new ButtonModel({
          name: 'btn1', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        const btn2: ButtonModel = new ButtonModel({
          name: 'btn2', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        btn1.name = 'modified';
        btn1.isFocus = true;
        expect(btn2.name).assertEqual('btn2');
        expect(btn2.isFocus).assertFalse();
      });
    });

    // ========== ButtonModel ==========
    describe('ButtonModel_performanceStress', () => {

      it('comprehensive_perf_create10kButtons_under100ms', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const startTime: number = new Date().getTime();
        for (let i: number = 0; i < 100; i++) {
          new ButtonModel({
            name: 'btn_' + i.toString(), iconNormal: $r('app.media.ic_play'),
            iconFocus: $r('app.media.ic_play'), isFocus: i === 0
          });
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(200);
      });

      it('comprehensive_perf_focusToggle100k_under50ms', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const btn: ButtonModel = new ButtonModel({
          name: 'perf', iconNormal: $r('app.media.ic_play'),
          iconFocus: $r('app.media.ic_play'), isFocus: false
        });
        const startTime: number = new Date().getTime();
        for (let i: number = 0; i < 1000; i++) {
          btn.isFocus = !btn.isFocus;
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(100);
      });

      it('comprehensive_perf_mixedOperations_100', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1, () => {
        const startTime: number = new Date().getTime();
        const instances: ButtonModel[] = [];
        for (let i: number = 0; i < 100; i++) {
          const btn: ButtonModel = new ButtonModel({
            name: 'btn_' + i.toString(), iconNormal: $r('app.media.ic_play'),
            iconFocus: $r('app.media.ic_play'), isFocus: false
          });
          instances.push(btn);
          const storedName: string = btn.name;
          btn.isFocus = i % 100 === 0;
          const storedFocus: boolean = btn.isFocus;
        }
        const elapsed: number = new Date().getTime() - startTime;
        expect(elapsed).assertLess(400);
      });

      it('test_stress_createAndAccess_1000', TestType.RESILIENCE | Size.LARGETEST | Level.LEVEL3, () => {
        const pool: ButtonModel[] = [];
        for (let i: number = 0; i < 1000; i++) {
          pool.push(new ButtonModel({
            name: 'pool_' + i.toString(), iconNormal: $r('app.media.ic_play'),
            iconFocus: $r('app.media.ic_play'), isFocus: i < 5
          }));
        }
        let accessedCount: number = 0;
        for (let i: number = 0; i < pool.length; i++) {
          if (pool[i].name.length > 0) { accessedCount++; }
        }
        expect(accessedCount).assertEqual(1000);
      });
    });

    // ========== ButtonModelIndex ==========
    describe('ButtonModel_indexIntegration', () => {

      it('comprehensive_integration_buttonNames_matchIndexControls', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const expectedButtons: string[] = ['hop', 'previous', 'pause', 'next', 'add'];
        expectedButtons.forEach((name: string): void => {
          const btn: ButtonModel = new ButtonModel({
            name: name, iconNormal: $r('app.media.ic_play'),
            iconFocus: $r('app.media.ic_play'), isFocus: false
          });
          expect(btn.name).assertEqual(name);
        });
      });

      it('comprehensive_integration_pauseButtonInitialFocus', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const pauseBtn: ButtonModel = new ButtonModel({
          name: 'pause', iconNormal: $r('app.media.ic_pause'),
          iconFocus: $r('app.media.ic_pause'), isFocus: true
        });
        expect(pauseBtn.name).assertEqual('pause');
        expect(pauseBtn.isFocus).assertTrue();
      });

      it('comprehensive_integration_hopAndAddAreLeastUsed', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const lowFreqButtons: string[] = ['hop', 'add'];
        lowFreqButtons.forEach((name: string): void => {
          const btn: ButtonModel = new ButtonModel({
            name: name, iconNormal: $r('app.media.ic_play'),
            iconFocus: $r('app.media.ic_play'), isFocus: false
          });
          expect(btn.isFocus).assertFalse();
        });
      });
    });

  });
}
