import QtQuick 2.0
import QtQuick.Layouts 1.3

RowLayout {
    id: tempsMesure

    property int tempsEnCours: 1
    property int tempsParMesure: 4

    spacing: 3

    visible: (tempsParMesure<=12)

    Repeater {
        model: tempsParMesure

        Rectangle {
            id: temps1

            width: 8
            height: 8
            color: (tempsEnCours===index+1)?"black": "transparent"
            border.color: "black"
            border.width: 1
            radius: 4
            visible: (tempsParMesure>=index)
        }
    }
}
