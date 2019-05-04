import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property string context: "";

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    ListModel {
        id: tasklist;
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
            id: view

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
            delegate: ListItem {
                id: listItem
                width: ListView.view.width
                contentHeight: Theme.itemSizeSmall
                menu: contextMenu
                ListView.onRemove: animateRemoval(listItem)

                function done() {
                    remorseAction(qsTr("Marking as done"), function() {
                        var item = view.model.get(index);
                        var todoId = item.todoId;
                        var description = item.description;
                        view.model.remove(index)
                        setTaskAsDone(todoId, description);
                    })
                }

                Label {
                    id: label
                    text: description
                }
                Label {
                    anchors.top: label.bottom
                    anchors.right: parent.right
                    font.pixelSize: Theme.fontSizeSmall
                    text: due
                }

                Component {
                    id: contextMenu
                    ContextMenu {
                        MenuItem {
                            text: "Done"
                            onClicked: done()
                        }
                    }
                }
            }
            Component.onCompleted: {
              getTasksFromTracks(context);
            }
        }
    }

    function getTasksFromTracks(contextName) {
        var contextId = getContextIdFromName(contextName);
        var dateOptions = { year: 'numeric', month: 'short', day: 'numeric' };
        request("contexts/" + contextId + "/todos.xml?limit_to_active_todos=1", "get", "", function(doc) {
            var e = doc.responseXML.documentElement;
            tasklist.clear();
            for(var i = 0; i < e.childNodes.length; i++) {
                if(e.childNodes[i].nodeName === "todo") {
                    var tl = e.childNodes[i];
                    var item = {due: ""}
                    for(var j = 0; j < tl.childNodes.length; j++) {
                        if(tl.childNodes[j].nodeName === "id") {
                            item.todoId = tl.childNodes[j].childNodes[0].nodeValue;
                        }
                        if(tl.childNodes[j].nodeName === "description") {
                            item.description = tl.childNodes[j].childNodes[0].nodeValue;
                        }
                        if(tl.childNodes[j].nodeName === "due" && tl.childNodes[j].childNodes[0]) {
                            var due = tl.childNodes[j].childNodes[0].nodeValue;
                            if (due !== "") {
                                due = new Date(due);
                                item.due = due.toLocaleDateString(dateOptions);
                            }
                        }
                    }
                    tasklist.append(item);
                }
            }
        });
    }

    function setTaskAsDone(taskId, description) {
        request("todos/" + taskId + "/toggle_check.xml", "put", "", function(doc) {
            var m = messageNotification.createObject(null);
            if (doc.status === 200) {
                m.body = qsTr("Task %1 set done.").arg(description);
                m.summary = qsTr("Tracks task set done")
            }
            else {
                m.body = qsTr("Setting task %1 done failed.").arg(description);
                m.summary = qsTr("Tracks task setting failed")
            }
            m.previewSummary = m.summary
            m.previewBody = m.body
            m.publish()
            getTasksFromTracks(context);
        });
    }
}
