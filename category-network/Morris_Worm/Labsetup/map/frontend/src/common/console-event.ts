export interface ConsoleEvent{
    type: 'ready' | 'closed' | 'error' | 'focus' | 'blur' | 'data' | 'rawkey';
    id: string;
    data?: any;
}