import QtQuick 2.0


Image {
    id: imageAiguille

    property int maxDevitation: 30

    source: "qrc:/Images/images/aiguille.png"
    transformOrigin: Item.Bottom

    states:[
        State{
            name: "left"
            PropertyChanges {
                target: imageAiguille
                rotation:-imageAiguille.maxDevitation
            }
        },
        State{
            name: "right"
            PropertyChanges {
                target: imageAiguille
                rotation:imageAiguille.maxDevitation
            }
        }
    ]
    transitions:Transition{
        NumberAnimation { properties: "rotation"; easing.type: Easing.InOutBounce}
    }

    function switchState ()
    {
        if (state == "left") state = "right";
        else state = "left";
    }
}
