# Docker build image for PHP and Node.js applications

## Image versions
The main difference between tagged version of the image is the installed PHP version.

## Available tools

### PHP
The interpreter is run as usual with `php`. Pretty much all common modules are installed and a bunch of less common ones as well.

### composer
Both versions 1 and 2 of composer are installed.
  * Composer legacy: `composer1`
  * Composer: `composer`

### nodejs - nvm and yarn
nvm (Node Version Manager) is used to install whichever Node.js version you need for the specific project. Once you choose your Node.js version for a project, we suggest that you write it in `.nvmrc`, so that all other developers can use that exact same version and you don't have to hardcode it in your CI.

Yarn is installed globally in the container and set up to use the same Node.js you are using through nvm.
