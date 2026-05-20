import hilog from '@ohos.hilog';

const TAG = 'Laval-BetaClub_Default'

const LOG_DOMAIN = 0x0102

export default class LogManager {

    // console.log
    public static log(tag: string, msg: string) {
        console.log(`${TAG} tag: ${tag} --> ${msg}`)
    }

    // hilog
    public static hilogD(msg: string) {
        if (hilog.isLoggable(LOG_DOMAIN, TAG, hilog.LogLevel.DEBUG)) {
            hilog.debug(LOG_DOMAIN, TAG, msg)
        }
    }

    public static hilogI(msg: string) {
        if (hilog.isLoggable(LOG_DOMAIN, TAG, hilog.LogLevel.INFO)) {
            hilog.info(LOG_DOMAIN, TAG, msg)
        }
    }

    public static hilogIWithTag(tag: string, msg: string) {
        if (hilog.isLoggable(LOG_DOMAIN, TAG, hilog.LogLevel.INFO)) {
            hilog.info(LOG_DOMAIN, TAG, `tag: ${tag} --> ${msg}`)
        }
    }

    public static hilogEWithTag(tag: string, msg: string) {
        if (hilog.isLoggable(LOG_DOMAIN, TAG, hilog.LogLevel.ERROR)) {
            hilog.error(LOG_DOMAIN, TAG, `tag: ${tag} --> ${msg}`)
        }
    }
}