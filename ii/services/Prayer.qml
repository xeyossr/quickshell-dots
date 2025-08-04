pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common

Singleton {
    id: root

    readonly property int fetchInterval: Config.options.bar.prayer.fetchInterval * 60 * 1000
    readonly property string city: Config.options.bar.prayer.city
    readonly property string country: Config.options.bar.prayer.country
    readonly property string method: Config.options.bar.prayer.method

    property var data: ({
        Fajr: "N/A",
        Dhuhr: "N/A",
        Asr: "N/A",
        Maghrib: "N/A",
        Isha: "N/A",
        Sunrise: "N/A",
        Midnight: "N/A",
        Firstthird: "N/A",
        Lastthird: "N/A"
    })

    function refineData(result) {
        const timings = result?.data?.timings;
        if (!timings) {
            console.error("[PrayerService] Timings data is missing or invalid.");
            return;
        }

        root.data = {
            Fajr: timings.Fajr || "N/A",
            Dhuhr: timings.Dhuhr || "N/A",
            Asr: timings.Asr || "N/A",
            Maghrib: timings.Maghrib || "N/A",
            Isha: timings.Isha || "N/A",
            Sunrise: timings.Sunrise || "N/A",
            Midnight: timings.Midnight || "N/A",
            Firstthird: timings.Firstthird || "N/A",
            Lastthird: timings.Lastthird || "N/A"
        };
    }

    function getData() {
        const now = new Date();
        const day = String(now.getDate()).padStart(2, '0');
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const year = now.getFullYear();
        const formattedDate = `${day}-${month}-${year}`;

        const address = `${formatCityName(city)},+${formatCityName(country)}`;
        const apiUrl = `https://api.aladhan.com/v1/timingsByAddress/${formattedDate}?address=${address}&method=${method}`;

        const command = `curl -s "${apiUrl}" | jq '.'`;
        console.info("[PrayerService] Fetching with command:", command);

        fetcher.command[2] = command;
        fetcher.running = true;
    }

    function formatCityName(name) {
        return name.trim().replace(/\s+/g, "+");
    }

    Component.onCompleted: root.getData()

    Connections {
        target: Config.options.bar.prayer
        onCityChanged: root.getData()
        onCountryChanged: root.getData()
        onMethodChanged: root.getData()
        onFetchIntervalChanged: {
            intervalTimer.interval = root.fetchInterval;
        }
    }

    Timer {
        id: intervalTimer
        running: true
        repeat: true
        interval: root.fetchInterval
        triggeredOnStart: true
        onTriggered: root.getData()
    }

    Process {
        id: fetcher
        command: ["bash", "-c", ""]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.length === 0) {
                    console.error("[PrayerService] Empty response");
                    return;
                }
                try {
                    const parsed = JSON.parse(text);
                    if (parsed?.status === "OK") {
                        root.refineData(parsed);
                    } else {
                        console.error("[PrayerService] API status not OK:", parsed?.status);
                    }
                } catch (e) {
                    console.error(`[PrayerService] Failed to parse response: ${e.message}`);
                }
            }
        }
    }
}
