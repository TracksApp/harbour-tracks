import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Tracks")
    }

    CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("../pages/AddForm.qml"), {dataContainer: mainWindow.firstPage})
                mainWindow.activate()
            }
        }
    }
}
