//
// Copyright (C) 2010-2011 Mandriva S.A <http://www.mandriva.com>
// All rights reserved
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., or visit: http://www.gnu.org/.
//
// Author(s): Paulo Belloni <paulo@mandriva.com>
//
//      NOTE: This is based on the homonimous element defined on qt-components-desktop
//

import QtQuick 1.0
//import "./behaviors"    // TextEditMouseBehavior // PBelloni - seems to not be used

// KNOWN ISSUES
// 1) TextField does not loose focus when !enabled if it is a FocusScope (see QTBUG-16161)

FocusScope {
    id: textField

    property bool grabFocusOnHovering: false  // PBelloni
    property alias text: textInput.text
    property alias font: textInput.font

    property int inputHint // values tbd
    property bool acceptableInput: textInput.acceptableInput // read only
    property bool readOnly: textInput.readOnly // read only
    property alias placeholderText: placeholderTextComponent.text
    property bool  passwordMode: false
    property alias selectedText: textInput.selectedText
    property alias selectionEnd: textInput.selectionEnd
    property alias selectionStart: textInput.selectionStart
    property alias validator: textInput.validator
    property alias inputMask: textInput.inputMask
    property alias horizontalalignment: textInput.horizontalAlignment
    property alias echoMode: textInput.echoMode
    property alias cursorPosition: textInput.cursorPosition
    property alias inputMethodHints: textInput.inputMethodHints

    property color textColor: syspal.text
    property color backgroundColor: syspal.base
    property alias containsMouse: mouseArea.containsMouse

    property Component background: null
    property Component hints: null
    property Item backgroundItem: backgroundLoader.item

    property int minimumWidth: 0
    property int minimumHeight: 0

    property int leftMargin: 0
    property int topMargin: 0
    property int rightMargin: 0
    property int bottomMargin: 0

    function copy() {
        textInput.copy()
    }

    function paste() {
        textInput.paste()
    }

    function cut() {
        textInput.cut()
    }

    function select(start, end) {
        textInput.select(start, end)
    }

    function selectAll() {
        textInput.selectAll()
    }

    function selectWord() {
        textInput.selectWord()
    }

    function positionAt(x) {
        var p = mapToItem(textInput, x, 0);
        return textInput.positionAt(p.x);
    }

    function positionToRectangle(pos) {
        var p = mapToItem(textInput, pos.x, pos.y);
        return textInput.positionToRectangle(p);
    }

    width: Math.max(minimumWidth,
                    textInput.width + leftMargin + rightMargin)

    height: Math.max(minimumHeight,
                     textInput.height + topMargin + bottomMargin)

    // Implementation
    clip: true

    SystemPalette { id: syspal }
    Loader { id: hintsLoader; sourceComponent: hints }
    Loader { id: backgroundLoader; sourceComponent: background; anchors.fill:parent}

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {                       //PBelloni
            if (grabFocusOnHovering) {
                textInput.forceActiveFocus()
            }
        }
    }

    TextInput { // see QTBUG-14936
        id: textInput
        selectByMouse:true
        font.pixelSize: hintsLoader.item != null ? hintsLoader.item.fontPixelSize: 14
        font.bold: hintsLoader.item != null ? hintsLoader.item.fontBold : false

        anchors.leftMargin: leftMargin
        anchors.topMargin: topMargin
        anchors.rightMargin: rightMargin
        anchors.bottomMargin: bottomMargin

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        color: enabled ? textColor : Qt.tint(textColor, "#80ffffff")
        echoMode: passwordMode ? _hints.passwordEchoMode : TextInput.Normal
    }

    Text {
        id: placeholderTextComponent
        anchors.fill: textInput
        font: textInput.font
        opacity: !textInput.text.length && !textInput.activeFocus ? 1 : 0
        color: "gray"
        text: qsTr("Enter text")
        Behavior on opacity { NumberAnimation { duration: 90 } }
    }
}
