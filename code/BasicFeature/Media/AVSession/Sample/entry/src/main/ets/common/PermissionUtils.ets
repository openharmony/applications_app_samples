import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';

const TAG = 'AVPlayer';
const permissions: Array<Permissions> = ['ohos.permission.READ_AUDIO'];

export default class PermissionUtils {
  public static init(context, callback) {
    console.log(TAG, 'start init permission');
    let atManager = abilityAccessCtrl.createAtManager();
    //requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗

    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i ++) {
        if(grantStatus[i] !== 0) {
          console.error(TAG, `User reject permission: ${grantStatus[i]}`);
          callback(false);
          return;
        }
      }
      console.error(TAG, `get permission suc`);
      callback(true);
    }).catch((err) => {
      console.error(TAG, `Failed to request permissions from user. Code is ${err.code}, message: ${err.message}`);
    })
  }
}