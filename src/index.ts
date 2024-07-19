import {
  JupyterFrontEnd,
  JupyterFrontEndPlugin
} from '@jupyterlab/application';

import {
  IThemeManager,
  ICommandPalette
} from '@jupyterlab/apputils';

import {
  IFileBrowserFactory
} from '@jupyterlab/filebrowser';

import { ILauncher } from '@jupyterlab/launcher';

import { LabIcon } from '@jupyterlab/ui-components';

import '../style/index.css';
import ciscoIcon from '../cisco2.png'

/**
* Activate the Cisco theme extension.
*/
function activate(app: JupyterFrontEnd, themeManager: IThemeManager, browserFactory: IFileBrowserFactory, launcher: ILauncher | null, palette: ICommandPalette | null) {
  console.log('JupyterLab extension cisco_theme_jupyter is activated!');

  const style = 'cisco_theme_jupyter/index.css';
  themeManager.register({
    name: 'Cisco Theme',
    isLight: false,
    load: () => themeManager.loadCSS(style),
    unload: () => Promise.resolve(undefined)
  });
  const commands = [
    {
      id: 'example:open-ai',
      label: 'Cisco AI',
      url: 'https://developer.cisco.com/site/ai/'
    },
    {
      id: 'example:open-crosswork',
      label: 'Cisco Crosswork Automation',
      url: 'https://community.cisco.com/t5/crosswork-automation-hub/ct-p/5672j-dev-nso'
    },
    {
      id: 'example:open-nso',
      label: 'Cisco NSO',
      url: 'https://developer.cisco.com/site/nso/'
    }
  ];
  const icon = new LabIcon({
    name: 'custom:ciscoIcon',
    svgstr: ciscoIcon
  });
  commands.forEach(cmd => {
    app.commands.addCommand(cmd.id, {
      label: cmd.label,
      caption: cmd.label,
      icon: icon,
      execute: () => {
        window.open(cmd.url, '_blank');
      }
    });

    if (launcher) {
      launcher.add({
        command: cmd.id,
        category: 'Cisco Modules',
        rank: 1
      });
    }

    if (palette) {
      palette.addItem({ command: cmd.id, category: 'Cisco Modules' });
    }
  });
  
}

/**
 * Initialization data for the cisco_theme_jupyter extension.
 */
const plugin: JupyterFrontEndPlugin<void> = {
  id: 'cisco_theme_jupyter',
  autoStart: true,
  requires: [IThemeManager, IFileBrowserFactory],
  optional: [ILauncher, ICommandPalette],
  activate: activate
};

export default plugin;
