import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    readonly property real margin: 10
    implicitWidth: columnLayout.implicitWidth + margin * 2
    implicitHeight: columnLayout.implicitHeight + margin * 2
    color: Appearance.colors.colLayer0
    radius: Appearance.rounding.small
    border.width: 1
    border.color: Appearance.colors.colLayer0Border
    clip: true

    ColumnLayout {
        id: columnLayout
        spacing: 10
        anchors.centerIn: root
        implicitWidth: Math.max(header.implicitWidth, gridLayout.implicitWidth)
        implicitHeight: gridLayout.implicitHeight

        // Header
        RowLayout {
            id: header
            spacing: 5
            Layout.alignment: Qt.AlignHCenter
            MaterialSymbol {
                fill: 0
                text: "location_on"
                iconSize: Appearance.font.pixelSize.huge
            }

            StyledText {
                text: Config.options.bar.prayer.city || "—"
                font.pixelSize: Appearance.font.pixelSize.title
                font.family: Appearance.font.family.title
                color: Appearance.colors.colOnLayer0
            }
        }

        // Namaz vakitleri
        GridLayout {
            id: gridLayout
            columns: 3
            rowSpacing: 5
            columnSpacing: 10
            uniformCellWidths: true

            PrayerCard {
                title: "Fajr"
                symbol: PrayerIcons.nameToSymbol.Fajr
                value: Prayer.data.Fajr
            }
            PrayerCard {
                title: "Sunrise"
                symbol: PrayerIcons.nameToSymbol.Sunrise
                value: Prayer.data.Sunrise
            }
            PrayerCard {
                title: "Dhuhr"
                symbol: PrayerIcons.nameToSymbol.Dhuhr
                value: Prayer.data.Dhuhr
            }
            PrayerCard {
                title: "Asr"
                symbol: PrayerIcons.nameToSymbol.Asr
                value: Prayer.data.Asr
            }
            PrayerCard {
                title: "Maghrib"
                symbol: PrayerIcons.nameToSymbol.Maghrib
                value: Prayer.data.Maghrib
            }
            PrayerCard {
                title: "Isha"
                symbol: PrayerIcons.nameToSymbol.Isha
                value: Prayer.data.Isha
            }
            PrayerCard {
                title: "Midnight"
                symbol: PrayerIcons.nameToSymbol.Midnight
                value: Prayer.data.Midnight
            }
            PrayerCard {
                title: "Firstthird"
                symbol: PrayerIcons.nameToSymbol.Firstthird
                value: Prayer.data.Firstthird
            }
            PrayerCard {
                title: "Lastthird"
                symbol: PrayerIcons.nameToSymbol.Lastthird
                value: Prayer.data.Lastthird
            }
        }
    }
}
