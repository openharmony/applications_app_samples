import UIAbility from '@ohos.app.ability.UIAbility';

export class CurActiveAbility extends UIAbility {
  // private constructor() {}
  private static instance: CurActiveAbility;

  private _object : Object;

  public static GetInstance(): CurActiveAbility {
    if (!CurActiveAbility.instance) { // 这里要不要加一个undefined
      CurActiveAbility.instance = new CurActiveAbility();
    }
    return CurActiveAbility.instance;
  }

  SetGlobalAbility(object: Object): void{
      this._object = object;
  }

  GetGlobalAbility(): UIAbility {
    return this._object as UIAbility;
  }
}