// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function DBToPercent(val){
	return (power(10,(val)/(20))-1);
}

function PercentToDB(val){
	return 20*log10((val)+1);
}