import QtQuick 2.0
import QtMultimedia 5.6
import Qt.labs.settings 1.0

Rectangle {
    id: metronome

    property int marge: 10
    property int bpm: 60
    property int tempsParMesure: 2
    property int temps: 0
    property bool modeSilencieux: false
    property double volumeSonore: 0.0
    property int nombreMesures: 0
    property bool afficheNombreMesures: true
    property alias timer: timerAnimation
    property alias enMarche: timerAnimation.running
    property double msStartTime : new Date().getTime()
    property double msInTimeTolerance : 50

    height: fondMetronome.height+2*marge
    width: fondMetronome.width+2*marge

    Settings {
        id: settings
        property alias bpm: metronome.bpm
        property alias tempsParMesure: metronome.tempsParMesure
        property alias modeSilencieux: metronome.modeSilencieux
        property alias volumeSonore: metronome.volumeSonore
        property alias afficheNombreMesures: metronome.afficheNombreMesures
    }

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
            duration: timerAnimation.interval
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

        Rectangle {
            id: nombreMesures

            x: fondMetronome.bordDroitEcran-width
            y: fondMetronome.bordBasEcran-height-10
            width: textNombreMesures.width+metronome.marge
            height: width
            radius: width/2
            color: "black"
            visible: metronome.afficheNombreMesures && metronome.enMarche

            Text {
                id: textNombreMesures
                anchors.centerIn: parent
                text: metronome.nombreMesures
                color: "white"
            }
        }
    }

    Timer {
        // Timer animation est décalé de 1/2 mesure
        id: timerAnimation

        interval: 60000/bpm
        repeat: true
        onTriggered: {
            timerSound.start() // il est plus court que 1/2 mesure
            affichageAiguille.switchState ()
            timerMetronome.start()
            // msStartTime créé avant le timer pour pouvoir mesurer le plus ou moins
            metronome.msStartTime = (new Date().getTime()) + timerMetronome.interval;
        }

    }

    Timer {
        // Timer Metronome, depend de l'animation: 1/2 mesure plus tard
        id: timerMetronome
        interval: timerAnimation.interval/2
        repeat: false

        onTriggered: {
            metronome.temps = metronome.temps+1
            metronome.nombreMesures = metronome.nombreMesures+1
            metronome.temps=(metronome.temps>metronome.tempsParMesure) ? 1 : metronome.temps
            //metronome.msStartTime = new Date().getTime();
        }
    }

    Timer{
        // Le son est activé à la moitie du timer (moins le delai du son)
        // Quand l'aiguille passe au centre de l'animation
        id: timerSound
        interval: timerMetronome.interval - sonClair.delay
        repeat: false
        onTriggered: jouerSon()
    }

    SoundEffect {
        id: sonClair
        property int delay: 50 // delay between the begining of the son and maximum noise (approx)
        source: "qrc:/Sons/sons/son_clair.wav"
        muted: metronome.modeSilencieux
        volume: metronome.volumeSonore
    }

    SoundEffect {
        id: sonGrave
        source: "qrc:/Sons/sons/son_grave.wav"
        muted: metronome.modeSilencieux
        volume: metronome.volumeSonore
    }

    function marche() {
        temps= 0
        metronome.nombreMesures=0
        metronome.msStartTime = new Date().getTime();
        timerAnimation.start()
        console.log("Mise en route du métronome !")
    }

    function arret() {
        timerAnimation.stop()
        console.log("Arrêt du métronome !")
    }

    function jouerSon () {
        var tempsEnCours = temps
        if ((tempsEnCours==1) && (metronome.tempsParMesure>1))
            sonClair.play ()
        else
            sonGrave.play ()
    }

    function isInTime(){
        var time = (new Date().getTime() - metronome.msStartTime) % timerMetronome.interval;
        //console.log(time);
        if ((time > metronome.msInTimeTolerance) && (time < (timerMetronome.interval - metronome.msInTimeTolerance )))
            return false;
        return true;
    }

    function errorOnBeat(){
        var time = (new Date().getTime() - metronome.msStartTime);
        return time;
    }

}
