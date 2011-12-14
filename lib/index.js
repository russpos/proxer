var coffee  = require('coffee-script'),
    app     = require('./app'),
    port    = 8182;

app.listen(port);
console.log("Proxy running on port ", port);
