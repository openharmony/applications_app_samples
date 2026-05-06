// [Start second_error_handler]
import { errorManager } from '@kit.AbilityKit';
import { process } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

let secondHandler: errorManager.ErrorHandler;
const secondErrorHandler: errorManager.ErrorHandler = (reason: Error) => {
    // 自定义的第二个errorHandler实现逻辑
    console.info('[SecondHandler] Second uncaught exception handler invoked.');
    if (secondHandler) {
        secondHandler(reason);
    } else {
        const processManager = new process.ProcessManager();
        processManager.exit(0);
    }
};

export function setSecondErrorHandler() {
    try {
        secondHandler = errorManager.setDefaultErrorHandler(secondErrorHandler);
    } catch (paramError) {
        let code = (paramError as BusinessError).code;
        let message = (paramError as BusinessError).message;
        console.error('setSecondErrorHandler',`error: ${code}, ${message}`);
    }
    console.info('Registered Second Error Handler');
}
// [End second_error_handler]