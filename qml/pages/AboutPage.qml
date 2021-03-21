import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutpage
    SilicaFlickable {
        anchors.fill: parent

        Column {
            id: mainCol
            spacing: Theme.paddingMedium
            anchors.left: parent.left; anchors.leftMargin: Theme.paddingMedium
            anchors.right: parent.right; anchors.rightMargin: Theme.paddingMedium
            PageHeader {
                title: qsTr("About")
            }
/*            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../images/ptl.png"
            } */
            Column {
                anchors.left: parent.left; anchors.right: parent.right
                spacing: Theme.paddingSmall
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeHuge
                    text: qsTr("Tracks")
                }
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                    wrapMode: Text.WordWrap
                    text: qsTr("Version %1").arg(version)
                }
            }
            Label {
                wrapMode: Text.WordWrap
                anchors.left: parent.left; anchors.right: parent.right
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Tracks is a simple client for the Tracks todo application.")
            }
            Label {
                anchors.left: parent.left; anchors.right: parent.right
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                wrapMode: Text.WordWrap
                text: qsTr("Thanking:") +
"\n" + qsTr("– Jyri-Petteri ”ZeiP” Paloposki (author)") +
"\n" + qsTr("– J. Lavoie (German and French translation)") +
"\n" + qsTr("– Allan Nordhøy (Norwegian Bokmål translation)") +
"\n" + qsTr("– Алексей Свистунов (Russian translation)") +
"\n" + qsTr("– Burak Hüseyin Ekseli and Oğuz Ersen (Turkish translation)")
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Hosted Tracks application")
                onClicked: Qt.openUrlExternally("https://www.taskitin.fi/")
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Tracks web page")
                onClicked: Qt.openUrlExternally("https://getontracks.org/")
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("GitHub (source codes and issues)")
                onClicked: Qt.openUrlExternally("https://github.com/ZeiP/harbour-tracks")
            }
        }

        VerticalScrollDecorator {}
    }
}
