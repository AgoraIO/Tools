var http = require('http');
var express = require('express');
var DynamicKey5 = require('AgoraDynamicKey/nodejs/src/DynamicKey5');

var PORT = process.env.PORT || 8080;

if (!(process.env.APP_ID && process.env.APP_CERTIFICATE)) {
    throw new Error('You must define an APP_ID and APP_CERTIFICATE');
    process.exit();
}
var APP_ID = process.env.APP_ID;
var APP_CERTIFICATE = process.env.APP_CERTIFICATE;

var app = express();
app.disable('x-powered-by');
app.set('port', PORT);
app.use(express.favicon());
app.use(app.router);
app.use(express.static(__dirname));

function nocache(req, res, next) {
    res.header('Cache-Control', 'private, no-cache, no-store, must-revalidate');
    res.header('Expires', '-1');
    res.header('Pragma', 'no-cache');
    next();
}

var generateChannelKey = function (req, resp) {
    resp.header('Access-Control-Allow-Origin', "*")
    
    var unixTs = Math.round(new Date().getTime() / 1000);
    var randomInt = Math.round(Math.random() * 100000000);

    var channel = req.query.channel;
    if (!channel) {
        return resp.status(500).json({ 'error': 'channel name is required' }).send();
    }

    var uid = req.query.uid;
    if (!uid) {
        uid = 0;
    }

    var expiredTs = req.query.expiredTs;
    if (!expiredTs) {
        expiredTs = 0;
    }

    var channel_key = DynamicKey5.generateMediaChannelKey(APP_ID, APP_CERTIFICATE, channel, unixTs, randomInt, uid, expiredTs);
    return resp.json({ 'channel_key': channel_key }).send();
};

var generateInChannelPermission = function (req, resp) {
    resp.header('Access-Control-Allow-Origin', "*")

    var unixTs = Math.round(new Date().getTime() / 1000);
    var randomInt = Math.round(Math.random() * 100000000);

    var channel = req.query.channel;
    if (!channel) {
        return resp.status(500).json({ 'error': 'channel name is required' }).send();
    }

    var uid = req.query.uid;
    if (!uid) {
        return resp.status(500).json({ 'error': 'uid is required' }).send();
    }

    var permission = req.query.permission;

    var recording_key = DynamicKey5.generateInChannelPermissionKey(APP_ID, APP_CERTIFICATE, channel, unixTs, randomInt, uid, 0, permission);
    return resp.json({ 'in_channel_permission_key': recording_key }).send();
}

app.get('/channel_key', nocache, generateChannelKey);
app.get('/in_channel_permission_key', nocache, generateInChannelPermission);

http.createServer(app).listen(app.get('port'), function () {
    console.log('Service URL http://127.0.0.1:' + app.get('port') + "/");
    console.log('Channel Key request, /channel_key?uid=[user id]&channel=[channel name]');
    console.log('Channel Key with expiring time request, /channel_key?uid=[user id]&channel=[channel name]&expiredTs=[expire ts]');
});
