GrafMap
===============

TODO: Write project description

## Front-end setup
> Make sure you already have [NPM](http://npmjs.org/) installed.

Go to the web folder (`grafmap-project/web`) and install all the dependencies, `$ npm install`.

This will install [Grunt](http://gruntjs.com/), which is the task runner we use to compile CoffeeScript and Sass files.

#### Grunt Commands

>Start the default task:
>
>`$ grunt`
>
>Start the watch task for the coffeescripts:
>
>`$ grunt watch:app`
>
>Start the watch task for the sass files:
>
>`$ grunt watch:sass`

To manage all the package we use [Bower](https://github.com/bower/bower). Install it, `$ npm install -g bower`. Then run `$ bower install`, this will install all the dependencies listed in bower.json.

Finally, if you want to run a separate server for development or don't want to deal with Java, install _connect_ `$ npm install connect` and run `$ node server.js`. Then you can go to http://localhost:8080/.


## Server setup

TODO: Write Server setup instructions.