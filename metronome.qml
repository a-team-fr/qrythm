import QtQuick 2.0
import QtMultimedia 5.6

Rectangle {
    id: metronome

    property int marge: 10
    property int bpm: 60
    property int tempsParMesure: 2
    property int temps: 0
    property alias timer: timerMetronome
    property alias enMarche: timerMetronome.running

    height: fondMetronome.height+2*marge
    width: fondMetronome.width+2*marge


    BorderImage {
        id: fondMetronome

        property int bordGaucheEcran: 15
        property int bordDroitEcran: 145
        property int bordHautEcran: 15
        property int bordBasEcran: 85

        x: metronome.marge
        y: metronome.marge
        width: 200
        height: 100
        border.bottom: 15
        border.top: 15
        border.right: 55
        border.left: 15
        verticalTileMode: BorderImage.Round
        horizontalTileMode: BorderImage.Round
        source: "qrc:/Images/images/fond_metronome_electronique.png"

        Image {
            id: affichageTempsParMesure
            x: fondMetronome.bordGaucheEcran
            y: fondMetronome.bordHautEcran

            visible: (metronome.tempsParMesure>0) && (metronome.tempsParMesure<=9)

            source: "qrc:/Images/images/Chiffre%1.png".arg (metronome.tempsParMesure)
        }

        Aiguille {
            id: affichageAiguille

            x: fondMetronome.bordGaucheEcran+(fondMetronome.bordDroitEcran-fondMetronome.bordGaucheEcran)/2
            y: fondMetronome.bordHautEcran

            //visible: metronome.enMarche
        }

        TempsMesure {
            id: tempsMesure

            x: fondMetronome.bordGaucheEcran
            y: fondMetronome.bordBasEcran - height
            tempsEnCours: temps
            tempsParMesure: metronome.tempsParMesure
        }

        Text {
            id: battement

            x: fondMetronome.bordDroitEcran-width
            y: fondMetronome.bordHautEcran
            text: metronome.bpm
        }
    }

    Timer {
        id: timerMetronome


        interval: 60000/bpm
        repeat: true
        onTriggered: {
            metronome.temps = metronome.temps+1
            metronome.temps=(metronome.temps>metronome.tempsParMesure) ? 1 : metronome.temps
            jouerSon()
            affichageAiguille.switchState ()
        }
    }

    SoundEffect {
        id: sonClair
        source: "qrc:/Sons/sons/son_clair.wav"
    }

    SoundEffect {
        id: sonGrave
        source: "qrc:/Sons/sons/son_grave.wav"
    }

    function marche() {
        temps= 0
        timerMetronome.start()
        console.log("Mise en route du métronome !")
    }

    function arret() {
        timerMetronome.stop()
        console.log("Arrêt du métronome !")
    }

    function jouerSon () {
        var tempsEnCours = temps
        if ((tempsEnCours==1) && (metronome.tempsParMesure>1))
            sonClair.play ()
        else
            sonGrave.play ()
    }

}
