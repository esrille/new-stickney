;
;  Copyright 2017 Esrille Inc.
;
;  Licensed under the Apache License, Version 2.0 (the "License");
;  you may not use this file except in compliance with the License.
;  You may obtain a copy of the License at
;
;      http://www.apache.org/licenses/LICENSE-2.0
;
;  Unless required by applicable law or agreed to in writing, software
;  distributed under the License is distributed on an "AS IS" BASIS,
;  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;  See the License for the specific language governing permissions and
;  limitations under the License.
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

#Include third_party/IME/UTF8/IME.ahk

Qwerty := ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "\"
,"a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'"
,"z", "x", "c", "v", "b", "n", "m", ",", ".", "/"
,"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "{{}", "{}}", "|"
,"A", "S", "D", "F", "G", "H", "J", "K", "L", ":", """"
,"Z", "X", "C", "V", "B", "N", "M", "<", ">", "?"]

Normal := ["け", "く", "す", "さ", "せ", "つ", "に", "の", "を", "わ", "「", "」", "\"
,"た", "か", "し", "は", "て", "ら", "う", "い", "゛", "な", " "
,"ち", "き", "こ", "と", "よ", "っ", "ん", "、", "。", "ね"]

Shift := ["・", "ひ", "ふ", "へ", "", "", "み", "も", "お", "え", "『", "』", "｜"
,"゜", "そ", "や", "ゆ", "ほ", "れ", "る", "り", "あ", "ま", " "
,"　", "ゐ", "", "ゑ", "", "ろ", "ー", "ぬ", "む", "め"]

; 漢字直接入力(各行の文字キーはおなじキー)
;
; \い 射　\り 生
; \う 売
; \え 得
; \お 負　\を 織
; \か 買　\そ 飼
; \く 欠
; \き 切　\ゐ 着
; \た 裁
; \と 解　\ゑ 説
; \に 似　\み 煮

KanjiNormal := ["け", "欠", "す", "さ", "せ", "つ", "似", "の", "織", "わ", "「", "」", "￥"
,"裁", "買", "し", "は", "て", "ら", "売", "射", "゛", "な", " "
,"ち", "切", "こ", "解", "よ", "っ", "ん", "、", "。", "ね"]

KanjiShift := ["・", "ひ", "ふ", "へ", "", "", "煮", "も", "負", "得", "『", "』", "｜"
,"゜", "飼", "や", "ゆ", "ほ", "れ", "る", "生", "あ", "ま", " "
,"　", "着", "", "説", "", "ろ", "ー", "ぬ", "む", "め"]

PrefixState := 0
Last := ""

IsAlpha(c)
{
    return "a" <= c && c <= "z" || "A" <= c && c <= "Z"
}

OnKeypress(keyName)
{
    global Qwerty, Normal, Shift, KanjiNormal, KanjiShift, PrefixState, Last

    SetStoreCapslockMode, off   ; Do not change CapsLock state

    if (keyName < 35)
        shiftState := 0
    else {
        shiftState := 1
        keyName -= 34
    }
    if (IME_GET() = 0) {
        c := Qwerty[keyName]
        if (!IsAlpha(c)) {
            if (shiftState)
                c := Qwerty[keyName + 34]
        } else if (!GetKeyState("CapsLock", "T")) {
            if (shiftState)
                c := Qwerty[keyName + 34]
        } else if (shiftState) {
            ; This may sound weird, but it seems how AutoHotKey works.
            c := Qwerty[keyName + 34]
        }
        Send, %c%
        Last := ""
    } else {
        state := GetKeyState("Space", "P") or shiftState or PrefixState = 2
        if (Last = "\") {
            if (state)
                c := KanjiShift[keyName]
            else
                c := KanjiNormal[keyName]
            Send, {Backspace}
        } else {
            if (state)
                c := Shift[keyName]
            else
                c := Normal[keyName]
        }
        if (c = "゛") {
            pos := InStr("あいうえおやゆよ", Last)
            if (0 < pos) {
                Send, {Backspace}
                c := SubStr("ぁぃぅぇぉゃゅょ", pos, 1)
            } else {
                pos := InStr("かきくけこさしすせそたちつてとはひふへほ", Last)
                if (0 < pos) {
                    Send, {Backspace}
                    c := SubStr("がぎぐげござじずぜぞだぢづでどばびぶべぼ", pos, 1)
                }
            }
        } else if (c = "゜") {
            pos := InStr("はひふへほ", Last)
            if (0 < pos) {
                Send, {Backspace}
                c := SubStr("ぱぴぷぺぽ", pos, 1)
            }
        }
        if (GetKeyState("CapsLock", "T") = 0)
            Send, % c
        else {
            pos := InStr("あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんがぎぐげござじずぜぞだぢづでどばびぶべぼぁぃぅぇぉゃゅょっぱぴぷぺぽ", c)
            if (0 < pos) {
                d := SubStr("アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲンガギグゲゴザジズゼゾダヂヅデドバビブベボァィゥェォャュョッパピプペポ", pos, 1)
                Send, % d
            } else
                Send, % c
        }
        Last := c
    }
    PrefixState := 0
}

$q::OnKeypress(1)
$w::OnKeypress(2)
$e::OnKeypress(3)
$r::OnKeypress(4)
$t::OnKeypress(5)
$y::OnKeypress(6)
$u::OnKeypress(7)
$i::OnKeypress(8)
$o::OnKeypress(9)
$p::OnKeypress(10)
$[::OnKeypress(11)
$]::OnKeypress(12)
$\::OnKeypress(13)
$a::OnKeypress(14)
$s::OnKeypress(15)
$d::OnKeypress(16)
$f::OnKeypress(17)
$g::OnKeypress(18)
$h::OnKeypress(19)
$j::OnKeypress(20)
$k::OnKeypress(21)
$l::OnKeypress(22)
$;::OnKeypress(23)
$VKde::OnKeypress(24)
$z::OnKeypress(25)
$x::OnKeypress(26)
$c::OnKeypress(27)
$v::OnKeypress(28)
$b::OnKeypress(29)
$n::OnKeypress(30)
$m::OnKeypress(31)
$,::OnKeypress(32)
$.::OnKeypress(33)
$/::OnKeypress(34)
    Return

$+q::OnKeypress(35)
$+w::OnKeypress(36)
$+e::OnKeypress(37)
$+r::OnKeypress(38)
$+t::OnKeypress(39)
$+y::OnKeypress(40)
$+u::OnKeypress(41)
$+i::OnKeypress(42)
$+o::OnKeypress(43)
$+p::OnKeypress(44)
$+[::OnKeypress(45)
$+]::OnKeypress(46)
$+\::OnKeypress(47)
$+a::OnKeypress(48)
$+s::OnKeypress(49)
$+d::OnKeypress(50)
$+f::OnKeypress(51)
$+g::OnKeypress(52)
$+h::OnKeypress(53)
$+j::OnKeypress(54)
$+k::OnKeypress(55)
$+l::OnKeypress(56)
$+;::OnKeypress(57)
$+VKde::OnKeypress(58)
$+z::OnKeypress(59)
$+x::OnKeypress(60)
$+c::OnKeypress(61)
$+v::OnKeypress(62)
$+b::OnKeypress(63)
$+n::OnKeypress(64)
$+m::OnKeypress(65)
$+,::OnKeypress(66)
$+.::OnKeypress(67)
$+/::OnKeypress(68)
    Return

$Space::
    if (IME_GET() = 0)
        Send, {Space}
    if (PrefixState = 2)
        PrefixState = 0
    else
        PrefixState = 1
    Return
$Space Up::
    if (PrefixState = 1)
        PrefixState = 2
    Return
