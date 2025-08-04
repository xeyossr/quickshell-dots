pragma ComponentBehavior: Bound
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Quickshell
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    property real margin: 5
    property bool hovered: false
    implicitWidth: rowLayout.implicitWidth + margin * 2
    implicitHeight: rowLayout.implicitHeight

    hoverEnabled: true

    // Değişkenler
    property string nextPrayerName: ""
    property string timeLeft: ""

    RowLayout {
        id: rowLayout
        anchors.centerIn: parent

        MaterialSymbol {
            fill: 0
            text: PrayerIcons.nameToSymbol[nextPrayerName]
            iconSize: Appearance.font.pixelSize.large
            color: Appearance.colors.colOnLayer1
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.colOnLayer1
            text: `${nextPrayerName}  ${timeLeft}`
            Layout.alignment: Qt.AlignVCenter
        }
    }

    Timer {
        id: updateTimer
        interval: 60 * 1000
        running: true
        repeat: true
        onTriggered: updateNextPrayer()
    }

    Component.onCompleted: updateNextPrayer()

    function updateNextPrayer() {
        if (!Prayer.data) return;
        const result = findNextPrayer(Prayer.data);
        nextPrayerName = result.name;
        timeLeft = result.timeLeft;
    }


    function findNextPrayer(data) {
        if (!data) return { name: "", timeLeft: "" };

        const keys = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha", "Midnight", "Firstthird", "Lastthird"];
        const now = new Date();

        for (let i = 0; i < keys.length; ++i) {
            const timeStr = data[keys[i]];
            if (!timeStr || typeof timeStr !== "string" || !timeStr.includes(":")) continue;

            const parts = timeStr.split(":");
            if (parts.length !== 2) continue;

            const hour = parseInt(parts[0], 10);
            const minute = parseInt(parts[1], 10);
            if (isNaN(hour) || isNaN(minute)) continue;

            const prayerTime = new Date();
            prayerTime.setHours(hour);
            prayerTime.setMinutes(minute);
            prayerTime.setSeconds(0);
            prayerTime.setMilliseconds(0);

            if (prayerTime > now) {
                return { name: keys[i], timeLeft: getTimeLeft(prayerTime) };
            }
        }

        // Gün bitti, yarının Fajr'ına bak
        const fajrStr = data["Fajr"];
        const fajrParts = fajrStr?.split(":") || ["05", "00"];
        const hour = parseInt(fajrParts[0], 10);
        const minute = parseInt(fajrParts[1], 10);
        if (isNaN(hour) || isNaN(minute)) return { name: "", timeLeft: "" };

        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        tomorrow.setHours(hour);
        tomorrow.setMinutes(minute);
        tomorrow.setSeconds(0);
        tomorrow.setMilliseconds(0);

        return { name: "Fajr", timeLeft: getTimeLeft(tomorrow) };
    }


    function getTimeLeft(target) {
        const now = new Date();
        const diff = target - now;

        if (diff <= 0) return "0m";

        const h = Math.floor(diff / (1000 * 60 * 60));
        const m = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));

        if (h > 0 && m === 0) {
            return `${h}h`;
        } else if (h > 0) {
            return `${h}h ${m}m`;
        } else {
            return `${m}m`;
        }
    }

    LazyLoader {
        id: popupLoader
        active: root.containsMouse
        component: PopupWindow {
            id: popupWindow
            visible: true
            implicitWidth: prayerPopup.implicitWidth
            implicitHeight: prayerPopup.implicitHeight
            anchor.item: root
            anchor.edges: Edges.Top
            anchor.rect.x: (root.implicitWidth - popupWindow.implicitWidth) / 2
            anchor.rect.y: Config.options.bar.bottom ? 
                (-prayerPopup.implicitHeight - 15) :
                (root.implicitHeight + 15)
            color: "transparent"
            PrayerPopup {
                id: prayerPopup
            }
        }
    }

    Connections {
        target: Prayer
        onDataChanged: updateNextPrayer()
    }   

}
