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

#Include third_party/IME/UTF8/IME.ahk

Qwerty := ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "@"
,"a", "s", "d", "f", "g", "h", "j", "k", "l", ";", ":"
,"z", "x", "c", "v", "b", "n", "m", ",", ".", "/"]

Normal := ["そ", "け", "せ", "て", "ょ", "つ", "ん", "の", "を", "り", "ち"
,"は", "か", "し", "と", "た", "く", "う", "い", "゛", "き", "な"
,"す", "こ", "に", "さ", "あ", "っ", "る", "、", "。", "れ"]

Shift := ["ぁ", "゜", "ほ", "ふ", "め", "ひ", "え", "み", "や", "ぬ", "「"
,"ぃ", "へ", "ら", "ゅ", "よ", "ま", "お", "も", "わ", "ゆ", "」"
,"ぅ", "ぇ", "ぉ", "ね", "ゃ", "む", "ろ", "・", "ー", "？"]

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
        Send, % c
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
$VKc0::OnKeypress(11)
$a::OnKeypress(12)
$s::OnKeypress(13)
$d::OnKeypress(14)
$f::OnKeypress(15)
$g::OnKeypress(16)
$h::OnKeypress(17)
$j::OnKeypress(18)
$k::OnKeypress(19)
$l::OnKeypress(20)
$;::OnKeypress(21)
$VKba::OnKeypress(22)
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
    Return

+$VK30::
    Send, _
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

$VK1c::
    if (IME_GET() = 1) {
        Send, {Space}
    } else {
        Send, {VK1c}
    }
    Return
