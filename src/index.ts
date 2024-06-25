import {
  JupyterFrontEnd,
  JupyterFrontEndPlugin
} from '@jupyterlab/application';

import {
  IThemeManager
} from '@jupyterlab/apputils';

import '../style/index.css';

/**
* Activate the Cisco theme extension.
*/
function activate(app: JupyterFrontEnd, themeManager: IThemeManager) {
  console.log('JupyterLab extension cisco_theme_jupyter is activated!');

  const style = 'cisco_theme_jupyter/index.css';
  themeManager.register({
    name: 'Cisco Theme',
    isLight: false,
    load: () => themeManager.loadCSS(style),
    unload: () => Promise.resolve(undefined)
  });
}

/**
 * Initialization data for the cisco_theme_jupyter extension.
 */
const plugin: JupyterFrontEndPlugin<void> = {
  id: 'cisco_theme_jupyter',
  autoStart: true,
  requires: [IThemeManager],
  activate: activate
};

export default plugin;
