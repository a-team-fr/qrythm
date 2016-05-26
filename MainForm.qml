import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3

Rectangle {
    width: 640
    height: 480

    color: "white"

    property alias button1: button1
    property alias button2: button2
    property alias metronome: metronome

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10

        Metronome {
            id: metronome

            anchors.horizontalCenter: parent.horizontalCenter
            bpm: valeurBPM.text*1
        }

        RowLayout {
            id: boutons

            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: button1
                text: qsTr("Start")
                enabled: !metronome.enMarche
            }

            Button {
                id: button2
                text: qsTr("Stop")
                enabled: metronome.enMarche
            }
        }

        RowLayout {
            id: saisieBPM

            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "Battements / mn"
            }
            Rectangle {
                id: fondSaisieBPM
                width: 50
                height: valeurBPM.height
                color: "blue"

                TextEdit {
                    id: valeurBPM

                    anchors.fill: parent
                    text: "60"
                    focus: true
                    color: "white"
                }
            }
        }
    }

}
