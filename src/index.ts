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

import { Widget } from '@lumino/widgets';

import '../style/index.css';
import ciscoIcon from '../cisco.svg';

/**
* Activate the Cisco theme extension.
*/
function activate(app: JupyterFrontEnd, themeManager: IThemeManager, browserFactory: IFileBrowserFactory, launcher: ILauncher | null, palette: ICommandPalette | null) {
  console.log('JupyterLab extension cisco_theme_jupyter is activated!');
  console.log('Cisco SVG Icon:', ciscoIcon);

  const style = 'cisco_theme_jupyter/index.css';
  themeManager.register({
    name: 'Cisco Theme',
    isLight: false,
    load: () => themeManager.loadCSS(style),
    unload: () => Promise.resolve(undefined)
  });

  const topWidget = new Widget();
  topWidget.id = 'cisco-automation-notebooks';
  topWidget.node.textContent = 'Cisco Automation Notebooks';
  topWidget.addClass('cisco-top-widget');
  app.shell.add(topWidget, 'top', { rank: 1000 });

  const icon = new LabIcon({
    name: 'custom:ciscoIcon',
    svgstr: ciscoIcon
  });

  const commands = [
    {
      id: 'example:open-ai',
      label: 'Cisco AI',
      icon: icon,
      execute: () => {
        window.open('https://developer.cisco.com/site/ai/', '_blank');
      }
    },
    {
      id: 'example:open-crosswork',
      label: 'Cisco Crosswork Automation',
      icon: icon,
      execute: () => {
        window.open('https://community.cisco.com/t5/crosswork-automation-hub/ct-p/5672j-dev-nso', '_blank');
      }
    },
    {
      id: 'example:open-nso',
      label: 'Cisco NSO',
      icon: icon,
      execute: () => {
        window.open('https://developer.cisco.com/site/nso/', '_blank');
      }
    }
  ];

  commands.forEach(cmd => {
    app.commands.addCommand(cmd.id, {
      label: cmd.label,
      icon: cmd.icon,
      execute: cmd.execute
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
