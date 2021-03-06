import QtQuick 2.6
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

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
            tempsParMesure: valeurTempsParMesure.text*1
            modeSilencieux: volumeSonore.modeSilencieux
            volumeSonore: sliderVolumeSonore.value
            afficheNombreMesures: nombreMesures.afficher

            Component.onCompleted: {
                console.log("Métronome créé")
                valeurBPM.text= metronome.bpm
                valeurTempsParMesure.text=metronome.tempsParMesure
                volumeSonore.modeSilencieux=metronome.modeSilencieux
                sliderVolumeSonore.value=metronome.volumeSonore
                nombreMesures.afficher=metronome.afficheNombreMesures
            }

            Component.onDestruction: {
                console.log("Métronome détruit")
            }

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
                color: "lightgrey"

                TextEdit {
                    id: valeurBPM

                    anchors.fill: parent
                    text: "60"
                    focus: true
                    color: "white"
                    //inputMask: "999"
                    //validator: IntValidator {bottom: 40; top: 200;}
                }
            }
        }

        RowLayout {
            id: saisieTempsParMesure

            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "Temps / mesure"
            }
            Rectangle {
                id: fondSaisieTempsParMesure
                width: 50
                height: valeurTempsParMesure.height
                color: "lightgrey"

                TextEdit {
                    id: valeurTempsParMesure

                    anchors.fill: parent
                    text: "4"
                    focus: true
                    color: "white"
                    //inputMask: "9"
                }
            }
        }
        RowLayout {
            id: volumeSonore

            property alias modeSilencieux: modeSilencieux.checked

            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "Mode silencieux"
            }

            Switch {
                id: modeSilencieux
                checked: false
            }
            Text {
                text: "Volume"
            }
            Slider {
                id: sliderVolumeSonore

                width: 50
                enabled: !metronome.modeSilencieux
                minimumValue: 0.1
                maximumValue: 1.0
                value: metronome.volumeSonore
            }
        }
        RowLayout {
            id: nombreMesures

            property alias afficher: voirNombreMesures.checked

            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "Afficher nombre mesures"
            }

            Switch {
                id: voirNombreMesures
                checked: true
            }
        }
        RowLayout {
            id:tap
            Button {
                id: buttonTap
                text: qsTr("Tap")
                enabled: metronome.enMarche
                onClicked:{
                    if (metronome.isInTime())
                        tapResult.text = "bravo"
                    else tapResult.text="loupé!"

                }
            }
            Text{
                id:tapResult
                text:"tapper en rythme"

            }
        }
    }
}
