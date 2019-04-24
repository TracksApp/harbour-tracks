import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property string context: "";

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    ListModel {
        id: tasklist;
        ListElement { description: "Refresh the list before using" }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: getTasksFromTracks(context)
            }
        }

        width: parent.width;
        height: parent.height

        SilicaListView {
            header: PageHeader {
                title: qsTr("Task list")
            }

            ViewPlaceholder {
                enabled: contextList.count == 0
                text: qsTr("Nothing here")
                hintText: qsTr("Check your settings")
            }

            width: parent.width
            height: parent.height
            model: tasklist
            delegate: Item {
                width: ListView.view.width
                height: Theme.itemSizeSmall

                Label { text: description }
            }
            Component.onCompleted: {
              getTasksFromTracks(context);
            }
        }
    }

    function getTasksFromTracks(contextName) {
        var contextId = getContextIdFromName(contextName);
        request("contexts/" + contextId + "/todos.xml?limit_to_active_todos=1", "get", "", function(doc) {
            var e = doc.responseXML.documentElement;
            tasklist.clear();
            for(var i = 0; i < e.childNodes.length; i++) {
                if(e.childNodes[i].nodeName === "todo") {
                    var tl = e.childNodes[i];
                    for(var j = 0; j < tl.childNodes.length; j++) {
                        if(tl.childNodes[j].nodeName === "description") {
                            var item = {}
                            item.description = tl.childNodes[j].childNodes[0].nodeValue;
                            tasklist.append(item);
                        }
                    }
                }
            }
        });
    }
}
