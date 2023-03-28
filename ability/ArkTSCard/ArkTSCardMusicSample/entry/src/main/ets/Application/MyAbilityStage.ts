import AbilityStage from '@ohos.app.ability.AbilityStage';

export default class MyAbilityStage extends AbilityStage {
  onCreate(): void {
    console.log('[Demo] MyAbilityStage onCreate');
  }
}