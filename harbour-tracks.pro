# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-tracks

CONFIG += sailfishapp

SOURCES += src/harbour-tracks.cpp

DISTFILES += qml/harbour-tracks.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-tracks.changes.in \
    rpm/harbour-tracks.changes.run.in \
    rpm/harbour-tracks.spec \
    rpm/harbour-tracks.yaml \
    translations/*.ts \
    harbour-tracks.desktop \
    qml/pages/AddForm.qml \
    qml/pages/SettingsPage.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-tracks-fi.ts
TRANSLATIONS += translations/harbour-tracks-fr.ts

HEADERS +=
