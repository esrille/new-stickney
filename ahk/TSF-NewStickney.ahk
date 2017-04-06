﻿;
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

#Include third_party/IME/UTF8/IME.ahk

Qwerty := ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]"
,"a", "s", "d", "f", "g", "h", "j", "k", "l", ";"
,"z", "x", "c", "v", "b", "n", "m", ",", ".", "/","'"]

Normal := ["つ", "と", "こ", "く", "け", "や", "ゆ", "よ", "な", "に", "「", "」"
,"た", "は", "し", "か", "て", "ん", "う", "い", "゛", "の"
,"そ", "せ", "す", "き", "さ", "っ", "れ", "、", "。", "を","'"]

Shift := ["", "ち", "ぬ", "ね", "", "む", "め", "お", "ま", "み", "『", "』"
,"゜", "ひ", "ふ", "へ", "ほ", "わ", "る", "り", "あ", "も"
,"", "", "", "", "", "ろ", "ら", "え", "ー", "？", "・"]

ShiftState := 0
Last := ""

OnKeypress(keyName)
{
    global Qwerty, Normal, Shift, ShiftState, Last

    if (IME_GET() = 0) {
        Send, % Qwerty[keyName]
    } else {
        state := GetKeyState("Space", "P")
        if (state = 1 or ShiftState = 2)
            c := Shift[keyName]
        else
            c := Normal[keyName]
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
    ShiftState := 0
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
$a::OnKeypress(13)
$s::OnKeypress(14)
$d::OnKeypress(15)
$f::OnKeypress(16)
$g::OnKeypress(17)
$h::OnKeypress(18)
$j::OnKeypress(19)
$k::OnKeypress(20)
$l::OnKeypress(21)
$;::OnKeypress(22)
$z::OnKeypress(23)
$x::OnKeypress(24)
$c::OnKeypress(25)
$v::OnKeypress(26)
$b::OnKeypress(27)
$n::OnKeypress(28)
$m::OnKeypress(29)
$,::OnKeypress(30)
$.::OnKeypress(31)
$/::OnKeypress(32)
$VKde::OnKeypress(33)
    Return

$Space::
    if (IME_GET() = 0)
        Send, {Space}
    if (ShiftState = 2)
        ShiftState = 0
    else
        ShiftState = 1
    Return
$Space Up::
    if (ShiftState = 1)
        ShiftState = 2
    Return

~LAlt::
    if (IME_GET() = 1) {
        IME_SET(0)
        Send, {Escape}
    }
    Return
RAlt::
    if (IME_GET() = 1) {
        Send, {Space}
    } else {
        IME_SET(1)
    }
    Return
