// [Start second_error_handler]
import { errorManager } from '@kit.AbilityKit';
import { process } from '@kit.ArkTS';

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
    secondHandler = errorManager.setDefaultErrorHandler(secondErrorHandler); 
    console.info('Registered Second Error Handler');
}
// [End second_error_handler]