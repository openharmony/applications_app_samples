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

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { BusinessError } from '@ohos.base';
import abilityAccessCtrl , { Permissions } from '@ohos.abilityAccessCtrl';
import MediaFileUri from '../media/MediaFileUri';
import Logger from '../utils/Logger';

const TAG = '[dlpmanager_EntryAbility]';

export default class EntryAbility extends UIAbility {
  private mediaFileUri: MediaFileUri = new MediaFileUri();

  onCreate( want : Want , launchParam : AbilityConstant.LaunchParam ) : void {
    Logger.info( TAG , '%{public}s' , 'Ability onCreate' );
    this.getPermission( want );
  }

  onDestroy(): void {
    Logger.info( TAG , '%{public}s' , 'Ability onDestroy' );
  }

  onWindowStageCreate( windowStage: window.WindowStage ): void {
    // Main window is created, set main page for this ability
    Logger.info( TAG , 'testTag' , '%{public}s' , 'Ability onWindowStageCreate' );
    windowStage.loadContent( 'pages/Index' , ( err , data ) => {
      if ( err.code ) {
        Logger.error( TAG , 'testTag' , 'Failed to load the content. Cause: %{public}s' , JSON.stringify( err ) ?? '' );
        return;
      }
      Logger.info( TAG , 'testTag' , 'Succeeded in loading the content. Data: %{public}s' , JSON.stringify( data ) ?? '' );
    } );
    let context = this.context;
    let pathDir = context.filesDir;
    AppStorage.setOrCreate( 'pathDir' , pathDir );
    AppStorage.setOrCreate( 'context' , context );
    Logger.info( TAG , 'context type:' + typeof ( this.context ) );

  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info( TAG , 'testTag' , '%{public}s' , 'Ability onWindowStageDestroy' );
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info( TAG , 'testTag' , '%{public}s' , 'Ability onForeground' );
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info( TAG , 'testTag' , '%{public}s' , 'Ability onBackground' );
  }
  
  getPermission( want: Want ): void {
    let array: Array<Permissions> = [
      'ohos.permission.READ_MEDIA',
      'ohos.permission.WRITE_MEDIA',
      'ohos.permission.ACCESS_DLP_FILE',
      'ohos.permission.MEDIA_LOCATION',
      'ohos.permission.FILE_ACCESS_MANAGER',
      'ohos.permission.GET_BUNDLE_INFO_PRIVILEGED'
    ];
    let context = this.context;
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser( context , array ).then( ( data ) => {
      Logger.info( TAG , 'data type:' + typeof ( data ) );
      Logger.info( TAG , 'data:' + JSON.stringify( data ) );
      Logger.info( TAG , 'data permissions:' + data.permissions );
      Logger.info( TAG , 'data result:' + data.authResults );

      this.mediaFileUri.getAllFiles( context );
      Logger.info( TAG , 'getPermission getWantInfo' );
    } ).catch( ( err: BusinessError ) => {
      Logger.error( TAG , 'Failed to start ability' + err.code );
    } );
  }
}
