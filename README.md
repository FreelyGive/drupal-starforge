# Drupal Starforge

Drupal Starforge is a playground for experimenting with Drupal CMS and AI technologies. It is designed to help developers and enthusiasts explore the capabilities of Drupal CMS in conjunction with AI, providing a platform for innovation and creativity.

The idea is that anyone can use this project to quickly set up a Drupal CMS instance with AI capabilities, to try out prototype and test new features.

Its also a playground for developers to push their recipes of AI integration with Drupal CMS, and to share their findings with the community and get feedback. Any good ideas that come out of this project will be considered for inclusion as a MR in the [drupal_cms project](https://www.drupal.org/project/drupal_cms).

## Getting started

This is completely based on you having [DDEV](https://ddev.com) installed. Later a Devpanel starter will also be available, but for now, you can use DDEV to run Drupal CMS locally.

If you want to use [DDEV](https://ddev.com) to run Drupal CMS locally, follow these instructions:

1. Install DDEV following the [documentation](https://ddev.com/get-started/)
2. Open the command line and `cd` to the root directory of this project
3. Run the following commands:
```shell
ddev rebuild
ddev launch
```

Note that ddev rebuild will at any time reinstall the system, so only run it once or when you want to reset the system.

**NOTE: Its very important currently that you install the website via the browser, since the complex provider installer is only available via the web interface. So after running `ddev launch`, open your browser and go to the URL provided by DDEV, and follow the instructions to install Drupal CMS. Do not use `ddev drush si` to install the site, as it will not work properly.**

### Extra services

This project comes with a few extra services and applications that the normal Drupal CMS does not have. These are:

1. **PG Vector**: A PostgreSQL database for vector similarity search, useful for AI applications. The provider module is already installed, enabled and setup.
2. **Unstructured.io**: A service for managing unstructured data, such as documents and images, which can be used in AI applications. The provider module is already installed, enabled and setup.
3. **ffmpeg**: A multimedia framework for handling video and audio files, useful for AI applications that require media processing.

### Extra base recipe:

The recipe `drupal_cms_starforge_starter` will be run automatically on installation and require you to setup the AI provider of your choice. This recipe will install the necessary modules and configuration to get you started with AI integration in Drupal CMS. This means that any recipe you create could use this as a base recipe, so you do not have to repeat installation of the AI providers.

## Contributing

Any contributions as features should be recipes under the `recipes` directory. Each recipe should be a self-contained feature that can be enabled or disabled independently. See for instance the drupal_cms_starforge_recipes module for an example of how to structure a recipe.

If you want to contribute to the project, please follow these steps:
1. Fork the repository on GitHub.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them with a clear message.
4. Push your changes to your forked repository.
5. Create a pull request against the main repository.

If you just want your recipe to be included via the Project Browser, then open the file `recipes/drupal_cms_starter/recipe.yml` and under `config.actions.project_browser.admin_settings.simpleConfigUpdate.allowed_projects.recipes` add your recipe name. This will make it available in the Project Browser for anyone to install.

If you want it to install automatically then instead add it in the same file, directly under `recipes` as a new entry.

## License

Drupal CMS and all derivative works are licensed under the [GNU General Public License, version 2 or later](http://www.gnu.org/licenses/old-licenses/gpl-2.0.html).

Learn about the [Drupal trademark and logo policy here](https://www.drupal.com/trademark).

## DrupalForge

This project automatically will push to DrupalForge when something is merged into the 1.0.x branch. Since it needs to build a container, count with a minimum of 10 minutes before the updates are available on DrupalForge.
