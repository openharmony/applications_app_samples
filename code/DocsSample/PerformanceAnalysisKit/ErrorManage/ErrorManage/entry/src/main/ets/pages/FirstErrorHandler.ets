// [Start first_error_handler]
import { errorManager } from '@kit.AbilityKit';
import { process } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

let firstHandler: errorManager.ErrorHandler;
const firstErrorHandler: errorManager.ErrorHandler = (reason: Error) => {
    // 自定义的第一个errorHandler实现逻辑
    console.info('[FirstHandler] First uncaught exception handler invoked.');
    if (firstHandler) {
        firstHandler(reason);
    } else {
        // 建议增加判空操作，如果为空采用同步退出方式
        const processManager = new process.ProcessManager();
        processManager.exit(0);
    }  
};

export function setFirstErrorHandler() {
    try {
        firstHandler = errorManager.setDefaultErrorHandler(firstErrorHandler);
    } catch (paramError) {
        let code = (paramError as BusinessError).code;
        let message = (paramError as BusinessError).message;
        console.error('setFirstErrorHandler',`error: ${code}, ${message}`);
    }
    console.info('Registered First Error Handler');
}
// [End first_error_handler]