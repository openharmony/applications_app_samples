/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import UIAbility from '@ohos.app.ability.UIAbility';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import Logger from '../utils/Logger';

const TAG = '[dlpmanager_FuncAbility]';

export default class FuncAbility extends UIAbility {
  private storage: LocalStorage = new LocalStorage();

  onCreate( want: Want , launchParam: AbilityConstant.LaunchParam ) {
    // 接收调用方UIAbility传过来的参数
    Logger.info( TAG , '%{public}s' , 'Ability onCreate' );
    let funcAbilityWant = want;
    let info = funcAbilityWant.parameters;
    Logger.info( TAG , 'funcAbilityWant:' + typeof ( funcAbilityWant ) + ';parameters:' + typeof ( info ) );
    Logger.info( TAG , 'funcAbilityWant:' + JSON.stringify( funcAbilityWant ) + ';parameters:' + JSON.stringify( info ) );
    AppStorage.setOrCreate( 'funcAbilityWant' , funcAbilityWant );
    this.getWantInfo( want );
  }

  onWindowStageCreate( windowStage: window.WindowStage ): void {
    Logger.info( TAG , 'testTag' , '%{public}s' , 'Ability onWindowStageCreate' );
    windowStage.loadContent( 'media/dlpPage' , this.storage , ( err , data ) => {
      if ( err.code ) {
        Logger.error( TAG , 'Failed to load the content. Cause: ' + JSON.stringify( err ) ?? '' );
        return;
      }
      Logger.info( TAG , 'Succeeded in loading the content. Data: ' + JSON.stringify( data ) ?? '' );
    } );

    let context = this.context;
    let pathDir = context.filesDir;
    Logger.info( TAG , 'context type:' + typeof ( this.context ) );
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info( TAG , 'testTag' , '%{public}s' , 'Ability onWindowStageDestroy' );
  }

  getWantInfo( want: Want ): void {
    if ( want === null || want === undefined ) {
      Logger.info( TAG , 'getWantInfo want is null' );
      return;
    }

    let srcUri = want.uri;
    if ( srcUri === null || srcUri === undefined ) {
      Logger.info( TAG , 'getWantInfo srcUri is null' );
      return;
    }

    let parameters = want.parameters;
    if ( parameters === null || parameters === undefined ) {
      Logger.info( TAG , 'getWantInfo parameters is null' );
      return;
    }
  }
}
