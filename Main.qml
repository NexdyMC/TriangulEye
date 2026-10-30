import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 660
    height: 530
    minimumWidth: 600
    minimumHeight: 490
    visible: true
    title: qsTr("Calculator Stronghold - TriangulEye")

    // ==========================================
    // PALET WARNA MODERN ENDER VOID
    // ==========================================
    readonly property color bgApp: "#12131A"           // Dark Charcoal Base
    readonly property color bgHeader: "#181B26"        // Tab bar background
    readonly property color bgCard: "#191C28"          // Card background
    readonly property color bgInput: "#0E1017"         // Input box dark
    readonly property color borderMuted: "#262C3E"      // Subtle border
    readonly property color blazeOrange: "#FB923C"     // Accent Eye 1
    readonly property color enderCyan: "#00F5D4"       // Accent Eye 2 / Active Tab
    readonly property color eyeGreen: "#10B981"        // Overworld / Success
    readonly property color netherRed: "#EF4444"       // Nether / Reload Button
    readonly property color netherPurple: "#A855F7"    // Nether Dimension
    readonly property color textPrimary: "#F8FAFC"     // Bright White
    readonly property color textMuted: "#94A3B8"       // Muted text

    // ==========================================
    // STATE DATA
    // ==========================================
    property int currentTab: 0 // 0: Manual, 1: F3 + C, 2: View, 3: About

    // Data Lemparan 1 & 2
    property real t1X: controller.t1X
    property real t1Z: controller.t1Z
    property real t1Yaw: controller.t1Yaw

    property real t2X: controller.t2X
    property real t2Z: controller.t2Z
    property real t2Yaw: controller.t2Yaw

    // Data F3+C Command Strings
    property string f3CommandA: controller.f3CommandA
    property string f3CommandB: controller.f3CommandB

    // Hasil Koordinat Overworld & Nether
    property int overworldBlockX: controller.overworldBlockX
    property int overworldBlockZ: controller.overworldBlockZ
    property int overworldChunkX: controller.overworldChunkX
    property int overworldChunkZ: controller.overworldChunkZ
    property int overworldInChunkX: controller.overworldInChunkX
    property int overworldInChunkZ: controller.overworldInChunkZ

    property int netherBlockX: controller.netherBlockX
    property int netherBlockZ: controller.netherBlockZ
    property int netherChunkX: controller.netherChunkX
    property int netherChunkZ: controller.netherChunkZ
    property int netherInChunkX: controller.netherInChunkX
    property int netherInChunkZ: controller.netherInChunkZ

    property real distanceBlocks: controller.distanceBlocks
    property int netherSavedBlocks: controller.netherSavedBlocks
    property bool isCalculated: controller.isCalculated
    property string calcError: controller.calcError

    // Radar Canvas Interaktif
    property real radarZoom: 0.045
    property real radarPanX: 0.0
    property real radarPanY: 0.0
    property real cursorBlockX: 0
    property real cursorBlockZ: 0
    property string cursorRingName: "Origin Area"

    Component.onCompleted: calculateStronghold()

    // Background Utama
    Rectangle {
        anchors.fill: parent
        color: bgApp

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // ==========================================
            // 1. BILAH TAB ATAS
            // ==========================================
            Rectangle {
                Layout.fillWidth: true
                height: 48
                color: bgHeader
                border.color: "#222738"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    // BADGE LOGO ENDER EYE
                    Rectangle {
                        width: 30
                        height: 30
                        radius: 15
                        color: "#082B24"
                        border.color: enderCyan
                        border.width: 2

                        Image {
                            anchors.centerIn: parent
                            source: "assets/images/ender_eye.png"
                            width: 18
                            height: 18
                            sourceSize.width: 18
                            sourceSize.height: 18
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }
                    }

                    Text {
                        text: "Calculator Stronghold"
                        color: textPrimary
                        font.bold: true
                        font.pixelSize: 13
                        Layout.rightMargin: 10
                    }

                    // TAB 0: MANUAL
                    Rectangle {
                        height: 32; width: 85; radius: 6
                        color: window.currentTab === 0 ? "#252B3D" : "transparent"
                        border.color: window.currentTab === 0 ? enderCyan : "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: "Manual"
                            color: window.currentTab === 0 ? "#FFFFFF" : textMuted
                            font.bold: window.currentTab === 0
                            font.pixelSize: 12
                        }
                        HoverHandler { cursorShape: Qt.PointingHandCursor }
                        TapHandler { onTapped: window.currentTab = 0 }
                    }

                    // TAB 1: F3 + C
                    Rectangle {
                        height: 32; width: 85; radius: 6
                        color: window.currentTab === 1 ? "#252B3D" : "transparent"
                        border.color: window.currentTab === 1 ? enderCyan : "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: "F3 + C"
                            color: window.currentTab === 1 ? "#FFFFFF" : textMuted
                            font.bold: window.currentTab === 1
                            font.pixelSize: 12
                        }
                        HoverHandler { cursorShape: Qt.PointingHandCursor }
                        TapHandler { onTapped: window.currentTab = 1 }
                    }

                    // TAB 2: VIEW (RADAR)
                    Rectangle {
                        height: 32; width: 85; radius: 6
                        color: window.currentTab === 2 ? "#252B3D" : "transparent"
                        border.color: window.currentTab === 2 ? enderCyan : "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: "View"
                            color: window.currentTab === 2 ? "#FFFFFF" : textMuted
                            font.bold: window.currentTab === 2
                            font.pixelSize: 12
                        }
                        HoverHandler { cursorShape: Qt.PointingHandCursor }
                        TapHandler { onTapped: window.currentTab = 2 }
                    }

                    // TAB 3: ABOUT
                    Rectangle {
                        height: 32; width: 85; radius: 6
                        color: window.currentTab === 3 ? "#252B3D" : "transparent"
                        border.color: window.currentTab === 3 ? enderCyan : "transparent"
                        Text {
                            anchors.centerIn: parent
                            text: "About"
                            color: window.currentTab === 3 ? "#FFFFFF" : textMuted
                            font.bold: window.currentTab === 3
                            font.pixelSize: 12
                        }
                        HoverHandler { cursorShape: Qt.PointingHandCursor }
                        TapHandler { onTapped: window.currentTab = 3 }
                    }

                    Item { Layout.fillWidth: true }
                }
            }

            // ==========================================
            // 2. AREA TENGAH SESUAI TAB YANG AKTIF
            // ==========================================
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // ------------------------------------------
                // TAB 0: MODE MANUAL (DENGAN GRIDLAYOUT PRESISI)
                // ------------------------------------------
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 14
                    radius: 8
                    color: bgCard
                    border.color: borderMuted
                    visible: window.currentTab === 0

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Text {
                            text: "Mode Manual"
                            font.pixelSize: 15
                            font.bold: true
                            color: textPrimary
                            Layout.alignment: Qt.AlignHCenter
                        }

                        // GRIDLAYOUT UNTUK FORM INPUT (KOLOM OTOMATIS SEJAJAR 100%)
                        GridLayout {
                            id: manualGrid
                            Layout.fillWidth: true
                            columns: 4
                            columnSpacing: 10
                            rowSpacing: 8

                            // BARIS 0: HEADER KOLOM
                            Item { Layout.preferredWidth: 100; height: 18 }
                            Text {
                                text: "Coord X"
                                font.bold: true; font.pixelSize: 12; color: textMuted
                                Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                text: "Coord Z"
                                font.bold: true; font.pixelSize: 12; color: textMuted
                                Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                text: "Angle (Yaw °)"
                                font.bold: true; font.pixelSize: 12; color: textMuted
                                Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter
                            }

                            // BARIS 1: ENDER EYE 1
                            Text {
                                text: "Ender Eye 1:"
                                font.bold: true; font.pixelSize: 12; color: blazeOrange
                                Layout.preferredWidth: 100; Layout.alignment: Qt.AlignVCenter
                            }
                            Rectangle {
                                Layout.fillWidth: true; height: 34; radius: 6; color: bgInput; border.color: borderMuted
                                TextInput {
                                    anchors.fill: parent; anchors.margins: 6
                                    verticalAlignment: TextInput.AlignVCenter; horizontalAlignment: TextInput.AlignHCenter
                                    color: textPrimary; font.pixelSize: 12; font.family: "Consolas, monospace"
                                    text: window.t1X.toFixed(1)
                                    onTextEdited: { var v = parseFloat(text); if (!isNaN(v)) controller.t1X = v }
                                }
                            }
                            Rectangle {
                                Layout.fillWidth: true; height: 34; radius: 6; color: bgInput; border.color: borderMuted
                                TextInput {
                                    anchors.fill: parent; anchors.margins: 6
                                    verticalAlignment: TextInput.AlignVCenter; horizontalAlignment: TextInput.AlignHCenter
                                    color: textPrimary; font.pixelSize: 12; font.family: "Consolas, monospace"
                                    text: window.t1Z.toFixed(1)
                                    onTextEdited: { var v = parseFloat(text); if (!isNaN(v)) controller.t1Z = v }
                                }
                            }
                            Rectangle {
                                Layout.fillWidth: true; height: 34; radius: 6; color: bgInput; border.color: blazeOrange
                                TextInput {
                                    anchors.fill: parent; anchors.margins: 6
                                    verticalAlignment: TextInput.AlignVCenter; horizontalAlignment: TextInput.AlignHCenter
                                    color: blazeOrange; font.bold: true; font.pixelSize: 12; font.family: "Consolas, monospace"
                                    text: window.t1Yaw.toFixed(1)
                                    onTextEdited: { var v = parseFloat(text); if (!isNaN(v)) controller.t1Yaw = v }
                                }
                            }

                            // BARIS 2: ENDER EYE 2
                            Text {
                                text: "Ender Eye 2:"
                                font.bold: true; font.pixelSize: 12; color: enderCyan
                                Layout.preferredWidth: 100; Layout.alignment: Qt.AlignVCenter
                            }
                            Rectangle {
                                Layout.fillWidth: true; height: 34; radius: 6; color: bgInput; border.color: borderMuted
                                TextInput {
                                    anchors.fill: parent; anchors.margins: 6
                                    verticalAlignment: TextInput.AlignVCenter; horizontalAlignment: TextInput.AlignHCenter
                                    color: textPrimary; font.pixelSize: 12; font.family: "Consolas, monospace"
                                    text: window.t2X.toFixed(1)
                                    onTextEdited: { var v = parseFloat(text); if (!isNaN(v)) controller.t2X = v }
                                }
                            }
                            Rectangle {
                                Layout.fillWidth: true; height: 34; radius: 6; color: bgInput; border.color: borderMuted
                                TextInput {
                                    anchors.fill: parent; anchors.margins: 6
                                    verticalAlignment: TextInput.AlignVCenter; horizontalAlignment: TextInput.AlignHCenter
                                    color: textPrimary; font.pixelSize: 12; font.family: "Consolas, monospace"
                                    text: window.t2Z.toFixed(1)
                                    onTextEdited: { var v = parseFloat(text); if (!isNaN(v)) controller.t2Z = v }
                                }
                            }
                            Rectangle {
                                Layout.fillWidth: true; height: 34; radius: 6; color: bgInput; border.color: enderCyan
                                TextInput {
                                    anchors.fill: parent; anchors.margins: 6
                                    verticalAlignment: TextInput.AlignVCenter; horizontalAlignment: TextInput.AlignHCenter
                                    color: enderCyan; font.bold: true; font.pixelSize: 12; font.family: "Consolas, monospace"
                                    text: window.t2Yaw.toFixed(1)
                                    onTextEdited: { var v = parseFloat(text); if (!isNaN(v)) controller.t2Yaw = v }
                                }
                            }
                        }

                        // TOMBOL ENTER & RELOAD
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            // Tombol Enter
                            Rectangle {
                                Layout.fillWidth: true; height: 38; radius: 6
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "#059669" }
                                    GradientStop { position: 1.0; color: "#10B981" }
                                }
                                RowLayout {
                                    anchors.centerIn: parent; spacing: 8
                                    Image {
                                        source: "assets/lightning.svg"
                                        width: 14; height: 14
                                        sourceSize.width: 28; sourceSize.height: 28
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text { text: "Enter (Hitung)"; font.bold: true; font.pixelSize: 12; color: "#042F2E" }
                                }
                                HoverHandler { cursorShape: Qt.PointingHandCursor }
                                TapHandler { onTapped: calculateStronghold() }
                            }

                            // Tombol Reload
                            Rectangle {
                                Layout.fillWidth: true; height: 38; radius: 6
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "#DC2626" }
                                    GradientStop { position: 1.0; color: "#EF4444" }
                                }
                                RowLayout {
                                    anchors.centerIn: parent; spacing: 8
                                    Image {
                                        source: "assets/refresh.svg"
                                        width: 14; height: 14
                                        sourceSize.width: 28; sourceSize.height: 28
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text { text: "Reload (Reset)"; font.bold: true; font.pixelSize: 12; color: "#FFFFFF" }
                                }
                                HoverHandler { cursorShape: Qt.PointingHandCursor }
                                TapHandler {
                                    onTapped: {
                                        controller.reset();
                                        radarCanvas.requestPaint();
                                    }
                                }
                            }
                        }

                        Text {
                            text: window.calcError
                            color: netherRed
                            font.pixelSize: 11; font.bold: true
                            visible: window.calcError !== ""
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }

                // ------------------------------------------
                // TAB 1: MODE F3 + C
                // ------------------------------------------
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 14
                    radius: 8
                    color: bgCard
                    border.color: borderMuted
                    visible: window.currentTab === 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 10

                        Text {
                            text: "Mode F3 + C"
                            font.pixelSize: 15
                            font.bold: true
                            color: textPrimary
                            Layout.alignment: Qt.AlignHCenter
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            Text { text: "Command A:"; font.bold: true; font.pixelSize: 12; Layout.preferredWidth: 95; color: blazeOrange }

                            // Kotak Input Tunggal dengan Tombol Paste di Bagian Dalam Kanan
                            Rectangle {
                                Layout.fillWidth: true
                                height: 36
                                radius: 6
                                color: bgInput
                                border.color: inputCmdA.activeFocus ? blazeOrange : borderMuted
                                border.width: inputCmdA.activeFocus ? 1.5 : 1
                                clip: true

                                TextInput {
                                    id: inputCmdA
                                    anchors.left: parent.left
                                    anchors.right: btnPasteA.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 6
                                    verticalAlignment: TextInput.AlignVCenter
                                    color: textPrimary; font.pixelSize: 11; font.family: "Consolas, monospace"
                                    selectByMouse: true
                                    clip: true

                                    Text {
                                        text: "Tempel hasil F3 + C lemparan pertama di sini..."
                                        color: "#475569"; font.pixelSize: 11; visible: !inputCmdA.text
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    onTextChanged: parseF3Command(text, 1)
                                }

                                // Tombol Paste di Dalam Input Box (Sebelah Kanan)
                                Rectangle {
                                    id: btnPasteA
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.rightMargin: 5
                                    width: 72
                                    height: 26
                                    radius: 4
                                    color: pasteBtnAHover.hovered ? "#3B1E0A" : "#231408"
                                    border.color: pasteBtnAHover.hovered ? "#FDBA74" : blazeOrange
                                    border.width: 1

                                    RowLayout {
                                        anchors.centerIn: parent
                                        spacing: 5
                                        Image {
                                            source: "assets/clipboard-solid-full.svg"
                                            width: 11; height: 11
                                            sourceSize.width: 22; sourceSize.height: 22
                                            fillMode: Image.PreserveAspectFit
                                        }
                                        Text {
                                            text: "Paste"
                                            font.bold: true
                                            font.pixelSize: 11
                                            color: blazeOrange
                                        }
                                    }

                                    HoverHandler { id: pasteBtnAHover; cursorShape: Qt.PointingHandCursor }
                                    TapHandler {
                                        onTapped: {
                                            if (typeof Clipboard !== "undefined") {
                                                var clipText = Clipboard.getText();
                                                if (clipText && clipText.trim().length > 0) {
                                                    inputCmdA.text = clipText.trim();
                                                    parseF3Command(clipText.trim(), 1);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            Text { text: "Command B:"; font.bold: true; font.pixelSize: 12; Layout.preferredWidth: 95; color: enderCyan }

                            // Kotak Input Tunggal dengan Tombol Paste di Bagian Dalam Kanan
                            Rectangle {
                                Layout.fillWidth: true
                                height: 36
                                radius: 6
                                color: bgInput
                                border.color: inputCmdB.activeFocus ? enderCyan : borderMuted
                                border.width: inputCmdB.activeFocus ? 1.5 : 1
                                clip: true

                                TextInput {
                                    id: inputCmdB
                                    anchors.left: parent.left
                                    anchors.right: btnPasteB.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 6
                                    verticalAlignment: TextInput.AlignVCenter
                                    color: textPrimary; font.pixelSize: 11; font.family: "Consolas, monospace"
                                    selectByMouse: true
                                    clip: true

                                    Text {
                                        text: "Tempel hasil F3 + C lemparan kedua di sini..."
                                        color: "#475569"; font.pixelSize: 11; visible: !inputCmdB.text
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                    onTextChanged: parseF3Command(text, 2)
                                }

                                // Tombol Paste di Dalam Input Box (Sebelah Kanan)
                                Rectangle {
                                    id: btnPasteB
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.rightMargin: 5
                                    width: 72
                                    height: 26
                                    radius: 4
                                    color: pasteBtnBHover.hovered ? "#0A2F2B" : "#041F1B"
                                    border.color: pasteBtnBHover.hovered ? "#67E8F9" : enderCyan
                                    border.width: 1

                                    RowLayout {
                                        anchors.centerIn: parent
                                        spacing: 5
                                        Image {
                                            source: "assets/clipboard-solid-full.svg"
                                            width: 11; height: 11
                                            sourceSize.width: 22; sourceSize.height: 22
                                            fillMode: Image.PreserveAspectFit
                                        }
                                        Text {
                                            text: "Paste"
                                            font.bold: true
                                            font.pixelSize: 11
                                            color: enderCyan
                                        }
                                    }

                                    HoverHandler { id: pasteBtnBHover; cursorShape: Qt.PointingHandCursor }
                                    TapHandler {
                                        onTapped: {
                                            if (typeof Clipboard !== "undefined") {
                                                var clipText = Clipboard.getText();
                                                if (clipText && clipText.trim().length > 0) {
                                                    inputCmdB.text = clipText.trim();
                                                    parseF3Command(clipText.trim(), 2);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        RowLayout {
                            spacing: 6
                            Image {
                                source: "assets/hint.svg"
                                width: 14; height: 14
                                sourceSize.width: 28; sourceSize.height: 28
                                fillMode: Image.PreserveAspectFit
                            }
                            Text {
                                text: "Tekan F3 + C di Minecraft saat melihat Eye of Ender untuk menyalin perintah koordinat otomatis."
                                color: "#38BDF8"; font.pixelSize: 11
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12

                            Rectangle {
                                Layout.fillWidth: true; height: 36; radius: 6
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "#059669" }
                                    GradientStop { position: 1.0; color: "#10B981" }
                                }
                                RowLayout {
                                    anchors.centerIn: parent; spacing: 8
                                    Image {
                                        source: "assets/search.svg"
                                        width: 14; height: 14
                                        sourceSize.width: 28; sourceSize.height: 28
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text { text: "Search (Cari Stronghold)"; font.bold: true; font.pixelSize: 12; color: "#042F2E" }
                                }
                                HoverHandler { cursorShape: Qt.PointingHandCursor }
                                TapHandler { onTapped: calculateStronghold() }
                            }

                            Rectangle {
                                Layout.fillWidth: true; height: 36; radius: 6
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "#DC2626" }
                                    GradientStop { position: 1.0; color: "#EF4444" }
                                }
                                RowLayout {
                                    anchors.centerIn: parent; spacing: 8
                                    Image {
                                        source: "assets/refresh.svg"
                                        width: 14; height: 14
                                        sourceSize.width: 28; sourceSize.height: 28
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    Text { text: "Reset"; font.bold: true; font.pixelSize: 12; color: "#FFFFFF" }
                                }
                                HoverHandler { cursorShape: Qt.PointingHandCursor }
                                TapHandler {
                                    onTapped: {
                                        inputCmdA.text = ""; inputCmdB.text = "";
                                        controller.reset();
                                        radarCanvas.requestPaint();
                                    }
                                }
                            }
                        }
                    }
                }

                // ------------------------------------------
                // TAB 2: VIEW (CANVAS TACTICAL RADAR & 8 STRONGHOLD RINGS)
                // ------------------------------------------
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 14
                    radius: 8
                    color: "#07080D"
                    border.color: borderMuted
                    visible: window.currentTab === 2
                    clip: true

                    Canvas {
                        id: radarCanvas
                        anchors.fill: parent

                        readonly property var strongholdRings: [
                            { name: "Ring 1", count: 3,  minR: 1280,  maxR: 2816,  color: "#38BDF8" },
                            { name: "Ring 2", count: 6,  minR: 4352,  maxR: 5888,  color: "#818CF8" },
                            { name: "Ring 3", count: 10, minR: 7424,  maxR: 8960,  color: "#A78BFA" },
                            { name: "Ring 4", count: 15, minR: 10496, maxR: 12032, color: "#C084FC" },
                            { name: "Ring 5", count: 21, minR: 13568, maxR: 15104, color: "#E879F9" },
                            { name: "Ring 6", count: 28, minR: 16640, maxR: 18176, color: "#F472B6" },
                            { name: "Ring 7", count: 36, minR: 19712, maxR: 21248, color: "#FB7185" },
                            { name: "Ring 8", count: 9,  minR: 22784, maxR: 24320, color: "#FBBF24" }
                        ]

                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.reset();

                            var w = width;
                            var h = height;
                            var cx = (w / 2) + window.radarPanX;
                            var cy = (h / 2) + window.radarPanY;
                            var s = window.radarZoom;

                            // 1. Grid Adaptif
                            var idealBlockStep = 75 / s;
                            var stepOrder = Math.pow(10, Math.floor(Math.log10(idealBlockStep)));
                            var blockStep = stepOrder;
                            if (idealBlockStep / stepOrder >= 5) {
                                blockStep = stepOrder * 5;
                            } else if (idealBlockStep / stepOrder >= 2) {
                                blockStep = stepOrder * 2;
                            }
                            var pxStep = blockStep * s;

                            ctx.strokeStyle = "#121624";
                            ctx.lineWidth = 1;
                            ctx.beginPath();
                            var startX = ((cx % pxStep) + pxStep) % pxStep;
                            for (var x = startX; x < w; x += pxStep) { ctx.moveTo(x, 0); ctx.lineTo(x, h); }
                            var startY = ((cy % pxStep) + pxStep) % pxStep;
                            for (var y = startY; y < h; y += pxStep) { ctx.moveTo(0, y); ctx.lineTo(w, y); }
                            ctx.stroke();

                            // 2. Lingkaran 8 Ring Stronghold
                            for (var rIdx = 0; rIdx < strongholdRings.length; ++rIdx) {
                                var ring = strongholdRings[rIdx];
                                var rIn = ring.minR * s;
                                var rOut = ring.maxR * s;

                                if (rOut > 2 && rIn < Math.max(w, h) * 3) {
                                    // Arsiran Ring Band Lembut
                                    ctx.save();
                                    ctx.beginPath();
                                    ctx.arc(cx, cy, rOut, 0, Math.PI * 2, false);
                                    ctx.arc(cx, cy, rIn, 0, Math.PI * 2, true);
                                    ctx.closePath();
                                    ctx.fillStyle = ring.color + "14";
                                    ctx.fill();
                                    ctx.restore();

                                    // Batas Dalam & Luar Lingkaran
                                    ctx.strokeStyle = ring.color + "55";
                                    ctx.lineWidth = 1;
                                    ctx.beginPath(); ctx.arc(cx, cy, rIn, 0, Math.PI * 2); ctx.stroke();
                                    ctx.beginPath(); ctx.arc(cx, cy, rOut, 0, Math.PI * 2); ctx.stroke();

                                    // Label Nama Ring
                                    var labelAngle = -Math.PI / 4;
                                    var labelR = (rIn + rOut) / 2;
                                    var lx = cx + Math.cos(labelAngle) * labelR;
                                    var ly = cy + Math.sin(labelAngle) * labelR;
                                    if (lx > 10 && lx < w - 90 && ly > 20 && ly < h - 20 && (rOut - rIn) > 10) {
                                        ctx.font = "bold 9px Consolas, sans-serif";
                                        ctx.fillStyle = ring.color;
                                        ctx.fillText(ring.name + " (" + ring.count + " SH)", lx, ly);
                                    }
                                }
                            }

                            // 3. Sumbu Koordinat Dunia X & Z
                            ctx.strokeStyle = "#25334D";
                            ctx.lineWidth = 1.5;
                            ctx.beginPath();
                            ctx.moveTo(0, cy); ctx.lineTo(w, cy);
                            ctx.moveTo(cx, 0); ctx.lineTo(cx, h);
                            ctx.stroke();

                            // Titik Origin Dunia (0,0)
                            ctx.fillStyle = "#38BDF8";
                            ctx.beginPath(); ctx.arc(cx, cy, 3.5, 0, Math.PI * 2); ctx.fill();

                            // Label Arah Mata Angin
                            ctx.font = "bold 9px Consolas, sans-serif";
                            ctx.fillStyle = "#64748B";
                            var northY = Math.max(16, Math.min(h - 16, 16));
                            var southY = Math.max(16, Math.min(h - 8, h - 8));
                            var westX = Math.max(6, Math.min(w - 60, 6));
                            var eastX = Math.max(6, Math.min(w - 54, w - 54));

                            ctx.fillText("North (-Z)", Math.max(6, Math.min(w - 60, cx + 6)), northY);
                            ctx.fillText("South (+Z)", Math.max(6, Math.min(w - 60, cx + 6)), southY);
                            ctx.fillText("West (-X)", westX, Math.max(14, Math.min(h - 6, cy - 6)));
                            ctx.fillText("East (+X)", eastX, Math.max(14, Math.min(h - 6, cy - 6)));

                            // 4. Vektor Lemparan Ender Eye 1 & 2
                            var p1x = cx + (window.t1X * s);
                            var p1y = cy + (window.t1Z * s);
                            var p2x = cx + (window.t2X * s);
                            var p2y = cy + (window.t2Z * s);

                            var rayLen = Math.max(w, h) * 3;

                            var rad1 = (window.t1Yaw * Math.PI) / 180.0;
                            var dx1 = -Math.sin(rad1);
                            var dz1 = Math.cos(rad1);
                            ctx.strokeStyle = window.blazeOrange;
                            ctx.lineWidth = 2;
                            ctx.beginPath(); ctx.moveTo(p1x, p1y); ctx.lineTo(p1x + (dx1 * rayLen), p1y + (dz1 * rayLen)); ctx.stroke();
                            ctx.fillStyle = window.blazeOrange; ctx.beginPath(); ctx.arc(p1x, p1y, 4.5, 0, 2 * Math.PI); ctx.fill();

                            var rad2 = (window.t2Yaw * Math.PI) / 180.0;
                            var dx2 = -Math.sin(rad2);
                            var dz2 = Math.cos(rad2);
                            ctx.strokeStyle = window.enderCyan;
                            ctx.lineWidth = 2;
                            ctx.beginPath(); ctx.moveTo(p2x, p2y); ctx.lineTo(p2x + (dx2 * rayLen), p2y + (dz2 * rayLen)); ctx.stroke();
                            ctx.fillStyle = window.enderCyan; ctx.beginPath(); ctx.arc(p2x, p2y, 4.5, 0, 2 * Math.PI); ctx.fill();

                            // 5. Target Stronghold Terhitung
                            if (window.isCalculated) {
                                var sx = cx + (window.overworldBlockX * s);
                                var sy = cy + (window.overworldBlockZ * s);

                                var chunkX = cx + (window.overworldChunkX * 16 * s);
                                var chunkZ = cy + (window.overworldChunkZ * 16 * s);
                                var chunkSize = Math.max(4, 16 * s);

                                ctx.strokeStyle = "#4ADE80";
                                ctx.lineWidth = 1.5;
                                ctx.strokeRect(chunkX, chunkZ, chunkSize, chunkSize);
                                ctx.fillStyle = "#334ADE80";
                                ctx.fillRect(chunkX, chunkZ, chunkSize, chunkSize);

                                ctx.strokeStyle = window.eyeGreen;
                                ctx.lineWidth = 2;
                                ctx.beginPath(); ctx.arc(sx, sy, 6, 0, 2 * Math.PI); ctx.stroke();

                                ctx.strokeStyle = "#86EFAC";
                                ctx.lineWidth = 1;
                                ctx.beginPath(); ctx.arc(sx, sy, 11, 0, 2 * Math.PI); ctx.stroke();

                                ctx.fillStyle = "#FFFFFF";
                                ctx.font = "bold 11px sans-serif";
                                ctx.fillText("★ Stronghold [" + window.overworldBlockX + ", " + window.overworldBlockZ + "]", sx + 14, sy - 4);
                            }
                        }

                        onWidthChanged: requestPaint()
                        onHeightChanged: requestPaint()

                        Connections {
                            target: window
                            function onOverworldBlockXChanged() { radarCanvas.requestPaint(); }
                            function onOverworldBlockZChanged() { radarCanvas.requestPaint(); }
                            function onT1XChanged() { radarCanvas.requestPaint(); }
                            function onT1ZChanged() { radarCanvas.requestPaint(); }
                            function onT1YawChanged() { radarCanvas.requestPaint(); }
                            function onT2XChanged() { radarCanvas.requestPaint(); }
                            function onT2ZChanged() { radarCanvas.requestPaint(); }
                            function onT2YawChanged() { radarCanvas.requestPaint(); }
                        }
                    }

                    // MouseArea untuk Pan (Geser) dan Zoom (Scroll)
                    MouseArea {
                        id: canvasMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                        property real lastX: 0
                        property real lastY: 0

                        onPressed: (mouse) => {
                            lastX = mouse.x;
                            lastY = mouse.y;
                        }

                        onPositionChanged: (mouse) => {
                            if (pressed) {
                                window.radarPanX += (mouse.x - lastX);
                                window.radarPanY += (mouse.y - lastY);
                                lastX = mouse.x;
                                lastY = mouse.y;
                                radarCanvas.requestPaint();
                            }

                            var cx = (radarCanvas.width / 2) + window.radarPanX;
                            var cy = (radarCanvas.height / 2) + window.radarPanY;
                            var s = window.radarZoom;
                            var bx = Math.round((mouse.x - cx) / s);
                            var bz = Math.round((mouse.y - cy) / s);
                            window.cursorBlockX = bx;
                            window.cursorBlockZ = bz;

                            var dist = Math.sqrt(bx * bx + bz * bz);
                            var rName = "Wilayah Origin";
                            var rings = radarCanvas.strongholdRings;
                            for (var i = 0; i < rings.length; ++i) {
                                if (dist >= rings[i].minR && dist <= rings[i].maxR) {
                                    rName = rings[i].name + " (" + rings[i].count + " SH)";
                                    break;
                                } else if (dist < rings[i].minR) {
                                    if (i === 0) rName = "Di Dalam Ring 1";
                                    else rName = "Antara Ring " + i + " & " + (i + 1);
                                    break;
                                }
                            }
                            if (dist > 24320) rName = "Di Luar Ring (>24.3k)";
                            window.cursorRingName = rName;
                        }

                        onWheel: (wheel) => {
                            var zoomFactor = wheel.angleDelta.y > 0 ? 1.25 : 0.8;
                            var newZoom = Math.max(0.003, Math.min(1.5, window.radarZoom * zoomFactor));

                            var cx = (radarCanvas.width / 2) + window.radarPanX;
                            var cy = (radarCanvas.height / 2) + window.radarPanY;

                            window.radarPanX = wheel.x - (wheel.x - cx) * (newZoom / window.radarZoom) - (radarCanvas.width / 2);
                            window.radarPanY = wheel.y - (wheel.y - cy) * (newZoom / window.radarZoom) - (radarCanvas.height / 2);

                            window.radarZoom = newZoom;
                            radarCanvas.requestPaint();
                        }
                    }

                    // 1. HUD Info Kursor (Pojok Kiri Atas)
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: 10
                        width: hudCol.implicitWidth + 20
                        height: hudCol.implicitHeight + 14
                        radius: 6
                        color: "#D90B0F19"
                        border.color: "#1E293B"

                        ColumnLayout {
                            id: hudCol
                            anchors.centerIn: parent
                            spacing: 3
                            RowLayout {
                                spacing: 6
                                Text { text: "Kursor:"; font.bold: true; font.pixelSize: 10; color: textMuted }
                                Text {
                                    text: "X: " + window.cursorBlockX + "   Z: " + window.cursorBlockZ
                                    font.bold: true; font.pixelSize: 11; font.family: "Consolas, monospace"
                                    color: "#FFFFFF"
                                }
                            }
                            RowLayout {
                                spacing: 6
                                Text { text: window.cursorRingName; font.pixelSize: 10; font.bold: true; color: enderCyan }
                                Text {
                                    text: "• Skala: " + (window.radarZoom >= 0.1 ? (window.radarZoom.toFixed(2) + "x") : ("1/" + Math.round(1 / window.radarZoom)))
                                    font.pixelSize: 10; color: textMuted
                                }
                            }
                        }
                    }

                    // 2. Floating Tools (Pojok Kanan Atas)
                    ColumnLayout {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 10
                        spacing: 6

                        // Zoom In
                        Rectangle {
                            width: 32; height: 32; radius: 6
                            color: zoomInHov.hovered ? "#1E293B" : "#D90B0F19"
                            border.color: zoomInHov.hovered ? enderCyan : "#334155"
                            Text { anchors.centerIn: parent; text: "+"; font.bold: true; font.pixelSize: 16; color: textPrimary }
                            HoverHandler { id: zoomInHov; cursorShape: Qt.PointingHandCursor }
                            TapHandler {
                                onTapped: {
                                    window.radarZoom = Math.min(1.5, window.radarZoom * 1.35);
                                    radarCanvas.requestPaint();
                                }
                            }
                        }

                        // Zoom Out
                        Rectangle {
                            width: 32; height: 32; radius: 6
                            color: zoomOutHov.hovered ? "#1E293B" : "#D90B0F19"
                            border.color: zoomOutHov.hovered ? enderCyan : "#334155"
                            Text { anchors.centerIn: parent; text: "−"; font.bold: true; font.pixelSize: 16; color: textPrimary }
                            HoverHandler { id: zoomOutHov; cursorShape: Qt.PointingHandCursor }
                            TapHandler {
                                onTapped: {
                                    window.radarZoom = Math.max(0.003, window.radarZoom / 1.35);
                                    radarCanvas.requestPaint();
                                }
                            }
                        }

                        // Reset Center (0, 0)
                        Rectangle {
                            width: 32; height: 32; radius: 6
                            color: resetHov.hovered ? "#1E293B" : "#D90B0F19"
                            border.color: resetHov.hovered ? enderCyan : "#334155"
                            Text { anchors.centerIn: parent; text: "⌖"; font.bold: true; font.pixelSize: 16; color: "#38BDF8" }
                            HoverHandler { id: resetHov; cursorShape: Qt.PointingHandCursor }
                            TapHandler {
                                onTapped: {
                                    window.radarPanX = 0;
                                    window.radarPanY = 0;
                                    window.radarZoom = 0.045;
                                    radarCanvas.requestPaint();
                                }
                            }
                        }

                        // Focus to Stronghold
                        Rectangle {
                            width: 32; height: 32; radius: 6
                            color: focusHov.hovered ? "#064E3B" : "#D90B0F19"
                            border.color: focusHov.hovered ? eyeGreen : "#334155"
                            Text { anchors.centerIn: parent; text: "★"; font.bold: true; font.pixelSize: 14; color: eyeGreen }
                            HoverHandler { id: focusHov; cursorShape: Qt.PointingHandCursor }
                            TapHandler {
                                onTapped: {
                                    if (window.isCalculated) {
                                        window.radarZoom = 0.07;
                                        window.radarPanX = -(window.overworldBlockX * 0.07);
                                        window.radarPanY = -(window.overworldBlockZ * 0.07);
                                        radarCanvas.requestPaint();
                                    }
                                }
                            }
                        }
                    }

                    // 3. Petunjuk Navigasi (Pojok Kiri Bawah)
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.margins: 10
                        height: 22
                        width: navHint.implicitWidth + 16
                        radius: 4
                        color: "#B30A0D14"
                        border.color: "#1E293B"
                        Text {
                            id: navHint
                            anchors.centerIn: parent
                            text: "🖱️ Geser (Drag) untuk memindahkan • Scroll roda mouse untuk Zoom"
                            font.pixelSize: 10
                            color: "#94A3B8"
                        }
                    }
                }

                // ------------------------------------------
                // TAB 3: ABOUT
                // ------------------------------------------
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 14
                    radius: 8
                    color: bgCard
                    border.color: borderMuted
                    visible: window.currentTab === 3

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 12

                        Rectangle {
                            width: 104
                            height: 104
                            radius: 52
                            color: "#07241E"
                            border.color: enderCyan
                            border.width: 4
                            Layout.alignment: Qt.AlignHCenter

                            Image {
                                anchors.centerIn: parent
                                source: "assets/images/ender_eye.png"
                                width: 56
                                height: 56
                                sourceSize.width: 56
                                sourceSize.height: 56
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }
                        }

                        Text {
                            text: "Calculator Stronghold (TriangulEye)"
                            font.pixelSize: 16
                            font.bold: true
                            color: textPrimary
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Versi 1.1 - Speedrun Edition"
                            font.pixelSize: 12
                            font.bold: true
                            color: enderCyan
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Dibuat dengan C++ Qt 6 & QML untuk performa super cepat & hemat RAM."
                            font.pixelSize: 11
                            color: textMuted
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Dilengkapi Vector Icons SVG beresolusi tinggi."
                            font.pixelSize: 11
                            color: eyeGreen
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }

            // ==========================================
            // 3. TABEL DIMENSI BAWAH (GRIDLAYOUT SEJAJAR SEMPURNA)
            // ==========================================
            Rectangle {
                Layout.fillWidth: true
                height: 145
                color: "#10121B"
                border.color: "#1E2435"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 6

                    // TABEL HASIL DENGAN GRIDLAYOUT (3 KOLOM LEGA - SEL SEBAGAI BUTTON)
                    GridLayout {
                        id: outputTableGrid
                        Layout.fillWidth: true
                        columns: 3
                        columnSpacing: 8
                        rowSpacing: 5

                        // ------------------------------------------
                        // BARIS 0: HEADER TABEL (BIRU/CYAN)
                        // ------------------------------------------
                        Rectangle {
                            Layout.preferredWidth: 125; height: 28; radius: 4; color: "#0E3B54"
                            Text { anchors.centerIn: parent; text: "Dimension"; font.bold: true; font.pixelSize: 11; color: "#E0F2FE" }
                        }
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredWidth: 240; height: 28; radius: 4; color: "#0E3B54"
                            Text { anchors.centerIn: parent; text: "Block Coordinates (X , Z)"; font.bold: true; font.pixelSize: 11; color: "#E0F2FE" }
                        }
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredWidth: 200; height: 28; radius: 4; color: "#0E3B54"
                            Text { anchors.centerIn: parent; text: "Chunk Coordinates [X , Z]"; font.bold: true; font.pixelSize: 11; color: "#E0F2FE" }
                        }

                        // ------------------------------------------
                        // BARIS 1: OVERWORLD
                        // ------------------------------------------
                        // (1, 0) DIMENSI OVERWORLD
                        Rectangle {
                            Layout.preferredWidth: 125; height: 46; radius: 6; color: "#0F281E"; border.color: "#1B4D3A"
                            Row {
                                anchors.centerIn: parent; spacing: 8
                                Image {
                                    source: "assets/images/overworld.png"
                                    width: 18; height: 18
                                    sourceSize.width: 18; sourceSize.height: 18
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text { 
                                    text: "Overworld"
                                    font.bold: true
                                    font.pixelSize: 12
                                    color: "#4ADE80"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        // (1, 1) BUTTON BLOCK COORDINATES OVERWORLD
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredWidth: 240; height: 46; radius: 6
                            color: btnOverBlockHover.hovered ? "#163E2D" : "#0F281E"
                            border.color: btnOverBlockHover.hovered ? eyeGreen : "#1B4D3A"
                            border.width: btnOverBlockHover.hovered ? 2 : 1

                            ColumnLayout {
                                anchors.centerIn: parent; spacing: 2
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 6
                                    Text {
                                        text: window.overworldBlockX + "   ,   " + window.overworldBlockZ
                                        font.bold: true; font.pixelSize: 13; color: "#FFFFFF"
                                        font.family: "Consolas, monospace"
                                    }
                                }
                            }

                            HoverHandler { id: btnOverBlockHover; cursorShape: Qt.PointingHandCursor }
                            TapHandler {
                                onTapped: {
                                    var cmd = "/tp @s " + window.overworldBlockX + " 32 " + window.overworldBlockZ;
                                    if (typeof Clipboard !== "undefined") {
                                        Clipboard.copyText(cmd);
                                    }
                                }
                            }
                        }

                        // (1, 2) BUTTON CHUNK COORDINATES OVERWORLD
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredWidth: 200; height: 46; radius: 6
                            color: btnOverChunkHover.hovered ? "#163E2D" : "#0F281E"
                            border.color: btnOverChunkHover.hovered ? enderCyan : "#1B4D3A"
                            border.width: btnOverChunkHover.hovered ? 2 : 1

                            ColumnLayout {
                                anchors.centerIn: parent; spacing: 2
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 6
                                    Text {
                                        text: "[" + window.overworldChunkX + " , " + window.overworldChunkZ + "]"
                                        font.bold: true; font.pixelSize: 13; color: enderCyan
                                        font.family: "Consolas, monospace"
                                    }
                                }
                            }

                            HoverHandler { id: btnOverChunkHover; cursorShape: Qt.PointingHandCursor }
                            TapHandler {
                                onTapped: {
                                    var chunkText = window.overworldChunkX + " " + window.overworldChunkZ;
                                    if (typeof Clipboard !== "undefined") {
                                        Clipboard.copyText(chunkText);
                                    }
                                }
                            }
                        }

                        // ------------------------------------------
                        // BARIS 2: NETHER
                        // ------------------------------------------
                        // (2, 0) DIMENSI NETHER
                        Rectangle {
                            Layout.preferredWidth: 125; height: 46; radius: 6; color: "#281216"; border.color: "#4C1D24"
                            Row {
                                anchors.centerIn: parent; spacing: 8
                                Image {
                                    source: "assets/images/nether.png"
                                    width: 18; height: 18
                                    sourceSize.width: 18; sourceSize.height: 18
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text { 
                                    text: "Nether"
                                    font.bold: true
                                    font.pixelSize: 12
                                    color: "#F87171"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }

                        // (2, 1) BUTTON BLOCK COORDINATES NETHER
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredWidth: 240; height: 46; radius: 6
                            color: btnNetherBlockHover.hovered ? "#3B181E" : "#281216"
                            border.color: btnNetherBlockHover.hovered ? netherRed : "#4C1D24"
                            border.width: btnNetherBlockHover.hovered ? 2 : 1

                            ColumnLayout {
                                anchors.centerIn: parent; spacing: 2
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 6
                                    Text {
                                        text: window.netherBlockX + "   ,   " + window.netherBlockZ
                                        font.bold: true; font.pixelSize: 13; color: "#FFFFFF"
                                        font.family: "Consolas, monospace"
                                    }
                                }
                            }

                            HoverHandler { id: btnNetherBlockHover; cursorShape: Qt.PointingHandCursor }
                            TapHandler {
                                onTapped: {
                                    var coords = window.netherBlockX + " 64 " + window.netherBlockZ;
                                    if (typeof Clipboard !== "undefined") {
                                        Clipboard.copyText(coords);
                                    }
                                }
                            }
                        }

                        // (2, 2) BUTTON CHUNK COORDINATES NETHER
                        Rectangle {
                            Layout.fillWidth: true; Layout.preferredWidth: 200; height: 46; radius: 6
                            color: btnNetherChunkHover.hovered ? "#3B181E" : "#281216"
                            border.color: btnNetherChunkHover.hovered ? "#E879F9" : "#4C1D24"
                            border.width: btnNetherChunkHover.hovered ? 2 : 1

                            ColumnLayout {
                                anchors.centerIn: parent; spacing: 2
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 6
                                    Text {
                                        text: "[" + window.netherChunkX + " , " + window.netherChunkZ + "]"
                                        font.bold: true; font.pixelSize: 13; color: "#E879F9"
                                        font.family: "Consolas, monospace"
                                    }
                                }
                            }

                            HoverHandler { id: btnNetherChunkHover; cursorShape: Qt.PointingHandCursor }
                            TapHandler {
                                onTapped: {
                                    var chunkText = window.netherChunkX + " " + window.netherChunkZ;
                                    if (typeof Clipboard !== "undefined") {
                                        Clipboard.copyText(chunkText);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ==========================================
    // PARSER LOG F3 + C MINECRAFT OTOMATIS (BACKEND C++)
    // ==========================================
    function parseF3Command(text, targetIndex) {
        controller.parseF3Command(text, targetIndex);
        radarCanvas.requestPaint();
    }

    // ==========================================
    // RUMUS MATEMATIKA TRIANGULASI MINECRAFT (BACKEND C++)
    // ==========================================
    function calculateStronghold() {
        controller.calculateStronghold();
        radarCanvas.requestPaint();
    }
}
