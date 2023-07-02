import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "common"

import Nemo.Notifications 1.0

ApplicationWindow
{
    id: mainWindow

    property string version: "1.0.6"

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

    ListModel { id: projectList }

    function request(params, method, data, callback, fields) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function(mxhr, messageNotification, fields) {
            return function() { if(mxhr.readyState === XMLHttpRequest.DONE) { callback(mxhr, messageNotification, fields); } }
        })(xhr, messageNotification, fields);

        // Check that the URL ends in slash.
        var url = settings.base_url
        if (url.substr(url.length - 1) !== "/") {
            url = url + "/";
        }
        url = url + params;

        xhr.open(method, url, true);
        xhr.setRequestHeader("Content-Type", "text/xml");
        xhr.setRequestHeader("Authorization", "Basic " + Qt.btoa(settings.username + ":" + settings.token));
        if(method === "post" || method === "put") {
            xhr.send(data);
        }
        else {
            xhr.send('');
        }
    }

    function getContextsFromTracks() {
        request("contexts.xml", "get", "", function(doc, messageNotification) {
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
                        if(tl.childNodes[j].nodeName === "state") {
                            item.state = tl.childNodes[j].childNodes[0].nodeValue;
                        }
                    }
                    if (item.state == 'active') {
                        contextList.append(item);
                    }
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

    function getProjectsFromTracks() {
        request("projects.xml", "get", "", function(doc, messageNotification) {
            var e = doc.responseXML.documentElement;
            projectList.clear();
            var emptyItem = {}
            emptyItem.name = qsTr("None")
            emptyItem.projectId = "0"
            projectList.append(emptyItem);
            for(var i = 0; i < e.childNodes.length; i++) {
                if(e.childNodes[i].nodeName === "project") {
                    var tl = e.childNodes[i];
                    var item = {}
                    for(var j = 0; j < tl.childNodes.length; j++) {
                        if(tl.childNodes[j].nodeName === "name") {
                            item.name = tl.childNodes[j].childNodes[0].nodeValue;
                        }
                        if(tl.childNodes[j].nodeName === "id") {
                            item.projectId = tl.childNodes[j].childNodes[0].nodeValue;
                        }
                    }
                    projectList.append(item);
                }
            }
        });
    }

    function getProjectIdFromName(projectName) {
        for (var i = 0; i < projectList.count; i++) {
            var value = projectList.get(i);
            if (projectName === value.name) {
                return value.projectId;
            }
        }
    }
}
