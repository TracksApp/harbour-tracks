import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem {
                text: qsTr("Add task")
                onClicked: pageStack.push(Qt.resolvedUrl("AddForm.qml"))
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    getContextsFromTracks();
                }
            }
        }

        width: parent.width;
        height: parent.height

        SilicaListView {
            header: PageHeader {
                title: qsTr("Contexts")
            }

            ViewPlaceholder {
                enabled: contextList.count == 0
                text: qsTr("Nothing here")
                hintText: qsTr("Check your settings")
            }

            width: parent.width
            height: parent.height
            model: contextList
            delegate: ListItem {
                width: parent.width
                height: Theme.itemSizeMedium

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("TaskList.qml"), {context: name})
                }

                Label { text: name }
            }
            Component.onCompleted: {
              getContextsFromTracks();
            }
        }
    }
}
