import { Logger } from 'tslog';

/**
 * common interface for object producing logs.
 */
export interface LogProducer {

    /**
     * get loggers.
     * 
     * @returns loggers.
     */
    getLoggers(): Logger[];
}