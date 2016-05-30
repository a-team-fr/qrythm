import QtQuick 2.0

Image {
    id: imageAiguille

    property int angleMin: 150
    property int angleMax: 210
    property int angleEnCours: 180

    source: "qrc:/Images/images/aiguille.png"

    transform: Rotation {
        id: rotationAiguille
        origin.x: imageAiguille.horizontalCenter; origin.y: imageAiguille.top;
        angle: angleEnCours

        axis {x: 0; y: 0; z: 1}
//        Behavior on angle {
//            SpringAnimation { spring: 1; damping: 0.2; modulus: 360 }
//        }
    }

    function actualisePosition ()
    {
        if (angleEnCours>angleMin) {
            angleEnCours=angleMin
        }
        else if (angleEnCours<angleMax) {
            angleEnCours=angleMax
        }
        rotationAiguille.angle= angleEnCours
//        console.log ("Rotation de l'aiguille sur l'angle %1".arg (angleEnCours))
    }
}
