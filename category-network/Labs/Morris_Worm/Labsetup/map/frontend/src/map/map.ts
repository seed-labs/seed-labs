import './css/map.css';
import '../common/css/window-manager.css';
import 'bootstrap/dist/css/bootstrap.min.css';

import { DataSource } from './datasource';
import { MapUi } from './ui';
import { Configuration } from '../common/configuration';

const datasource = new DataSource(Configuration.ApiPath);
const mapUi = new MapUi({
    datasource,
    mapElementId: 'map',
    infoPlateElementId: 'info-plate',
    filterInputElementId: 'filter',
    filterWrapElementId: 'filter-wrap',
    logPanelElementId: 'log-panel',
    logBodyElementId: 'log-body',
    logViewportElementId: 'log-viewport',
    logWrapElementId: 'log-wrap',
    logControls: {
        autoscrollCheckboxElementId: 'log-autoscroll',
        clearButtonElementId: 'log-clear',
        disableCheckboxElementId: 'log-disable',
        minimizeToggleElementId: 'log-panel-toggle',
        minimizeChevronElementId: 'log-toggle-chevron'
    },
    filterControls: {
        filterModeTabElementId: 'tab-filter-mode',
        nodeSearchModeTabElementId: 'tab-node-search-mode',
        suggestionsElementId: 'filter-suggestions'
    },
    replayControls: {
        recordButtonElementId: 'replay-record',
        replayButtonElementId: 'replay-replay',
        stopButtonElementId: 'replay-stop',
        forwardButtonElementId: 'replay-forward',
        backwardButtonElementId: 'replay-backward',
        seekBarElementId: 'replay-seek',
        intervalElementId: 'replay-interval',
        statusElementId: 'replay-status'
    },
    windowManager: {
        desktopElementId: 'console-area',
        taskbarElementId: 'taskbar'
    }
});

mapUi.start();