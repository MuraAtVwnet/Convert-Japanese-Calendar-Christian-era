Param([string]$YMD)


##################################################
# 使用方法
##################################################
function Usage(){
	echo "Usage..."
	echo "    和暦 -> 西暦"
	echo "        ConvJC.ps1 元号99/99/99"
	echo "        ConvJC.ps1 元号99年99月99日"
	echo "            元号: M/T/S/H/明治/大正/昭和/平成"

	echo ""
	echo "    和暦 -> 西暦"
	echo "        ConvJC.ps1 9999/99/99"

	exit
}

##################################################
# 西暦から和暦に変換
##################################################
function Convert2JapaneseCalendar([string]$YMD){


	$InputDateTime = $YMD -as [datetime]
	if( $InputDateTime -eq $null ){
		retrun $null
	}

	$Cultureinfo = New-Object cultureinfo("ja-jp", $true)
	$Cultureinfo.DateTimeFormat.Calendar = New-Object System.Globalization.JapaneseCalendar
	$StingOutputDateTime = $InputDateTime.ToString("gy年M月d日", $Cultureinfo)

	return $StingOutputDateTime
}

##################################################
# 和暦から西暦に変換
##################################################
function Convert2ChristianEra([string]$YMD){
# 和暦 → 西暦
	# 日付分解
	if($YMD -match "(?<Gengo>^.+?)(?<YY>[0-9]+?).(?<MM>[0-9]+?).(?<DD>[0-9]+?) *$"){
		# NOP
	}
	elseif($YMD -match "(?<Gengo>^.+?)(?<YY>[0-9]+?)年(?<MM>[0-9]+?)月(?<DD>[0-9]+?)日"){
		# NOP
	}
	else{
		retrun $null
	}

	$GG = $Matches.Gengo
	$YY = $Matches.YY
	$MM = $Matches.MM
	$DD = $Matches.DD

	# 和暦変換ハッシュテーブル
	$WarekiHash = @{
		"h"		= "平成"
		"s"		= "昭和"
		"m"		= "明治"
		"t"		= "大正"
		"平成"	= "平成"
		"昭和"	= "昭和"
		"明治"	= "明治"
		"大正"	= "大正"
	}

	$Gengo = $WarekiHash[$GG]
	if( $Gengo -eq $null ){
		retrun $null
	}

	[string]$Wareki = $Gengo+$YY + "年" + $MM + "月" + $DD + "日"

	$Cultureinfo = New-Object cultureinfo("ja-jp", $true)
	$Cultureinfo.DateTimeFormat.Calendar = New-Object System.Globalization.JapaneseCalendar
	$OutputDateTime = [datetime]::ParseExact($Wareki, "gy年M月d日", $Cultureinfo)

	$StingOutputDateTime = $OutputDateTime.ToString("yyyy/MM/dd")

	return $StingOutputDateTime
}


##################################################
# Main
##################################################

# 使用方法
if( $YMD -eq [string]$null ){
	Usage
	exit
}

# 余分な空白を取り除く
$YMD = $YMD.Replace(" ","")
$YMD = $YMD.Replace("　","")

if( $YMD[0] -match "[0-9]" ){
	# 西暦が入力されたので和暦にする
	$OutputDateTime = Convert2JapaneseCalendar $YMD
}
else{
	# 和暦がが入力されたので西暦にする
	$OutputDateTime = Convert2ChristianEra $YMD
}

if( $OutputDateTime -eq $null ){
	echo "[FAIL] $OutputDateTime は日付として認識できません"
	exit
}

return $OutputDateTime


