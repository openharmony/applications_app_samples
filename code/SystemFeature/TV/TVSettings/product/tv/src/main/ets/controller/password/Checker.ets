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

import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';

const PASSWORD_MIN_LENGTH = 4
const PASSWORD_MAX_LENGTH = 32

/**
 * Check whether the string is legal.
 */
export class Checker {
  private TAG = ConfigData.TAG + 'Password Checker ';

/**
   * check if the character string more than 4 digits
   *
   * @param str : character string
   */
  checkMinDigits(str: string): boolean {
    LogUtil.info(this.TAG + 'checkMinDigits in.');
    return str.length >= PASSWORD_MIN_LENGTH;
    LogUtil.info(this.TAG + 'checkMinDigits out.');
  }

/**
   * check if the character string less than 33 digits
   *
   * @param str : character string
   */
  checkMaxDigits(str: string): boolean {
    LogUtil.info(this.TAG + 'checkMaxDigits in.');
    return str.length <= PASSWORD_MAX_LENGTH;
    LogUtil.info(this.TAG + 'checkMaxDigits out.');
  }

/**
   * check if character string is 6 digits number
   *
   * @param str : character string
   */
  isNumber6(str: string): boolean {
    LogUtil.info(this.TAG + 'isNumber6 in.');
    let reg = /^[0-9]{6}$/;
    return reg.test(str);
    LogUtil.info(this.TAG + 'isNumber6 out.');
  }

/**
   * Check whether the string is a 4 to 32 digits number
   *
   * @param str : character string
   */
  containsOnlyNumbers(str: string): boolean {
    LogUtil.info(this.TAG + 'containsOnlyNumbers in.');
    let reg = /^[0-9]{4,32}$/;
    return reg.test(str);
    LogUtil.info(this.TAG + 'containsOnlyNumbers out.');
  }

/**
   * check if the character string is only numbers
   *
   * @param str : character string
   */
  isOnlyNumber(str: string): boolean {
    LogUtil.info(this.TAG + 'isOnlyNumber in.');
    let reg = /^[0-9]+$/;
    return reg.test(str);
    LogUtil.info(this.TAG + 'isOnlyNumber out.');
  }

/**
   * Check for 4 to 32 digits mixed characters
   *
   * @param str : character string
   */
  containCharacter(str: string): boolean {
    LogUtil.info(this.TAG + 'containCharacter in.');
    let reg = /^(?=.*[a-zA-Z])[\x20-\x7E]{4,32}$/;
    return reg.test(str);
    LogUtil.info(this.TAG + 'containCharacter out.');
  }

/**
   * check if the character string contain letters
   *
   * @param str : character string
   */
  isContainLetters(str: string): boolean {
    LogUtil.info(this.TAG + 'isContainLetters in.');
    let reg = /^(?=.*[a-zA-Z])/;
    return reg.test(str);
    LogUtil.info(this.TAG + 'isContainLetters out.');
  }

/**
   * check if the character string is containIllegal character
   *
   * @param str : character string
   */
  isContainIllegalCharacter(str: string): boolean {
    LogUtil.info(this.TAG + 'isContainIllegalCharacter in.');
    let reg = /[^\x20-\x7E]/;
    return reg.test(str);
    LogUtil.info(this.TAG + 'isContainIllegalCharacter out.');
  }
}
