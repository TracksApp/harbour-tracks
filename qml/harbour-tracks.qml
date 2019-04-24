import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "common"

import Nemo.Notifications 1.0

ApplicationWindow
{
    id: mainWindow

    initialPage: Component { ContextList { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Settings {
        id: settings
    }

    Component {
        id: messageNotification
        Notification {}
    }

    ListModel { id: contextList }

    function request(params, method, data, callback) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function(mxhr) {
            return function() { if(mxhr.readyState === XMLHttpRequest.DONE) { callback(mxhr); } }
        })(xhr);

        // Check that the URL ends in slash.
        var url = settings.base_url
        if (url.substr(url.length - 1) !== "/") {
            url = url + "/";
        }
        url = url + params;

        if(method === "post") {
            xhr.open('POST', url, true);
            xhr.setRequestHeader("Content-Type", "text/xml");
            xhr.setRequestHeader("Authorization", "Basic " + Qt.btoa(settings.username + ":" + settings.token));
            xhr.send(data);
        } else {
            xhr.open('GET', url, true);
            xhr.setRequestHeader("Content-Type", "text/xml");
            xhr.setRequestHeader("Authorization", "Basic " + Qt.btoa(settings.username + ":" + settings.token));
            xhr.send('');
        }
    }

    function getContextsFromTracks() {
        request("contexts.xml", "get", "", function(doc) {
            console.log(doc.status);
            var e = doc.responseXML.documentElement;
            contextList.clear();
            for(var i = 0; i < e.childNodes.length; i++) {
                if(e.childNodes[i].nodeName === "context") {
                    var tl = e.childNodes[i];
                    var item = {}
                    for(var j = 0; j < tl.childNodes.length; j++) {
                        if(tl.childNodes[j].nodeName === "name") {
                            item.name = tl.childNodes[j].childNodes[0].nodeValue;
                        }
                        if(tl.childNodes[j].nodeName === "id") {
                            item.contextId = tl.childNodes[j].childNodes[0].nodeValue;
                        }
                    }
                    contextList.append(item);
                }
            }
        });
    }

    function getContextIdFromName(contextName) {
        for (var i = 0; i < contextList.count; i++) {
            var value = contextList.get(i);
            if (contextName === value.name) {
                return value.contextId;
            }
        }
    }
}
