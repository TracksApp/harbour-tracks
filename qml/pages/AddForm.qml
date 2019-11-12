import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: page

    property variant contextValue: "";

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        id: addform
        anchors.fill: parent

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            DialogHeader {
                acceptText: qsTr("Add task")
            }

            TextField {
                id: description
                focus: true
                width: parent.width
                placeholderText: qsTr("Task description")
                label: qsTr("Task description")

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: note.focus = true
            }

            TextArea {
                id: note
                width: parent.width
                placeholderText: qsTr("Note")
                label: qsTr("Note")
            }

            ComboBox {
                id: context
                width: parent.width
                label: qsTr("Context")

                menu: ContextMenu {
                    Repeater {
                        model: contextList
                        MenuItem {
                            text: name
                        }
                    }
                }

                Component.onCompleted: {
                    for(var i = 0; i < contextList.count; ++i) {
                        if (contextList.get(i).name == contextValue) {
                            context.currentIndex = i;
                        }
                    }
                }
            }

            ComboBox {
                id: project
                width: parent.width
                label: qsTr("Project")

                menu: ContextMenu {
                    Repeater {
                        model: projectList
                        MenuItem {
                            text: name
                        }
                    }
                }
            }

            ValueButton {
                id: dueDate
                label: qsTr("Due date")
                value: qsTr("Select")
                width: parent.width

                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog", {date: new Date()})

                    dialog.accepted.connect(function() {
                        value = dialog.date.toLocaleDateString(Qt.locale("en-GB"), "yyyy-MM-dd")
                    })
                }
            }

            ValueButton {
                id: showFromDate
                label: qsTr("Show from")
                value: qsTr("Select")
                width: parent.width

                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog", {date: new Date()})

                    dialog.accepted.connect(function() {
                        value = dialog.date.toLocaleDateString(Qt.locale("en-GB"), "yyyy-MM-dd")
                    })
                }
            }
        }
    }

    onAccepted: {
        addTaskToTracks()
    }

    function addTaskToTracks() {
        var contextId = getContextIdFromName(context.value);

        /*var parser = new Qt.DOMParser();
        var req = parser.parseFromString("<todo></todo>", "text/xml");
        var descr = req.createElement("description");

        var s = new XMLSerializer();
        console.log(s.serializeToString(req));*/

        var requestData = "<todo>"
        if (dueDate.value !== qsTr("Select")) {
            requestData = requestData + "<due type=\"dateTime\">" + dueDate.value + "</due>"
        }
        if (showFromDate.value !== qsTr("Select")) {
            requestData = requestData + "<show-from type=\"dateTime\">" + showFromDate.value + "</show-from>"
        }
        if (project.value !== qsTr("None")) {
            requestData = requestData + "<project-id>" + getProjectIdFromName(project.value) + "</project-id>"
        }
//        requestData = requestData + "<tags type=\"array\"><tag>testitagi</tag></tags>"

        requestData = requestData + "<description>" + description.text + "</description><notes>" + note.text + "</notes><context_id>" + contextId + "</context_id></todo>"

        request("todos.xml", "post", requestData, function(doc) {
            var m = messageNotification.createObject(null);
            if (doc.status === 201) {
                m.body = qsTr("Task %1 added to context %2.").arg(description.text).arg(context.value);
                m.summary = qsTr("Tracks task added")
            }
            else {
                m.body = qsTr("Adding task %1 failed.").arg(description.text);
                m.summary = qsTr("Tracks task adding failed")
            }
            m.previewSummary = m.summary
            m.previewBody = m.body
            m.publish()
        });
    }
}
