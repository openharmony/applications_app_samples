import LogManager from '../Log/LogManager'
import abilityAccessCtrl, { Context, Permissions } from '@ohos.abilityAccessCtrl';

const TAG = 'PermissionManager'

export default class PermissionManager {
    private static manager: PermissionManager

    public static shareInstance(): PermissionManager {
      if (!PermissionManager.manager) {
        PermissionManager.manager = new PermissionManager()
      }
      return PermissionManager.manager
    }

    public requestPermissions(context: Context, permissions: Permissions[]) {
      let atManager = abilityAccessCtrl.createAtManager();
      try {
        atManager.requestPermissionsFromUser(context, permissions, (err, data)=>{
          LogManager.hilogIWithTag(TAG, 'data:' + JSON.stringify(data));
          LogManager.hilogIWithTag(TAG, 'data permissions:' + data.permissions);
          LogManager.hilogIWithTag(TAG, 'data authResults:' + data.authResults);
        });
      } catch(err) {
        LogManager.hilogIWithTag(TAG, `catch err->${JSON.stringify(err)}`);
      }
    }
}