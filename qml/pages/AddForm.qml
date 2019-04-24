import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: page

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
                placeholderText: "Task description"
                label: "Task description"

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: note.focus = true
            }

            TextArea {
                id: note
                width: parent.width
                height: 300

                placeholderText: "Note"
                label: "Note"

                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            ComboBox {
                id: context
                width: parent.width
                label: "Context"

                menu: ContextMenu {
                    Repeater {
                        model: contextList
                        MenuItem {
                            text: name
                        }
                    }
                }
            }
        }
    }

    onAccepted: {
        addTaskToTracks(description.text)
    }

    function addTaskToTracks(description) {
        var contextId = getContextIdFromName(context.value);

        /*var parser = new Qt.DOMParser();
        var req = parser.parseFromString("<todo></todo>", "text/xml");
        var descr = req.createElement("description");

        var s = new XMLSerializer();
        console.log(s.serializeToString(req));*/

        request("todos.xml", "post", "<todo><description>" + description + "</description><notes>" + note.text + "</notes><context_id>" + contextId + "</context_id></todo>", function(doc) {
            var m = messageNotification.createObject(null);
            if (doc.status === 201) {
                m.body = "Task " + description + " added to context " + context.value;
                m.summary = "Tracks task added"
            }
            else {
                m.body = "Adding task failed";
                m.summary = "Tracks task adding failed"
            }
            m.previewSummary = m.summary
            m.previewBody = m.body
            m.publish()
        });
    }
}
