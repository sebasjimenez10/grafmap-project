GrafMap
===============
[![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com/)
Visit live version [here](http://blooming-island-5355.herokuapp.com/)

Description
===========

GrafMap is an application to check which places are around you and mark them as favorites if you want. We are using [HTML5 geolocation](https://developer.mozilla.org/en-US/docs/WebAPI/Using_geolocation) to get your location from the browser and [Facebook OpenGraph](https://developers.facebook.com/docs/opengraph/overview/) to fill the map with places that are around you. The places are marked and drew with [google maps API](https://developers.google.com/maps/documentation/javascript/examples/marker-simple). The final product is bigger than what we implement here, this is a minimum viable product, it was built using java for backend, following a *DDD approach*. The frontend was built using coffeescript, sass and HTML5.

#### Live version
You can find it [here](http://grafmap.sebasjimenezv.cloudbees.net/grafmap-project/). Feel free to use it.


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

This application runs in a GlassFish 3 Server. Proyect must be compiled and .war must be deployed in the server. It has [Json](http://json.org/) and [jOOQ](http://www.jooq.org/) dependencies.
