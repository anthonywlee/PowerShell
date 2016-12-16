####################################
## Created by: Anthony Lee (2016)
## Desc: Decodes url encoded strings
## TODO: Add an encoding function?
#####################################

param(
    [Parameter(Mandatory=$true)]
    [string]$Text,
    [switch]$Decode = $true
)
## The dictionary: keys are the hex values and values are what the hex translates to.
## This list is not complete and was taken from: http://www.w3schools.com/tags/ref_urlencode.asp
$url_dict = @{
    s20 = " ";
    s21 = "!";
    s22 = "'";
    s23 = "#";
    s24 = "$";
    s26 = "&";
    s27 = '"';
    s28 = "(";
    s29 = ")";
    s2A = "*";
    s2B = "+";
    s2C = ",";
    s2D = "-";
    s2E = ".";
    s2F = "/";
    s30 = "0";
    s31 = "1";
    s32 = "2";
    s33 = "3";
    s34 = "4";
    s35 = "5";
    s36 = "6";
    s37 = "7";
    s38 = "8";
    s39 = "9";
    s3A = ":";
    s3B = ";";
    s3C = "<";
    s3D = "=";
    s3E = ">";
    s3F = "?";
    s40 = "@";
    s41 = "A";
    s42 = "B";
    s43 = "C";
    s44 = "D";
    s45 = "E";
    s46 = "F";
    s47 = "G";
    s48 = "H";
    s49 = "I";
    s4A = "J";
    s4B = "K";
    s4C = "L";
    s4D = "M";
    s4E = "N";
    s4F = "O";
    s50 = "P";
    s51 = "Q";
    s52 = "R";
    s53 = "S";
    s54 = "T";
    s55 = "U";
    s56 = "V";
    s57 = "W";
    s58 = "X";
    s59 = "Y";
    s5A = "Z";
    s5B = "[";
    s5C = "\";
    s5D = "]";
    s5E = "^";
    s5F = "_";
    s60 = "``";
    s61 = "a";
    s62 = "b";
    s63 = "c";
    s64 = "d";
    s65 = "e";
    s66 = "f";
    s67 = "g";
    s68 = "h";
    s69 = "i";
    s6A = "j";
    s6B = "k";
    s6C = "l";
    s6D = "m";
    s6E = "n";
    s6F = "o";
    s70 = "p";
    s71 = "q";
    s72 = "r";
    s73 = "s";
    s74 = "t";
    s75 = "u";
    s76 = "v";
    s77 = "w";
    s78 = "x";
    s79 = "y";
    s7A = "z";
    s7B = "{";
    s7C = "|";
    s7D = "}";
    s7E = "~";
    s82 = "‚"
}

function main{
    if($Decode -eq $true){
        Decode $Text
    }
}

function Decode{
    param(
        [Parameter(Mandatory=$true,Position=1)]
        [string]$Text
    )
    $array = $Text.split("%")

    for($i=0;$i -le $array.Length;$i++){
        $char = "s"+$array[$i]
        $value = $url_dict.Item($char)
        $result += $value
    }

    return $result
}

Main