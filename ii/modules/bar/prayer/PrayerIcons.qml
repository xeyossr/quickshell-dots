pragma Singleton
import Quickshell

Singleton {
    readonly property var nameToSymbol: ({
        "Fajr": "dark_mode",       
        "Sunrise": "wb_twilight",   
        "Dhuhr": "sunny",           
        "Asr": "light_mode",       
        "Maghrib": "bedtime",     
        "Isha": "nights_stay",      
        "Midnight": "mode_night",   
        "Firstthird": "bedtime_off",
        "Lastthird": "brightness_2" 
    })
}
