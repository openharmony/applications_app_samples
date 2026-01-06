// [Start EntryFormAbility]
// entry/src/main/ets/entryformability/EntryFormAbility.ets
import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    const formData = '';
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string): void {
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onCastToNormalForm');
  }

  onUpdateForm(formId: string) {

    class FormDataClass {
      title: string = 'Title: ' + Math.random();
      detail: string = 'Description: ' + Math.random();
    }

    let formData = new FormDataClass();
    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN_NUMBER, TAG, `Operation updateForm failed. code: ${error.code}, message: ${error.message}`);
    });
  }

  onFormEvent(formId: string, message: string) {
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onFormEvent');
  }

  onRemoveForm(formId: string) {
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onRemoveForm');
  }

  onAcquireFormState(want: Want) {
    hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onAcquireFormState');
    return formInfo.FormState.READY;
  }
}
// [end EntryFormAbility]